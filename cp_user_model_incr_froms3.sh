ACCDIR=/home/yandong
function cp_data() {
    date=$1
    event=$2
    #/sharethis-insights-backup/model/20120613/incr/finaldata/
    hadoop fs -test -d /projects/input/user_model/sharethis-insights-backup/model/${date}/incr/finaldata/${event} 2> /dev/null
    #echo return value $?
    #hadoop fs -test -z /input/user_model/sharethis-insights-backup/model/${date}/query/updated/${event} 2> /dev/null
    #echo return value $?
    #hadoop fs -test -e /input/user_model/sharethis-insights-backup/model/${date}/query/updated/${event} 2> /dev/null
    #echo return value $?
    if [ $? -ne 0 ]
    then
      echo [COPYING]: hadoop distcp -conf ${ACCDIR}/account/insight-site.xml s3n://sharethis-insights-backup/model/${date}/incr/finaldata/${event} /projects/input/user_model/sharethis-insights-backup/model/${date}/incr/finaldata/${event}
      hadoop distcp -conf ${ACCDIR}/account/insight-site.xml -update s3n://sharethis-insights-backup/model/${date}/incr/finaldata/${event} /projects//input/user_model/sharethis-insights-backup/model/${date}/incr/finaldata/${event}
    else
      echo [WARNING]: path already exists! /projects/input/user_model/sharethis-insights-backup/model/${date}/incr/finaldata/${event}. skip copying...
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


#if [[ "$m1" -lt 1 || "$m1" -gt 12  ]]
#then
  #echo go
#fi

#if [ ${#m1} -ne 2 -o ${#m2} -ne 2 ]
#then
  #echo Month $m1 or $m2 is in wrong format. It must be written as m%m%
  #exit 1
#fi


echo copying user model data of T1:${T1}

#####same month
if [ $m1 -eq $m2 ]
then 
  for event in 1 2 4 9 5
  do
    for (( d=$d1; d <= $d2; d++ ))
    do
      printf -v date "%04d%02d%02d" $year $m1 $d
      cp_data $date $event
    done
  done

else
#####diff months

  #######first month
  for event in 1 2 4 9 5
  do
    for (( d=$d1; d <= 31; d++ ))
    do
      printf -v date "%04d%02d%02d" $year $m1 $d
      cp_data $date $event
    done
  done

  let m_start=$m1+1
  let m_end=$m2-1

  #######mid months 
  for (( m=$m_start; m <=$m_end; m++ ))
  do 
    for event in 1 2 4 9 5
    do
      for (( d=1; d <= 31; d++ ))
      do
        printf -v date "%04d%02d%02d" $year $m $d
        cp_data $date $event
      done
    done
  done

  #######last month
  for event in 1 2 4 9 5
  do
    for (( d=1; d <= $d2; d++ ))
    do
      printf -v date "%04d%02d%02d" $year $m2 $d
      cp_data $date $event
    done
  done

fi

