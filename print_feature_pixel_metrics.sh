cat all_feature_pixel_target.txt |python metrics.py $1|awk -f awk_gt.awk |sort -k4nr -t"	"
