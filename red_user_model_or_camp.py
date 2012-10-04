#!/usr/bin/python2.7
import sys
import re

def merge_one_cookie_events(l):
  x={}
  for e in l:
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

ls=[]
current_c='' 

for l in sys.stdin:
  l = l.strip()
  c,r = l.split('\t')

  if(len(r.split('='))!=2): 
    sys.stderr.write('Red user-model error:'+r+'\n')
    continue

  if current_c == '' and c!='':
    current_c = c

  if current_c != c:
    x = merge_one_cookie_events(ls)
    if x:
      print current_c+'\t'+ get_hash_str(x)
    current_c = c
    #print 'now cookie:'+current_c
    del ls[:]

  ls.append(r)



