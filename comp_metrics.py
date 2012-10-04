import sys


x_cnt_targets={}
x_target_f={}

def proc(l):
  if (len( l.split('\t')) != 3):
    #print l
    return
  cookie,targets,f_list = l.split('\t')
  for t1 in targets.split(';'):

    if (len(t1.split('='))!=2):
      print t1

    t,c = t1.split('=')

    if t == 'nt':
      continue
    #print 'target:'+t

    if t in x_cnt_targets:
      x_cnt_targets[t]+=1
    else:
      x_cnt_targets[t]=1

    if t not in x_target_f:
      x_target_f[t]={}

    #print 'f_list:'+f_list

    for f1 in f_list.split(';'):
      if (len(f1.split('='))!=2):
        print f1
        continue
      f,c = f1.split('=')
      #print f,c
      c= float(c)
      if f not in x_target_f[t]:
        x_target_f[t][f]=c
      else:
        x_target_f[t][f]+=c

def output_stats():
  print 'target distribution:'

  sum_targets = 0.0;
  for t in x_cnt_targets:
    sum_targets+=x_cnt_targets[t]

  for t in x_cnt_targets:
    print '%s:%f%%'%(t,x_cnt_targets[t]/sum_targets*100.0)

  print
  print 'target-feature distribution:'
  for t in x_target_f:
    sum_targets1 = 0.0
    for f in x_target_f[t]:
      sum_targets1 += x_target_f[t][f]

    for f in x_target_f[t]:
      print '%s\t%s\t%f\t%d'%(t,f,x_target_f[t][f]/sum_targets1*100.0, x_target_f[t][f])

for l in sys.stdin:
  l = l.strip()
  proc(l)
 

output_stats()
