import sys 

#tag those features that occur with re-target features

def feature_in_target(t,f):
  #t 'rt_jcp'
  #f is 11.rt_jcp, 11.rt_jcp.retargcnt, 11.rt_jcp2.retargcnt
  if f[3:].startswith(t[2:]):
    return True
  return False

def proc(l):
  if (len( l.split('\t')) != 3):
    sys.stderr.write('Error: '+l+'\n')
    return
  cookie,targets,features = l.split('\t')

  x_t=set([])

  ts = targets.split(';')
  fs = features.split(';')

  for t1 in ts: 
    if (len(t1.split('='))!=2):
      sys.stderr.write('Error: '+t1+'--\n') 
      continue
    t,c = t1.split('=') 
    if t == 'nt':
      continue
    x_t.add(t[2:])#remove 't.'
    print '%s\t1 %s'%(t,c) 

  #print x_t

  #targets are like: t.rt_jcp
  #features: 11.rt_jcp

  inadx=False
  for t1 in fs: 
    if (len(t1.split('='))!=2):
      sys.stderr.write('Error: '+t1+'\n') 
    t,c = t1.split('=') 
    if t.startswith('11') and t.endswith('imprcnt'):
      inadx=True
    print '%s\t1 %s'%(t,c)
  for t1 in fs: 
    if (len(t1.split('='))!=2):
      sys.stderr.write('Error: '+t1+'\n') 
    t,c = t1.split('=') 
    if(inadx):
      print 'adx.%s\t1 %s'%(t,c)


  for t1 in ts: 
    if (len(t1.split('='))!=2):
      sys.stderr.write('Error: '+t1+'--\n') 
      continue
    t,target_cnt = t1.split('=') 

    #skip notarget
    if t == 'nt':
      continue

    # indicating if feature/target occur
    ft_occurred=0

    #print 'current target:%s'%t

    for f1 in fs: 
      if (len(f1.split('='))!=2):
        sys.stderr.write('Error:'+f1+'\n')
        continue
      f,c = f1.split('=')
      #print 'fff:%s'%f[3:]
      if feature_in_target(t, f):
        #print 'in target:%s'%f
        ft_occurred=1
        break
      #else:
        #print 'not in target:%s'%f

    for f1 in fs: 
      if (len(f1.split('='))!=2):
        sys.stderr.write('Error:'+f1+'\n')
        continue
      f,c = f1.split('=')
      if ft_occurred:
        # for the retarget feature itself, output as it
        if feature_in_target(t, f):
          print '%s-%s\t1 %s'%(t,f,target_cnt)
        else:
          print 'c.%s-%s\t1 %s'%(t,f,target_cnt)
      else:
        print '%s-%s\t1 %s'%(t,f,target_cnt)
    #print

for l in sys.stdin:
  l = l.strip()
  #print l
  proc(l)
