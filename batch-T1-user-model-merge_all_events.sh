#!/usr/bin/env sh
hstream='hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.1.2.jar -D mapred.output.compress=true -D mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec'
PYDIR="/home/yandong/workspace/ae"


### T1 data set ###

function usage() {
  echo "Usage: $0 year month1 day1 month2 day2"
  echo "  e.g. $0 2012 03 20 04 05"
  exit 1
}

if [ $# -ne 5 ]
then
  usage
fi

year=$1
m1=$2
d1=$3
m2=$4
d2=$5

INPUT_HOME=/projects/science/input/user_model/sharethis-insights-backup/model/
printf -v OUTDIR_HOME "/projects/science/output/merged/usermodel-T1-%04d%02d%02d-%04d%02d%02d" $year $m1 $d1 $year $m2 $d2

input_path="" 

event_seq="1 2 4 5 9"

#####same month
if [ $m1 -eq $m2 ]
then
  for event in $event_seq
  do
    for (( d=$d1; d <= $d2; d++ ))
    do
      printf -v date "%04d%02d%02i" $year $m1 $d
      hadoop fs -test -d ${INPUT_HOME}/${date}/query/updated/${event} 2> /dev/null
      if [ $? -eq 0 ]
      then
        input_path+=${INPUT_HOME}/${date}/query/updated/${event},
      else
        echo ${INPUT_HOME}/${date}/query/updated/${event}, doesnt exist!
      fi
    done
  done

else
#####diff months 
  #######first month
  for event in $event_seq
  do
    for (( d=$d1; d <= 31; d++ ))
    do
      printf -v date "%04d%02d%02d" $year $m1 $d
      hadoop fs -test -d ${INPUT_HOME}/${date}/query/updated/${event} 2> /dev/null
      if [ $? -eq 0 ]
      then
        input_path+=${INPUT_HOME}/${date}/query/updated/${event},
      else
        echo ${INPUT_HOME}/${date}/query/updated/${event}, doesnt exist!
      fi
    done
  done

  let m_start=$m1+1
  let m_end=$m2-1

  #######mid months 
  for (( m=$m_start; m <=$m_end; m++ ))
  do 
    for event in $event_seq
    do
      for (( d=1; d <= 31; d++ ))
      do
        printf -v date "%04d%02d%02d" $year $m $d
        #input_path+=${INPUT_HOME}/${date}/query/updated/${event},
        hadoop fs -test -d ${INPUT_HOME}/${date}/query/updated/${event} 2> /dev/null
        if [ $? -eq 0 ]
        then
          input_path+=${INPUT_HOME}/${date}/query/updated/${event},
        else
          echo ${INPUT_HOME}/${date}/query/updated/${event}, doesnt exist!
        fi
      done
    done
  done

  #######last month
  for event in $event_seq
  do
    for (( d=1; d <= $d2; d++ ))
    do
      printf -v date "%04d%02d%02d" $year $m2 $d
      #input_path+=${INPUT_HOME}/${date}/query/updated/${event},
      hadoop fs -test -d ${INPUT_HOME}/${date}/query/updated/${event} 2> /dev/null
      if [ $? -eq 0 ]
      then
        input_path+=${INPUT_HOME}/${date}/query/updated/${event},
      else
        echo ${INPUT_HOME}/${date}/query/updated/${event}, doesnt exist!
      fi
    done
  done

fi



l=`expr length $input_path`
input_path2=${input_path:0:$l-1}
pythonbin=/usr/bin/python2.7


echo $hstream -D mapred.reduce.tasks=500 -D mapred.job.name=T1-usermodel-merge -input ${input_path2} -output ${OUTDIR_HOME} -mapper "$pythonbin map_user_model.py" -reducer "$pythonbin red_user_model_or_camp.py" -file "$PYDIR/map_user_model.py" -file "$PYDIR/red_user_model_or_camp.py"
$hstream -D mapred.reduce.tasks=500 -D mapred.job.name=T1-usermodel-merge -input ${input_path2} -output ${OUTDIR_HOME} -mapper "$pythonbin map_user_model.py" -reducer "$pythonbin red_user_model_or_camp.py" -file "$PYDIR/map_user_model.py" -file "$PYDIR/red_user_model_or_camp.py"
