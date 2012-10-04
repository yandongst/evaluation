
HADOOP_HOME=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1/contrib/streaming/hadoop-0.20.1-streaming.jar 
PYDIR="/data/4/yandong/projects/ae/"


### add seg tags ###
### format: ###
### cookie \t tag1,tag2 ### 
year=$1

#T1
t1_m1=$2
t1_d1=$3
t1_m2=$4
t1_d2=$5

#T2
t2_m1=$6
t2_d1=$7
t2_m2=$8
t2_d2=$9 

fn_path=${10}

### T1 data set ###

printf -v T1_start "%04d%02d%02d" $year $t1_m1 $t1_d1
printf -v T1_end "%04d%02d%02d" $year $t1_m2 $t1_d2
printf -v T2_start "%04d%02d%02d" $year $t2_m1 $t2_d1
printf -v T2_end "%04d%02d%02d" $year $t2_m2 $t2_d2

INPUT_HOME=/output/merged/usermodel-camp-T1-${T1_start}-${T1_end}-T2-${T2_start}-${T2_end}
OUTDIR_HOME=/output/merged/usermodel-camp-T1-${T1_start}-${T1_end}-T2-${T2_start}-${T2_end}-tagseg

#fn_path=2012032_disney_domestic_adgroups_aggregated.txt
#fn_f=2012032_disney_domestic_adgroups_aggregated.txt

echo $HADOOP_HOME/bin/hadoop jar $HADOOP_HOME_STREAMING -D mapred.reduce.tasks=500 -D mapred.job.name=add_tag_seg -input ${INPUT_HOME} -output ${OUTDIR_HOME} -mapper "python map_tag_segs.py $fn_path" -file 'map_tag_segs.py' -reducer 'cat' -file "$PYDIR/$fn_path"
$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME_STREAMING -D mapred.reduce.tasks=500 -D mapred.job.name=add_seg_tag -input ${INPUT_HOME} -output ${OUTDIR_HOME} -mapper "python map_tag_segs.py $fn_path" -file 'map_tag_segs.py' -reducer 'cat' -file "$PYDIR/$fn_path"

