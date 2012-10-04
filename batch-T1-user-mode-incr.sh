#!/usr/bin/env sh
#HADOOP_HOME=/usr
#HADOOP_HOME_STREAMING=/usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-0.23.1-mr1-cdh4.0.0b2.jar
hstream='hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-0.23.1-mr1-cdh4.0.0b2.jar -D mapred.output.compress=true -D mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec'


### T1 data set ###

#/input/user_model/sharethis-insights-backup/model/20120317



INPUT_HOME=/projects/input/user_model/sharethis-insights-backup/model/
printf -v OUTDIR_HOME "/projects/output/merged/usermodel-T1-incr"

input_path="" 

for date in "$@"
do
  for event in 1 2 4 9 5
  do
    input_path+=${INPUT_HOME}/${date}/incr/finaldata/${event},
  done
done




l=`expr length $input_path`
input_path2=${input_path:0:$l-1}
pythonbin=/usr/bin/python2.7


echo $hstream -D mapred.reduce.tasks=500 -D mapred.job.name=T1-usermodel-merge -input ${input_path2} -output ${OUTDIR_HOME} -mapper "$pythonbin map_user_model.py" -reducer "$pythonbin red_user_model_or_camp.py" -file 'map_user_model.py' -file 'red_user_model_or_camp.py'
$hstream -D mapred.reduce.tasks=500 -D mapred.job.name=T1-usermodel-merge -input ${input_path2} -output ${OUTDIR_HOME} -mapper "$pythonbin map_user_model.py" -reducer "$pythonbin red_user_model_or_camp.py" -file 'map_user_model.py' -file 'red_user_model_or_camp.py'
