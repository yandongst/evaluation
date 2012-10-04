input=$1
output=$2
mapper=$3
reducer=$4

if [ $reducer == 'cat' ]
then
  echo /usr/local/hadoop-0.20.1/bin/hadoop jar /usr/local/hadoop-0.20.1/contrib/streaming/hadoop-0.20.1-streaming.jar -D mapred.reduce.tasks=500 -D mapred.job.name=yandong_hadoop_job -input $input  -output $output -mapper 'python $mapper' -file $mapper -reducer "cat"
  /usr/local/hadoop-0.20.1/bin/hadoop jar /usr/local/hadoop-0.20.1/contrib/streaming/hadoop-0.20.1-streaming.jar -D mapred.reduce.tasks=500 -D mapred.job.name=yandong_hadoop_job -input $input  -output $output -mapper 'python $mapper' -file $mapper -reducer "cat"
else
  echo /usr/local/hadoop-0.20.1/bin/hadoop jar /usr/local/hadoop-0.20.1/contrib/streaming/hadoop-0.20.1-streaming.jar -D mapred.reduce.tasks=500 -D mapred.job.name=yandong_hadoop_job -input $input  -output $output -mapper "python $mapper" -file $mapper -reducer "python $reducer"  -file $reducer
  /usr/local/hadoop-0.20.1/bin/hadoop jar /usr/local/hadoop-0.20.1/contrib/streaming/hadoop-0.20.1-streaming.jar -D mapred.reduce.tasks=500 -D mapred.job.name=yandong_hadoop_job -input $input  -output $output -mapper "python $mapper" -file $mapper -reducer "python $reducer"  -file $reducer
fi
