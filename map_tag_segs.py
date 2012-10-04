#!/usr/local/bin/python
import sys

x = {}

def read_cookie_seg(fn):
  for l in open(fn,'r'):
    c,segs = l.strip().split('\t')
    s_segs = set(segs.split(','))
    x[c]=s_segs

fn_cookie_seg = sys.argv[1]

read_cookie_seg(fn_cookie_seg)
#sys.stderr.write(str(len(x)))

for l in sys.stdin:
  l = l.rstrip()
  ll = l.split('\t')
  if(len(ll) !=3):
    sys.stderr.write('Map user-model error:'+l+'\n')
    continue

  if ll[0] in x:
    lst=[]
    for s in x[ll[0]]:
      lst.append('a.'+s+'=1')
    print '%s\t%s\t%s;%s'%(ll[0],ll[1],ll[2],';'.join(lst)) 
  else:
    print '%s\t%s\t%s'%(ll[0],ll[1],ll[2]) 

