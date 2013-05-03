src=s3n://sharethis-campaign-analytics/uct/
dest=/projects/science/input/uct
ACCDIR=/home/yandong

if [ $# -ne 5 ]
then
  echo 'not enough parameters'
  exit 1
fi

year=$1
m1=$2
d1=$3
m2=$4
d2=$5 

function cp_data() {
  date=$1
  hadoop fs -test -d $dest/${date}/daily 2> /dev/null
  if [ $? -ne 0 ]
  then
    echo COPYING: hadoop distcp -update hdfs://ads-nn1.east.sharethis.com:8020/projects/campaign_analytics/prod/uct/${date}/daily $dest/${date}/daily
    hadoop distcp -update hdfs://ads-nn1.east.sharethis.com:8020/projects/campaign_analytics/prod/uct/${date}/daily $dest/${date}/daily
    echo COPYING: hadoop distcp $src/$date/daily $dest/${date}/daily
    hadoop distcp -conf ${ACCDIR}/account/prod-site.xml -update $src/$date/daily $dest/${date}/daily
  else
    echo WARNING: path already exists! $dest/${date}/daily. skip copying...
    fi
}

#####same month
if [ $m1 -eq $m2 ]
then 
    for (( d=$d1; d <= $d2; d++ ))
    do
      printf -v date "%04d%02d%02d" $year $m1 $d
      cp_data $date
    done

else
#####diff months

  #######first month
    for (( d=$d1; d <= 31; d++ ))
    do
      printf -v date "%04d%02d%02d" $year $m1 $d
      cp_data $date
    done

  let m_start=$m1+1
  let m_end=$m2-1

  #######mid months 
  for (( m=$m_start; m <=$m_end; m++ ))
  do 
      for (( d=1; d <= 31; d++ ))
      do
        printf -v date "%04d%02d%02d" $year $m $d
        cp_data $date
      done
  done

  #######last month
    for (( d=1; d <= $d2; d++ ))
    do
      printf -v date "%04d%02d%02d" $year $m2 $d
      cp_data $date
  done

fi
