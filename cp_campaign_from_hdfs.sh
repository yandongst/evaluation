event=11

#20120210

for (( d=10; d <= 15; d++ ))
do
  printf -v date "201202%02i" $d
  mkdir ${date}
  echo hadoop fs -get /user/root/campaign-analytics/aggregate_campaign_data/user_campaign_table/dt\=${date}/part*.gz  ${date}
  hadoop fs -get /user/root/campaign-analytics/aggregate_campaign_data/user_campaign_table/dt\=${date}/part*.gz ${date}
done
