
HADOOP_HOME=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1/contrib/streaming/hadoop-0.20.1-streaming.jar 


### count based on merged T1&T2 data ###


INPUT_HOME=/output/merged/event1249incr_T1_0229_T2_0301_0311
OUTDIR_HOME=/output/merged/event1249incr_T1_0229_T2_0301_0311_disney_tier1

INPUT_HOME=/output/merged/event1249incr_T1_0229_T2_0301_0311_disney_tier2
OUTDIR_HOME=/output/merged/event1249incr_T1_0229_T2_0301_0311_disney_tier3

fn_path=T1_0229inc_T2_0301_0311/disney_tier3_feature.txt
fn_f=disney_tier3_feature.txt

$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME_STREAMING -D mapred.reduce.tasks=500 -D mapred.job.name=event1249_camp_merge_yqu_count -input ${INPUT_HOME} -output ${OUTDIR_HOME} -mapper "python map_tag_user.py $fn_f disney_tier3" -file 'map_tag_user.py' -reducer 'cat' -file "$fn_path"

