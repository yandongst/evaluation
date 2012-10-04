cat $1 |python /mnt_disk4/yandong/evaluation/user_profiles/metrics_pri_2col.py $2|awk -f /mnt_disk4/yandong/evaluation/user_profiles/awk_gt.awk |sort -k4nr -t"	"
