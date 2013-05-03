#!/usr/local/bin/python

import sys
import re
import os
import simplejson as json 


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

  if 'cmpns' in j:
    cmpns= j['cmpns']
    for cmpn in cmpns:
      cmpname=cmpn['cmpn']
      if cmpname=='adx-impr':continue 
      cmpname = cmpname.replace('-','_') 
      if f_or_t == 't':
        for f_key in t_key_list:
          if cmpn[f_key]>0.0:
            print cookie+'\tt.'+cmpname+'.'+f_key+'='+str(cmpn[f_key])
      elif f_or_t == 'f':
        for f_key in f_key_list:
          if cmpn[f_key]>0.0:
            print cookie+'\t'+'11.'+cmpname+'.'+f_key+'='+str(cmpn[f_key])

  if f_or_t == 't':
    target='t'
  else:
    target='11'

  if 'retargs' in j:
    for cmpn in j['retargs']:
      cmpname=cmpn['rid']
      cmpname = cmpname.replace('-','_') 
      if cmpn['cnt']>0.0:
        print cookie+'\t'+target+'.'+cmpname+'.'+'retargcnt'+'='+str(cmpn['cnt'])


f_or_t = 'f'
t_key_list = ['imprcnt','clkcnt']#not used
f_key_list = ['imprcnt','clkcnt']

if sys.argv[1] == 't':
  f_or_t = 't'

for l in sys.stdin:
  l = l.strip()
  proc(l)

