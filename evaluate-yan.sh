#T1
#only support time period that spans within a year for now
year1=2013
t1_m1=1
t1_d1=16
t1_m2=1
t1_d2=23

#T2
t2_m1=1
t2_d1=16
t2_m2=1
t2_d2=23

t1_m1=`echo $t1_m1|sed 's/^0*//'`
t1_m2=`echo $t1_m2|sed 's/^0*//'`
t2_m1=`echo $t2_m1|sed 's/^0*//'`
t2_m2=`echo $t2_m2|sed 's/^0*//'`
t1_d1=`echo $t1_d1|sed 's/^0*//'`
t1_d2=`echo $t1_d2|sed 's/^0*//'`
t2_d1=`echo $t2_d1|sed 's/^0*//'`
t2_d2=`echo $t2_d2|sed 's/^0*//'`

#make it 0 to turn it off
tagseg=0
fn_tag="2012032_disney_rt_rt2_nrt_test_adgroups.txt"

#campaign to analyze. need to specify retarg/imp/click pixels
pixel_file=disney_pixels.txt
pixel_file=amex_sqi_pixels.txt

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
  ./cp_campaign_from_s3.sh $year1 $t1_m1 $t1_d1 $t1_m2 $t1_d2 
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
  ./batch-T1-camp-merge.sh $year1 $t1_m1 $t1_d1 $t1_m2 $t1_d2 T1
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
  ./cp_campaign_from_s3.sh $year1 $t2_m1 $t2_d1 $t2_m2 $t2_d2 
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
  ./batch-T1-camp-merge.sh $year1 $t2_m1 $t2_d1 $t2_m2 $t2_d2 T2
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
echo add segment tags
echo "##########################################################"
pause
if [ $? != 1 ]
then
  ./batch-tag-segs.sh $year1 $t1_m1 $t1_d1 $t1_m2 $t1_d2 $t2_m1 $t2_d1 $t2_m2 $t2_d2 $fn_tag
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
  outputdir=/output/merged/usermodel-camp-T1-${T1}-T2-${T2}-count
  hadoop fs -test -z $outputdir 2> /dev/null
  if [ $? -ne 0 ]
  then
    echo $outputdir count file doesnt exist
  else
    echo hadoop fs -text ${outputdir}/*.gz \|python metrics.py ${pixel_file}\|awk -f awk_gt.awk \|sort -k4nr -t\"	\" \> ${pixel_file}_stats_T1_${T1}_T2_${T2}.txt
    hadoop fs -text ${outputdir}/*.gz |python metrics.py ${pixel_file} |awk -f awk_gt.awk |sort -k4nr -t\"	\" > ${pixel_file}_stats_T1_${T1}_T2_${T2}.txt
    echo "generated: tmpstats_T1_${T1}_T2_${T2}.txt"
  fi
else
  echo "You skipped derive stats file"
fi
