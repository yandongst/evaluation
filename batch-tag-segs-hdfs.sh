
hstream='hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-0.23.1-mr1-cdh4.0.0b2.jar -D mapred.output.compress=true -D mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec'
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

INPUT_HOME=/projects/output/merged/usermodel-camp-T1-${T1_start}-${T1_end}-T2-${T2_start}-${T2_end}
OUTDIR_HOME=/projects/output/merged/usermodel-camp-T1-${T1_start}-${T1_end}-T2-${T2_start}-${T2_end}-tagseg

#INPUT_HOME=/output/merged/usermodel-camp-T1-20120326-20120331-T2-20120326-20120331
#INPUT_SHUFFLE=/projects/input/shuffleddata/20120514/
INPUT_SHUFFLE=/projects/input/segtags/201205030521/starwars_mapping.txt.gz
#OUTDIR_HOME=/output/merged/usermodel-camp-T1-20120326-20120331-T2-20120326-20120331-shuffledata


echo $hstream -D mapred.reduce.tasks=500 -D mapred.job.name=add_seg_tag -input ${INPUT_HOME},${INPUT_SHUFFLE} -output ${OUTDIR_HOME} -mapper "$pythonbin map_tag_segs_hdfs.py" -file 'map_tag_segs_hdfs.py' -reducer "$pythonbin red_tag_seg_hdfs.py"  -file 'red_tag_seg_hdfs.py'
$hstream -D mapred.reduce.tasks=500 -D mapred.job.name=add_seg_tag -input ${INPUT_HOME},${INPUT_SHUFFLE} -output ${OUTDIR_HOME} -mapper "$pythonbin map_tag_segs_hdfs.py" -file 'map_tag_segs_hdfs.py' -reducer "$pythonbin red_tag_seg_hdfs.py"  -file 'red_tag_seg_hdfs.py'
