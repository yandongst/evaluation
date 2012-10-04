
HADOOP_HOME=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1/contrib/streaming/hadoop-0.20.1-streaming.jar





### T1 data set ###

INPUT_HOME=/input/user_model/sharethis-insights-backup/model/20120229/incr/finaldata
OUTDIR_HOME=/output/merged/event1249_T1_0229incr

input_path=""
for e in 1 2 4 9
do
  input_path+=${INPUT_HOME}/${e},
done

l=`expr length $input_path`
input_path2=${input_path:0:$l-1}


$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME_STREAMING -D mapred.reduce.tasks=500 -D mapred.job.name=event1249incr_merge_yqu -input ${input_path2} -output ${OUTDIR_HOME}/event1249_T1_1226-0209_incr -mapper 'python map_user_model.py' -reducer 'python red_user_model_or_camp.py' -file 'map_user_model.py' -file 'red_user_model_or_camp.py'
