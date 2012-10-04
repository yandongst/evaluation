#!/usr/local/bin/python

import sys


ls_t=[]
ls_f=[]
current_c='' 

for l in sys.stdin:
  l = l.strip()

  if(len(l.split('\t'))!=3): 
    sys.stderr.write('Red user-model error:'+l+'\n')
    continue

  c,t,f = l.split('\t')


  if current_c == '' and c!='':
    current_c = c

  if current_c != c:
    s_t = ';'.join(set(ls_t))
    s_f = ';'.join(set(ls_f))
    print current_c+'\t'+ s_t+'\t'+s_f
    current_c = c
    del ls_t[:]
    del ls_f[:]

  if t:
    ls_t.append(t)
  if f:
    ls_f.append(f)
