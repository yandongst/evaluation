ACCDIR=/home/yandong

function cp_data() {
    date=$1
    hadoop fs -test -d /projects/input/user_campaign/user_campaign_table/${date} 2> /dev/null
    if [ $? -ne 0 ]
    then
      echo COPYING:hadoop distcp -conf ${ACCDIR}/account/insight-site.xml s3n://campaign-analytics/aggregate_campaign_data/user_campaign_table/dt=${date} /input/user_campaign/user_campaign_table/${date}
      hadoop distcp -conf ${ACCDIR}/account/insight-site.xml s3n://campaign-analytics/aggregate_campaign_data/user_campaign_table/dt=${date} /projects/input/user_campaign/user_campaign_table/${date}
  else
    echo WARNING: path already exists! /projects/input/user_campaign/user_campaign_table/${date}. skip copying...
    fi
}

function info() {
  echo -e "\n"
  echo "#####          COPY CAMPAIGN DATA TO HDFS        #####"
  echo "##### any question, write to yandong@sharethis.com #####"
  echo -e "\n"
}

function usage() {
  echo "Usage: $0 month1 day1 month2 day2"
  echo "  e.g. $0 03 20 04 05"
  exit 1
}

info

if [ $# -ne 5 ]
then
  usage
fi

year=$1
m1=$2
d1=$3
m2=$4
d2=$5

printf -v T1 "%04d%02d%02d-%04d%02d%02d" $year $m1 $d1 $year $m2 $d2

echo copying data of timeperiod:${T1}

#####same month
if [ $m1 -eq $m2 ]
then 
  for (( d=$d1; d <= $d2; d++ ))
  do
    printf -v date "%04d%02d%02i" $year $m1 $d
    cp_data $date
  done 
else
#####diff months

  #######first month
  for (( d=$d1; d <= 31; d++ ))
  do
    printf -v date "%04d%02d%02i" $year $m1 $d
    cp_data $date
  done

  let m_start=$m1+1
  let m_end=$m2-1

  #######mid months 
  for (( m=$m_start; m <=$m_end; m++ ))
  do 
    for (( d=1; d <= 31; d++ ))
    do
      printf -v date "%04d%02d%02i" $year $m $d
      cp_data $date 
    done
  done

  #######last month
  for (( d=1; d <= $d2; d++ ))
  do
    printf -v date "%04d%02d%02i" $year $m2 $d
    cp_data $date
  done

fi

