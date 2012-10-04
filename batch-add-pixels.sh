
HADOOP_HOME=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1/contrib/streaming/hadoop-0.20.1-streaming.jar


INPUT_HOME=/output/merged/event1249incr_T1_1226-0209_T2_0201-0223
INPUT_HOME2=/input/lal/20120209_LAL
OUTDIR_HOME=/output/merged/event1249incr_T1_1226-0209_T2_0201-0223-pixels

### ADD PIXELS


echo $HADOOP_HOME/bin/hadoop jar $HADOOP_HOME_STREAMING -D mapred.reduce.tasks=500 -D mapred.job.name=add_pixels_yqu -input ${INPUT_HOME},${INPUT_HOME2}  -output ${OUTDIR_HOME} -mapper 'cat' -reducer 'python red_add_pixel.py' -file 'red_add_pixel.py'
$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME_STREAMING -D mapred.reduce.tasks=500 -D mapred.job.name=add_pixels_yqu -input ${INPUT_HOME},${INPUT_HOME2}  -output ${OUTDIR_HOME} -mapper 'cat' -reducer 'python red_add_pixel.py' -file 'red_add_pixel.py'


