cat $1 |python metrics_2col.py $2|awk -f awk_gt.awk |sort -k4nr -t"	"
