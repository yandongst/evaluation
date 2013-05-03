#T1
#only support time period that spans within a year for now
year1=$(date --date='-1 day' +%Y)
t1_m1=$(date --date='-21 day' +%m)
t1_d1=$(date --date='-21 day' +%d)
t1_m2=$(date --date='-8 day' +%m)
t1_d2=$(date --date='-8 day' +%d)

#T2
year2=$(date --date='-7 day' +%Y)
t2_m1=$(date --date='-7 day' +%m)
t2_d1=$(date --date='-7 day' +%d)
t2_m2=$(date --date='-1 day' +%m)
t2_d2=$(date --date='-1 day' +%d)

t1_m1=`echo $t1_m1|sed 's/^0*//'`
t1_m2=`echo $t1_m2|sed 's/^0*//'`
t2_m1=`echo $t2_m1|sed 's/^0*//'`
t2_m2=`echo $t2_m2|sed 's/^0*//'`
t1_d1=`echo $t1_d1|sed 's/^0*//'`
t1_d2=`echo $t1_d2|sed 's/^0*//'`
t2_d1=`echo $t2_d1|sed 's/^0*//'`
t2_d2=`echo $t2_d2|sed 's/^0*//'`

cd /home/yandong/workspace/ae

#make it 0 to turn it off
tagseg=1
tag_name="RT_Clorox"
tag_file="clorox_fjm.txt"


printf -v T1 "%04d%02d%02i-%04d%02d%02d" $year1 $t1_m1 $t1_d1 $year1 $t1_m2 $t1_d2
printf -v T2 "%04d%02d%02i-%04d%02d%02d" $year1 $t2_m1 $t2_d1 $year1 $t2_m2 $t2_d2

function pause() {
  return 0

  read -p "Press [Enter] key to continue. Press q [Enter] to quit. Press s [Enter] to skip this step: " input
  echo you typed $input
  if [ "$input" == "q" ]
  then
    exit 1
  fi
  if [ "$input" == "s" ]
  then
    #echo "Skip."
    return 1
  fi
  return 0
}
function newline() {
  echo -e "\n"
}

function check_samemonths() {
  m1=$1
  d1=$2
  m2=$3
  d2=$4
  #####same month. check if days are valid
  if [ $m1 -eq $m2 ]
  then
    if [ $d1 -gt $d2 ]
    then
      echo ERROR: WRONG DAYS
      exit 1
    fi 
  fi
}

function check_months() {
  m1=$1
  m2=$2
  if [ "$m1" -lt 1 -o "$m1" -gt 12 -o "$m2" -lt 1 -o "$m2" -gt 12 -o $m1 -gt $m2 ]
  then
    echo ERROR: invalid MONTH
    exit 1
  fi
}
function check_days() {
  d1=$1
  d2=$2
  if [ $d1 -lt 1 -o $d1 -gt 31 -o $d2 -lt 1 -o $d2 -gt 31 ]
  then
    echo ERROR: invalid DAY
    exit 1
  fi
}

check_samemonths $t1_m1 $t1_d1 $t1_m2 $t1_d2
check_samemonths $t2_m1 $t2_d1 $t2_m2 $t2_d2
check_months $t1_m1 $t1_m2
check_months $t2_m1 $t2_m2
check_days $t1_d1 $t1_d2
check_days $t2_d1 $t2_d2

echo "##########################################################"
echo copy user model data T1:$T1
echo "##########################################################"
pause 
if [ $? != 1 ]
then
  ./cp_user_model_froms3.sh $year1 $t1_m1 $t1_d1 $t1_m2 $t1_d2
else
  echo "You skipped copy user model data T1:$T1"
fi
newline

echo "##########################################################"
echo merge T1 user model T1:$T1
echo "##########################################################"
pause
if [ $? != 1 ]
then
  ./batch-T1-user-model-merge_all_events.sh $year1 $t1_m1 $t1_d1 $t1_m2 $t1_d2 
else
  echo "You skipped merge T1 user model T1:$T1"
fi
newline

echo "##########################################################"
echo copy campaign data T1:$T1
echo "##########################################################"
pause
if [ $? != 1 ]
then
  ./cp_uct_from_s3.sh $year1 $t1_m1 $t1_d1 $t1_m2 $t1_d2 
else
  echo "You skipped copy campaign data T1:$T1"
fi
newline

echo "##########################################################"
echo merge T1 camp data T1:$T1
echo "##########################################################"
pause
if [ $? != 1 ]
then
  ./batch-T1-camp-merge-uct.sh $year1 $t1_m1 $t1_d1 $t1_m2 $t1_d2 T1
else
  echo "You skipped merge T1 camp data T1:$T1"
fi
newline

echo "##########################################################"
echo copy campaign data T2:$T2
echo "##########################################################"
pause
if [ $? != 1 ]
then
  ./cp_uct_from_s3.sh $year1 $t2_m1 $t2_d1 $t2_m2 $t2_d2 
else
  echo "You skipped copy campaign data T2:$T2"
fi
newline

echo "##########################################################"
echo merge T2 camp data T2:$T2
echo "##########################################################"
pause
if [ $? != 1 ]
then
  ./batch-T1-camp-merge-uct.sh $year1 $t2_m1 $t2_d1 $t2_m2 $t2_d2 T2
else
  echo "You skipped merge T2 camp data T2:$T2"
fi
newline

echo "##########################################################"
echo merge T1-usermodel, T1-campaign, T2-campaign data
echo "##########################################################"
pause
if [ $? != 1 ]
then
  ./batch-T1-T2-user-model-camp_merge.sh $year1 $t1_m1 $t1_d1 $t1_m2 $t1_d2 $t2_m1 $t2_d1 $t2_m2 $t2_d2
else
  echo "You skipped merge T1-usermodel, T1-campaign, T2-campaign data"
fi
newline


if [ $tagseg == 1 ]
then
echo "##########################################################"
echo add custom rt tags
echo "##########################################################"
pause
if [ $? != 1 ]
then
  hadoop jar /usr/lib/hadoop-0.20-mapreduce/contrib/streaming/hadoop-streaming-2.0.0-mr1-cdh4.1.2.jar -D mapred.task.timeout=24000000 -D mapred.output.compress=true -D mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec -D mapred.reduce.tasks=0 -D mapred.job.name=AddCustomRtTag -input /projects/science/output/merged/usermodel-camp-T1-${T1}-T2-${T2} -output /projects/science/output/merged/usermodel-camp-T1-${T1}-T2-${T2}-tagseg -mapper "python2.7 mapper-expandAudience.py tag_file.txt" -file mapper-expandAudience.py -file tag_file.txt -file clorox_seed.txt -file mgm_lv_seed.txt -file hsn_Kitchen_seed.txt
else
  echo "You skipped add segment tags"
fi
newline
fi


echo "##########################################################"
echo generate count file from step 6 merged file
echo "##########################################################"
pause
if [ $? != 1 ]
then
  echo ./batch-count.sh $year1 $t1_m1 $t1_d1 $t1_m2 $t1_d2 $t2_m1 $t2_d1 $t2_m2 $t2_d2 $tagseg
  ./batch-count.sh $year1 $t1_m1 $t1_d1 $t1_m2 $t1_d2 $t2_m1 $t2_d1 $t2_m2 $t2_d2 $tagseg
else
  echo "You skipped generate count file from step 6 merged file"
fi
newline


echo "##########################################################"
echo derive stats file
echo "##########################################################"
pause
if [ $? != 1 ]
then
  outputdir=/projects/science/output/merged/usermodel-camp-T1-${T1}-T2-${T2}-count
  hadoop fs -test -z $outputdir 2> /dev/null
  if [ $? -ne 0 ]
  then
    echo $outputdir count file doesnt exist
  else
    for pixel_file in `cat pixel_file.txt`
    do
      echo hadoop fs -text ${outputdir}/*.gz \|python metrics.py ${pixel_file}\|awk -f awk_gt.awk \> report/${pixel_file}_stats_T1_${T1}_T2_${T2}.txt
      hadoop fs -text ${outputdir}/*.gz |python metrics.py ${pixel_file}.txt |awk -f awk_gt.awk > report/${pixel_file}_stats_T1_${T1}_T2_${T2}.txt
    done
  fi
else
  echo "You skipped derive stats file"
fi
