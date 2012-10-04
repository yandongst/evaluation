#!/usr/local/bin/python

'''
obtain cookies from daily impr logs as an estimate of adx presence
format:
cookie \t adx-impr
'''

import sys
import re
import os
#import json
import simplejson as json 

def get_nonzero_f(event):
  pass



def proc(l):
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
    cnt = event['imprcnt']

    #if cmpgn == 'adx-impr':
      #continue


    if cnt>0.0:
      print cookie+'\t'+'adx-impr'
      return


for l in sys.stdin:
  l = l.strip()
  #proc(l.lower())
  proc(l)

