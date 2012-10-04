#convert double click json to cookie-seg mapping

import sys
import simplejson as json 

def proc(l):
  if len(l.split('\t')) !=2:
    sys.stderr.write('l:'+l)
    return None,None
  cookie,data = l.split('\t')
  j=None
  ls=[]
  try:
    j=json.loads(data)
  except Exception as inst:
    #sys.stderr.write(str(inst)+'\n')
    return None,None
  if 'double_click' in j:
    for p in j['double_click']:
      #2.l0.topic = 1
      #13.append =1
      ls.append(p)

  return cookie,ls

for l in sys.stdin:
  l = l.strip()
  c,seg_list = proc(l)
  
  if c and seg_list:
    print c+'\t'+','.join(seg_list)
