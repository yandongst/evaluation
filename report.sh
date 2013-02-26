hadoop fs -text $1/*.gz |python metrics.py $2 |awk -f awk_gt.awk |sort -k4nr -t"	"
