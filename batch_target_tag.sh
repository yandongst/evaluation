
HADOOP_HOME=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1/contrib/streaming/hadoop-0.20.1-streaming.jar 


### count based on merged T1&T2 data ###


INPUT_HOME=/output/merged/usermodel-camp-T1-20120326-20120331-T2-20120326-20120331
OUTDIR_HOME=/output/merged/usermodel-camp-T1-20120326-20120331-T2-20120326-20120331-prius

$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME_STREAMING -D mapred.reduce.tasks=500 -D mapred.job.name=merged_googlekeywords_yqu -input ${INPUT_HOME} -output ${OUTDIR_HOME} -mapper 'python map_tag_target.py toyota_prius_keywords.txt prius_seg' -file 'map_tag_target.py' -reducer 'cat' -file 'prius/toyota_prius_keywords.txt'

