#!/usr/local/bin/python

#NOW THIS COUNTS IMPR

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
  t = j['campaigns']
  for event in t:
    cmpgn = event['cmpgn']
    imprcnt = int(event['clkcnt'])

    cmpgn_parts = cmpgn.split(';')
    if len(cmpgn_parts) > 1:
      cmpgn = cmpgn_parts[0]

    if cmpgn == 'adx-impr':
      continue

    cmpgn = cmpgn.replace('-','_')
    #print '-'*50
    #print cmpgn 
    #if imprcnt>0:
    sys.stdout.write ((cmpgn+'\n')*imprcnt)
    #print '='*50

for l in sys.stdin:
  l = l.strip()
  proc(l)

