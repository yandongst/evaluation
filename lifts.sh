for camp in samsung msft wendys
do
  echo hadoop fs -text /projects/output/merged/usermodel-camp-T1-20120601-20120630-T2-20120601-20120630-${camp}/*.gz\|python /data/4/yandong/preprocess_logs/sample.py 0.10\|python brandlift.py ${camp}_lift_target.txt ${camp}_lift_feature.txt \> ${camp}_lift_1p.txt
  hadoop fs -text /projects/output/merged/usermodel-camp-T1-20120601-20120630-T2-20120601-20120630-${camp}/*.gz|python /data/4/yandong/preprocess_logs/sample.py 0.010|python brandlift.py ${camp}_lift_target.txt ${camp}_lift_feature.txt > ${camp}_lift_1p.txt&
done
#hadoop fs -text /projects/output/merged/usermodel-camp-T1-20120601-20120630-T2-20120601-20120630-samsung/*.gz|python /data/4/yandong/preprocess_logs/sample.py 0.10|python brandlift.py samsung_lift_target.txt samsung_lift_feature.txt > samsung_lift_10p.txt&
#hadoop fs -text /projects/output/merged/usermodel-camp-T1-20120601-20120630-T2-20120601-20120630-msft/*.gz|python /data/4/yandong/preprocess_logs/sample.py 0.10|python brandlift.py msft_lift_target.txt msft_lift_feature.txt  > msft_lift_10p.txt&
#hadoop fs -text /projects/output/merged/usermodel-camp-T1-20120601-20120630-T2-20120601-20120630-wendys/*.gz|python /data/4/yandong/preprocess_logs/sample.py 0.10|python brandlift.py wendys_lift_target.txt wendys_lift_feature.txt  > wendys_lift_10p.txt&

