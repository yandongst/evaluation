more +2 $1 |head -${2}|cut -f2|awk '{s+=$1} END{print s}'
