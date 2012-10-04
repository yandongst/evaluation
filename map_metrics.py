import sys 

def proc(l):
  if (len( l.split('\t')) != 3):
    sys.stderr.write('Error: '+l+'\n')
    return
  cookie,targets,features = l.split('\t')

  ts = targets.split(';')
  fs = features.split(';')

  for t1 in ts: 
    if (len(t1.split('='))!=2):
      sys.stderr.write('Error: '+t1+'\n') 
    t,c = t1.split('=') 
    if t == 'nt':
      continue
    print '%s\t1'%t 

  for t1 in fs: 
    if (len(t1.split('='))!=2):
      sys.stderr.write('Error: '+t1+'\n') 
    t,c = t1.split('=') 
    print '%s\t1'%t 

  for t1 in ts: 
    if (len(t1.split('='))!=2):
      sys.stderr.write('Error: '+t1+'\n') 
    t,c = t1.split('=') 
    if t == 'nt':
      continue
    for f1 in fs: 
      if (len(f1.split('='))!=2):
        sys.stderr.write('Error:'+f1+'\n')
        continue
      f,c = f1.split('=')
      print '%s-%s\t1'%(t,f)

for l in sys.stdin:
  l = l.strip()
  #print l
  proc(l)
