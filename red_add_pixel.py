import sys
import re
import simplejson as json 

current_c=''
s_merged=''
s_pixels='' 

def proc_merged(data):
  return data

def proc_pixel(l):
  cookie,data = l.split('\t')
  j=None
  ls=[]
  try:
    j=json.loads(data)
  except Exception as inst:
    sys.stderr.write(str(inst)+'\n')
    return ls
  if 'double_click' in j:
    for p in j['double_click']:
      #2.l0.topic = 1
      #13.append =1
      ls.append('p.'+p+'=1')

  return ls

for l in sys.stdin:
  l = l.strip()
  ll = l.split('\t')
  c = ll[0]

  if current_c == '' and c!='':
    current_c = c

  if current_c != c: 
    if s_pixels!='' and s_merged!='':
      print current_c+'\t'+s_merged+';'+s_pixels
    elif s_merged!='':
      print current_c+'\t'+s_merged 
    else:
      pass
    current_c = c
    s_pixels=''
    s_merged=''

  if len(ll) == 2:
    s_pixels = ';'.join(proc_pixel(l))
  elif len(ll) == 3:
    s_merged =  proc_merged(ll[1]+'\t'+ll[2])
  else:
    sys.stderr.write('Error:'+l) 

