for x in 1 2 4 9
do
echo hadoop fs -rmr /projects/input/user_model/sharethis-insights-backup/model/2012${1}/query/updated/$x/$x
hadoop fs -rmr /projects/input/user_model/sharethis-insights-backup/model/2012${1}/query/updated/$x/$x
done
