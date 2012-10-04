
HADOOP_HOME=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1/contrib/streaming/hadoop-0.20.1-streaming.jar 


### count based on merged T1&T2 data ###


INPUT_HOME=/output/merged/event1249incr_T1_1226-0209_T2_0201-0223-pixels_googleseg
OUTDIR_HOME=/output/merged/event1249incr_T1_1226-0209_T2_0201-0223-pixels_googleseg_count

$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME_STREAMING -D mapred.reduce.tasks=500 -D mapred.job.name=merged_googleseg_count_yqu -input ${INPUT_HOME} -output ${OUTDIR_HOME} -mapper 'python map_count_pri.py' -file 'map_count_pri.py' -reducer 'python red_metrics.py' -file 'red_metrics.py'

