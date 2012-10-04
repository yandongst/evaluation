import sys
import re

delimit='-;,'
delimit=';'

current_c=''
ls_f=[]
ls_t=[]

def merge_one_cookie_features(l):
  x={}
  for e in l:
    if len(e.split('=')) !=2:
      sys.stderr.write('Red error:'+e+'\n')
      continue
    k,v = e.split('=')
    v = float(v)
    if k in x:
      x[k]+=v
    else:
      x[k]=v
  return x

def get_hash_str(x):
  l=[]
  for k in x:
    l.append(k+'='+str(x[k]))
  return ';'.join(l)

for l in sys.stdin:
  l = l.strip()
  c,r = l.split('\t')

  if current_c == '' and c!='':
    current_c = c

  if current_c != c:
    #print
    #print l
    #print 'new:'+r
    #print

    x_f = merge_one_cookie_features(ls_f)
    x_t = merge_one_cookie_features(ls_t)
  
    if x_t and x_f:
      print current_c+'\t'+ get_hash_str(x_t)+'\t'+get_hash_str(x_f)
    elif x_f:
      print current_c+'\tnt=1\t'+get_hash_str(x_f)
    #else:
      #print current_c+'\tonlyt.'+get_hash_str(x_t)
    current_c = c
    del ls_f[:]
    del ls_t[:]


  if r.startswith('t'):
    #print 'target='+r
    ls_t.extend(r.split(';'))
  else:
    #if(len(r.split('='))!=2): 
      #print r
      #continue
    ls_f.extend(r.split(';'))
