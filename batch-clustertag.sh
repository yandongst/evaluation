hstream='hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.1.2.jar -D mapred.output.compress=true -D mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec'
pythonbin=/usr/bin/python2.7


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


### T1 data set ###

printf -v T1_start "%04d%02d%02d" $year $t1_m1 $t1_d1
printf -v T1_end "%04d%02d%02d" $year $t1_m2 $t1_d2
printf -v T2_start "%04d%02d%02d" $year $t2_m1 $t2_d1
printf -v T2_end "%04d%02d%02d" $year $t2_m2 $t2_d2

fn_topic=/data/4/yandong/projects/cluster/GibbsLDA++-0.2/data/travel/5p/5000iters/model-final.twords
fn_topic=/data/4/yandong/projects/cluster/GibbsLDA++-0.2/data/travel/5p/model-final.twords
tag='v_travel_new_0.001_l0_5'

INPUT_HOME=/projects/output/merged/usermodel-camp-T1-${T1_start}-${T1_end}-T2-${T2_start}-${T2_end}
OUTDIR_HOME=/projects/output/merged/usermodel-camp-T1-${T1_start}-${T1_end}-T2-${T2_start}-${T2_end}-$tag


echo $hstream -D mapred.reduce.tasks=500 -D mapred.job.name=cluster_tag -input ${INPUT_HOME} -output ${OUTDIR_HOME} -mapper "cat"  -reducer "$pythonbin red_labeluser_bykw.py model-final.twords $tag"  -file 'red_labeluser_bykw.py' -file "$fn_topic"
$hstream -D mapred.reduce.tasks=500 -D mapred.job.name=cluster_tag -input ${INPUT_HOME} -output ${OUTDIR_HOME} -mapper "cat" -reducer "$pythonbin red_labeluser_bykw.py model-final.twords $tag"  -file 'red_labeluser_bykw.py' -file "$fn_topic"
