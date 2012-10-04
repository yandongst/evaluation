
#input t1 start_date end_date
#input t2 start_date end_date
#output

HADOOP_HOME=/usr/local/hadoop-0.20.1/
HADOOP_HOME_STREAMING=/usr/local/hadoop-0.20.1/contrib/streaming/hadoop-0.20.1-streaming.jar

function usage() {
  echo usage: $0 -t1s T1_start_date -t1e T1_end_date -t2s T2_start_date  -t2e T2_end_date 
  echo e.g.: $0 -t1s 20120115 -t1e 20120130 -t2s 20120201  -t2e 20120207
}

function missing() {
  local a="$1"
  echo ERROR: missing $a
  usage
  exit
}

while [ "$#" -gt "0" ]
do
  case $1 in
    -t1s)
      shift
      d_t1s=$1
      ;;
    -t1e)
      shift
      d_t1e=$1
      ;;
    -t2s)
      shift
      d_t2s=$1
      ;;
    -t2e)
      shift
      d_t2e=$1
      ;;
    *)
      echo "error"
      ;;
  esac
  shift
done 

if [ -z $d_t1s ]
then
  missing "t1 start date"
fi

if [ -z $d_t1e ]
then
  missing "t1 end date"
fi

if [ -z $d_t2s ]
then
  missing "t2 start date"
fi

if [ -z $d_t2e ]
then
  missing "t2 end date"
fi

echo T1: $d_t1s $d_t1e T2: $d_t2s $d_t2e 

#Merge T1 user profile
#Merge T1 campaign analytics

#Merge T1 user profile + campaign analytics

#Merge T2 campaign analytics


input_op=''
input_op_pre=/user/root/yandong/output/1010_1110/end_A/
input_op_post=''


input_op+="-input /user/root/sharethis-insights-backup/model/20120223/query/updated/1 "
input_op+="-input /user/root/sharethis-insights-backup/model/20120223/query/updated/2 "
input_op+="-input /user/root/sharethis-insights-backup/model/20120223/query/updated/4 "
input_op+="-input /user/root/sharethis-insights-backup/model/20120223/query/updated/9 "

for (( d=10; d <= 31; d++ ))
do
  printf -v date "201110%02i" $d
  #input_op+="-input ${input_op_pre}${date}/${input_op_post} "
done




OUTDIR=yandong/output/hertz_1104_1110_ticks_no_query_top4

mapper_opt="python mapper_merge_all_events.py $t1s $t1e $t2s $t2e"

echo mapper_opt: $mapper_opt


#$HADOOP_HOME/bin/hadoop jar $HADOOP_HOME_STREAMING  $input_op -output ${OUTDIR} -mapper "$mapper_opt" -file mapper_merge_all_events.py -reducer 'python reducer.py'  -file ../reducer.py -file ./$fn_cate -jobconf mapred.reduce.tasks=600 -jobconf mapred.job.name='conv_path'
