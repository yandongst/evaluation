#t1 event 1 2 4 9
cat 1.txt 2.txt 4.txt 9.txt|python map_user_model.py |python red_user_model_or_camp.py
#t1 campaign
cat campaign-ana.txt |python map_camp.py f|python red_user_model_or_camp.py
#t2 campaign
cat camp_t2.txt |python map_camp.py t|python red_user_model_or_camp.py
