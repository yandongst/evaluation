hstream='hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.1.2.jar -D mapred.output.compress=true -D mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec'
pythonbin=/usr/bin/python2.7
PYDIR="/home/yandong/workspace/ae"

### count based on merged T1&T2 data ###

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

#tagseg
tagseg=${10}

echo tagseg:$tagseg

printf -v T1_start "%04d%02d%02d" $year $t1_m1 $t1_d1
printf -v T1_end "%04d%02d%02d" $year $t1_m2 $t1_d2
printf -v T2_start "%04d%02d%02d" $year $t2_m1 $t2_d1
printf -v T2_end "%04d%02d%02d" $year $t2_m2 $t2_d2

INPUT_HOME=/projects/science/output/merged/usermodel-camp-T1-${T1_start}-${T1_end}-T2-${T2_start}-${T2_end}
OUTDIR_HOME=/projects/science/output/merged/usermodel-camp-T1-${T1_start}-${T1_end}-T2-${T2_start}-${T2_end}-count

if [ $tagseg == 1 ]
then
  INPUT_HOME=/projects/science/output/merged/usermodel-camp-T1-${T1_start}-${T1_end}-T2-${T2_start}-${T2_end}-tagseg
  OUTDIR_HOME=/projects/science/output/merged/usermodel-camp-T1-${T1_start}-${T1_end}-T2-${T2_start}-${T2_end}-tagseg-count
fi



echo $hstream -D mapred.reduce.tasks=500 -D mapred.job.name=count -input ${INPUT_HOME} -output ${OUTDIR_HOME} -mapper "$pythonbin map_count_pri.py" -file "$PYDIR/map_count_pri.py" -reducer "$pythonbin red_metrics.py" -file "$PYDIR/red_metrics.py"
$hstream -D mapred.reduce.tasks=500 -D mapred.job.name=count -input ${INPUT_HOME} -output ${OUTDIR_HOME} -mapper "$pythonbin map_count_pri.py" -file "$PYDIR/map_count_pri.py" -reducer "$pythonbin red_metrics.py" -file "$PYDIR/red_metrics.py"

