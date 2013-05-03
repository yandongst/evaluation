hstream='hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.1.2.jar -D mapred.output.compress=true -D mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec'
pythonbin=/usr/bin/python2.7
PYDIR="/home/yandong/workspace/ae"

### T1 data set ###


year=$1
m1=$2
d1=$3
m2=$4
d2=$5 
T1_2=$6


printf -v OUTDIR_HOME "/projects/science/output/merged/camp-%s-%04d%02d%02d-%04d%02d%02d" $T1_2 $year $m1 $d1 $year $m2 $d2

input_op_pre='/projects/science/input/uct/'
input_op_post='daily'
input_path="" 

function check_and_cp() {
  echo check_and_cp $1
  path=${input_op_pre}${1}/${input_op_post}
  hadoop fs -test -z $path 2> /dev/null
  if [ $? -eq 0 ]
  then
    echo input_path+=$path
    input_path+="-input ${path} "
  else
    echo $path doesnt exist!
  fi
}


#####same month
if [ $m1 -eq $m2 ]
then
  for (( d=$d1; d <= $d2; d++ ))
  do
    printf -v date "%04d%02d%02i" $year $m1 $d
    check_and_cp ${date}
  done

else
#####diff months 
  #######first month
  for (( d=$d1; d <= 31; d++ ))
  do
    printf -v date "%04d%02d%02d" $year $m1 $d
    check_and_cp ${date}
  done

  let m_start=$m1+1
  let m_end=$m2-1

  #######mid months 
  for (( m=$m_start; m <=$m_end; m++ ))
  do 
    for (( d=1; d <= 31; d++ ))
    do
      printf -v date "%04d%02d%02d" $year $m $d
      check_and_cp ${date}
    done
  done

  #######last month
  for (( d=1; d <= $d2; d++ ))
  do
    printf -v date "%04d%02d%02d" $year $m2 $d
    check_and_cp ${date}
  done

fi

input_op="${input_path}"

echo $input_op

## T1 CAMPAIGN data

if [  $T1_2 == 'T1' ]
then
    echo camp merge T1
    echo $hstream -D mapred.reduce.tasks=10 -D mapred.job.name=T1-camp-merge-yqu $input_op -output ${OUTDIR_HOME} -mapper "$pythonbin map_camp_uct.py f" -reducer "$pythonbin red_user_model_or_camp.py" -file 'map_camp_uct.py' -file 'red_user_model_or_camp.py'
    $hstream -D mapred.reduce.tasks=10 -D mapred.job.name=T1-camp-merge-yqu $input_op -output ${OUTDIR_HOME} -mapper "$pythonbin map_camp_uct.py f" -reducer "$pythonbin red_user_model_or_camp.py" -file "$PYDIR/map_camp_uct.py" -file "$PYDIR/red_user_model_or_camp.py"
else
    echo camp merge T2
    echo $hstream -D mapred.reduce.tasks=10 -D mapred.job.name=T2-camp-merge-yqu $input_op -output ${OUTDIR_HOME} -mapper "$pythonbin map_camp_uct.py t" -reducer "$pythonbin red_user_model_or_camp.py" -file 'map_camp_uct.py' -file 'red_user_model_or_camp.py'
    $hstream -D mapred.reduce.tasks=10 -D mapred.job.name=T2-camp-merge-yqu $input_op -output ${OUTDIR_HOME} -mapper "$pythonbin map_camp_uct.py t" -reducer "$pythonbin red_user_model_or_camp.py" -file "$PYDIR/map_camp_uct.py" -file "$PYDIR/red_user_model_or_camp.py"
fi

