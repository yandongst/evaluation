#!/usr/bin/env python
import sys

x = set([])

def read_feature_list(fn):
  for l in open(fn,'r'):
    x.add(l.strip()) 

fn_feature_list = sys.argv[1]
user_tag = sys.argv[2]

read_feature_list(fn_feature_list)
#sys.stderr.write(str(len(x)))

for l in sys.stdin:
  l = l.strip()
  ll = l.split('\t')
  if(len(ll) !=3):
    sys.stderr.write('Map user-model error:'+l+'\n')
    continue
  has_top_feature=False
  for f1 in ll[2].split(';'):
    f,v = f1.split('=')
    if f in x:
      has_top_feature = True
      break
  if has_top_feature:
    print '%s\t%s\t%s;%s=1'%(ll[0],ll[1],ll[2],user_tag) 
  else:
    print '%s\t%s\t%s'%(ll[0],ll[1],ll[2]) 

