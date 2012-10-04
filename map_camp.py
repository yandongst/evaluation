#!/usr/local/bin/python

import sys
import re
import os
#import json
import simplejson as json 

def get_nonzero_f(event):
  pass



def proc(l):
  if len(l.split('\t'))!=2:
    return
  cookie,str_topic = l.split('\t')
  j = None
  try:
    j=json.loads(str_topic)
  except Exception as inst:
    sys.stderr.write(str(inst)+'\n')
    return
  t = j['campaigns']
  #print t
  for event in t:
    cmpgn = event['cmpgn']

    cmpgn_parts = cmpgn.split(';')
    if len(cmpgn_parts) > 1:
      cmpgn = cmpgn_parts[0]

    if cmpgn == 'adx-impr':
      continue

    cmpgn = cmpgn.replace('-','_')

    if f_or_t == 't':
        for f_key in t_key_list:
          if float(event[f_key])>0.0:
            print cookie+'\tt.'+cmpgn+'.'+f_key+'='+event[f_key]
        #print cookie+'\tt.'+cmpgn+'='+retargcnt
    elif f_or_t == 'f':
        for f_key in f_key_list:
          if float(event[f_key])>0.0:
            print cookie+'\t'+'11.'+cmpgn+'.'+f_key+'='+event[f_key]



#fn='2'
f_or_t = 'f'
#t_key_list = ['socialcnt','imprcnt','clkcnt','retargcnt']#not used
t_key_list = ['imprcnt','clkcnt','retargcnt']#not used
f_key_list = ['socialcnt','imprcnt','clkcnt','retargcnt']

#fn = sys.argv[1]
if sys.argv[1] == 't':
  f_or_t = 't'

for l in sys.stdin:
  l = l.strip()
  #proc(l.lower())
  proc(l)

