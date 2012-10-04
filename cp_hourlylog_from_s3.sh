ACCDIR=/home/yandong
function cp_data() {
    date=$1
    hour=$2
    hadoop fs -test -d /projects/input/hourly-logprocessing/${date}${hour} 2> /dev/null
    if [ $? -ne 0 ]
    then
      echo [COPYING]: hadoop distcp -conf ${ACCDIR}/account/prod-site.xml s3n://hourly-logprocessing/${date}${hour} /projects/input/hourly-logprocessing/${date}${hour}
      hadoop distcp -conf ${ACCDIR}/account/prod-site.xml -update s3n://hourly-logprocessing/${date}${hour} /projects/input/hourly-logprocessing/${date}${hour}
    else
      echo [WARNING]: path already exists! /projects/input/hourly-logprocessing/${date}${hour}. skip copying...
    fi
}

function info() {
  echo -e "\n"
  echo "#####          COPY USER MODEL DATA TO HDFS        #####"
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


echo copying hourly logprocessing data of T1:${T1}

#####same month
if [ $m1 -eq $m2 ]
then 
  for hr in `seq 0 23`
  do
    for (( d=$d1; d <= $d2; d++ ))
    do
      printf -v date "%04d%02d%02d" $year $m1 $d
      printf -v hour "%02d" $hr
      cp_data $date $hour
    done
  done

else
#####diff months

  #######first month
  for event in `seq 0 23`
  do
    for (( d=$d1; d <= 31; d++ ))
    do
      printf -v date "%04d%02d%02d" $year $m1 $d
      printf -v hour "%02d" $hr
      cp_data $date $hour
    done
  done

  let m_start=$m1+1
  let m_end=$m2-1

  #######mid months 
  for (( m=$m_start; m <=$m_end; m++ ))
  do 
    for event in `seq 0 23`
    do
      for (( d=1; d <= 31; d++ ))
      do
        printf -v date "%04d%02d%02d" $year $m $d
        printf -v hour "%02d" $hr
        cp_data $date $hour
      done
    done
  done

  #######last month
  for event in `seq 0 23`
  do
    for (( d=1; d <= $d2; d++ ))
    do
      printf -v date "%04d%02d%02d" $year $m2 $d
      printf -v hour "%02d" $hr
      cp_data $date $hour
    done
  done

fi

