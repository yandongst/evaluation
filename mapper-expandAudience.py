#!/usr/bin/env python

import sys
import re
import simplejson as json


# command line argument
if len(sys.argv)<2:
  print >> sys.stderr, 'insufficient number of input arguments'
  sys.exit(1)


feat_dict = {}
for x in open(sys.argv[1]):
  (tag_name,tag_file) = x.strip().split(',')
  feat_dict[tag_name] = dict((x.strip(),1) for x in open(tag_file) if x)
print >> sys.stderr, feat_dict 


for line in sys.stdin:
  
  # remove leading and trailing whitespace
  fields = line.strip().split('\t')
  if len(fields) < 3: continue
  cookie = fields[0].strip()
  targets = fields[1].strip()
  feats = fields[2].strip()
  
  # examine feature
  for feat in feats.split(';'):
    try:
      (feat_name, feat_score) = feat.split('=')
    except:
      continue
    for rt_pixel in feat_dict:
      if feat_name in feat_dict[rt_pixel]:
        if targets == 'nt=1':
          targets = 't.' + rt_pixel + '=1.0'
        else:
          targets = targets + ';t.' + rt_pixel + '=1.0'

  print '%s\t%s\t%s' % (cookie,targets,feats)

  
