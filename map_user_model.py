#!/usr/bin/python2.7
import sys
import re
import os
import simplejson as json 


def print_topics(cookie, level,x_topic, event):
  for kw in x_topic: 
    #wt = float(kw['wt'])
    try:
      print cookie+'\t'+event+'.'+level+'.'+str(kw['word'])+'='+str(kw['wt']) 
    except Exception as inst:
      sys.stderr.write(str(inst)+'\n')
      return

def proc_event_5(l):
  cookie,event,str_topic = l.split('\t')
  j=None
  try:
    j=json.loads(str_topic)
  except Exception as inst:
    sys.stderr.write(str(inst)+'\n')
    return
  date=str(j['time'])[0:8]
  x_topics = j['topic_col']
  if 'TopicLevel0' in x_topics:
    if 'topics' in x_topics['TopicLevel0']:
      x_topic0 = x_topics['TopicLevel0']['topics']
      x=[]
      str_kws = x_topic0[0]['word']
      for kw in str_kws.split(' '):
        x.append({'word':kw,'wt':'1.0'})
      
      #print_topics(cookie,'0', x_topic0,event)
      print_topics(cookie,'0', x,event)
  if 'TopicLevel1' in x_topics:
    if 'topics' in x_topics['TopicLevel1']:
      x_topic1 = x_topics['TopicLevel1']['topics']
      print_topics(cookie,'1', x_topic1,event)

def proc_event_124(l):
  cookie,event,str_topic = l.split('\t')
  j=None
  try:
    j=json.loads(str_topic)
  except Exception as inst:
    sys.stderr.write(str(inst)+'\n')
    return
  date=str(j['time'])[0:8]
  x_topics = j['topic_col']
  if 'TopicLevel0' in x_topics:
    if 'topics' in x_topics['TopicLevel0']:
      x_topic0 = x_topics['TopicLevel0']['topics']
      print_topics(cookie,'0', x_topic0,event)
  if 'TopicLevel1' in x_topics:
    if 'topics' in x_topics['TopicLevel1']:
      x_topic1 = x_topics['TopicLevel1']['topics']
      print_topics(cookie,'1', x_topic1,event)
  if 'TopicLevel99' in x_topics:
    if 'topics' in x_topics['TopicLevel99']:
      x_topic99 = x_topics['TopicLevel99']['topics'] 
      print_topics(cookie,'99', x_topic99,event)
    else:
      #sys.stderr.write(l+'\n')
      pass

def proc_event_9(l):
  cookie,event,data = l.split('\t')
  for domain1 in data.split(','):
    if domain1.find('.')==-1:
      continue
    domain1_parts = domain1.split('&')
    if len(domain1_parts) > 1:
      domain1 = domain1_parts[0]

    domain1_parts = domain1.split('-')
    if len(domain1_parts) > 1:
      #domain1 = domain1_parts[0]
      #domain1='-'.join(domain1_parts[:len(domain1_parts)-3])
      #print domain1
      domain1='-'.join(domain1_parts[:-3])
      #print domain1
    #print cookie+'\t9.'+domain1.split('-')[0]+'=1'
    print cookie+'\t9.'+domain1+'=1'


for l in sys.stdin:
  l = l.strip()
  ll = l.split('\t')
  if(len(ll) !=3):
    sys.stderr.write('Map user-model error:'+l+'\n')
    continue
  cookie,event,data = l.split('\t')
  if event=='9':
    proc_event_9(l)
  elif event in ['1','2','4']:
    proc_event_124(l)
  elif event=='5':
    proc_event_5(l)
  else:
    print 'error'

