
HADOOP_HOME=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1/contrib/streaming/hadoop-0.20.1-streaming.jar



### T1 data set ###

INPUT_T1_USER_MODEL=/output/merged/T1-20120314-20120320_e1249
INPUT_T1_CAMPAIGN=/output/merged/camp_T1_0314-0320
OUTDIR_HOME=/output/merged/T1-20120314-20120320-usermodel-camp

### MERGE T1 AND T2

$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME_STREAMING -D mapred.reduce.tasks=500 -D mapred.job.name=event1249_camp_merge_yqu -input ${INPUT_T1_USER_MODEL} -input ${INPUT_T1_CAMPAIGN} -output ${OUTDIR_HOME} -mapper 'cat' -reducer 'python red_merge_usermodel_camp.py' -file 'red_merge_usermodel_camp.py'
