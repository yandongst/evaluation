#!/usr/local/bin/python
import sys


for l in sys.stdin:
  l = l.rstrip()
  ll = l.split('\t')
  if len(ll) == 2:#cookie-seg mapping
    lst=[]
    for s in ll[1].split(','):
      lst.append('a.'+s+'=1')
    print '%s\t%s\t%s'%(ll[0],'nt=1',';'.join(lst)) 
  elif(len(ll) ==3):
  #elif(len(ll) !=3):
    #sys.stderr.write('Map user-model error:'+l+'\n')
    #continue

    print '%s\t%s\t%s'%(ll[0],ll[1],ll[2]) 

