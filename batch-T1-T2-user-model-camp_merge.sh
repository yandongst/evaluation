hstream='hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.1.2.jar -D mapred.output.compress=true -D mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec'
pythonbin=/usr/bin/python2.7
PYDIR="/home/yandong/workspace/ae"

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

echo "######DATA RANGE:  T1: ${T1_start} - ${T1_end}##########"
echo "######DATA RANGE:  T2: ${T2_start} - ${T2_end}##########"

INPUT_HOME=/projects/science/output/merged
OUTDIR_HOME=/projects/science/output/merged/usermodel-camp-T1-${T1_start}-${T1_end}-T2-${T2_start}-${T2_end}
#OUTDIR_HOME=/projects/output/merged/usermodel_w5-camp-T1-${T1_start}-${T1_end}-T2-${T2_start}-${T2_end}

### MERGE T1 AND T2

input_camp_t1=${INPUT_HOME}/camp-T1-${T1_start}-${T1_end}
input_camp_t2=${INPUT_HOME}/camp-T2-${T2_start}-${T2_end}
input_user_model=${INPUT_HOME}/usermodel-T1-${T1_start}-${T1_end}
#input_user_model=${INPUT_HOME}/usermodel-T1-${T1_start}-${T1_end}_w5

echo $hstream -D mapred.reduce.tasks=500 -D mapred.job.name=T1-T2-camp-usermodel-merge -input $input_camp_t1,$input_camp_t2,${input_user_model} -output ${OUTDIR_HOME} -mapper 'cat' -reducer "$pythonbin red_merge_usermodel_camp.py" -file "$PYDIR/red_merge_usermodel_camp.py"
$hstream -D mapred.reduce.tasks=500 -D mapred.job.name=T1-T2-camp-usermodel-merge -input $input_camp_t1,$input_camp_t2,${input_user_model} -output ${OUTDIR_HOME} -mapper 'cat' -reducer "$pythonbin red_merge_usermodel_camp.py" -file "$PYDIR/red_merge_usermodel_camp.py"

### T2 eval set ###

