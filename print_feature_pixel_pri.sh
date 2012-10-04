cat feature_target_files/all_feature_pixel_target_pri.txt |python metrics_pri.py $1|awk -f awk_gt.awk |sort -k4nr -t"	"
