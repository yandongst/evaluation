event=11

for (( d=01; d <= 01; d++ ))
do
  printf -v date "201202%02i" $d
  echo hadoop distcp /user/root/campaign-analytics/aggregate_campaign_data/user_campaign_table/dt\=${date}/ /user/root/campaign-analytics/aggregate_campaign_data/user_campaign_table/
  hadoop distcp /user/root/campaign-analytics/aggregate_campaign_data/user_campaign_table/dt\=${date}/ /user/root/campaign-analytics/aggregate_campaign_data/user_campaign_table/
done
