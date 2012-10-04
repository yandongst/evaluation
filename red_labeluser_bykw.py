import sys
import re
from operator import itemgetter
from math import sqrt

x_kw_topic={}
x_topic_kw={}
x_clustersum={}
output_cluster_num=5
threshold=0.002

def cos_sim(x,y,c):
  #print c,
  #for w in y:
    #print w,y[w],
  #print 
  xsum=0.0
  for x1 in x:
    xsum+=x[x1]*x[x1]
  if xsum==0.0:
    return 0.0
  ysum=x_clustersum[c]

  sum=0.0
  for x1 in x:
    if x1 in y:
      sum+=x[x1]*y[x1] 
      #print 'X1:',x1

  return sum/(sqrt(xsum)+sqrt(ysum))

def read_topic_file(fn):
  cur_topic=0
  cnt=0
  for l in open(fn,'r'):
    l = l.strip()
    if l.startswith('Topic'):
      cur_topic=l.split(' ')[1][:-3]
      if cur_topic not in x_topic_kw:
        x_topic_kw[cur_topic]={}
        cnt=0
    else:
      if cnt>=20:
        continue
      w,s=filter(None,l.split(' '))
      s=float(s)
      x_topic_kw[cur_topic][w]=s
      cnt+=1

  for c in x_topic_kw:
    sum=0.0
    for kw in x_topic_kw[c]:
      sum+=x_topic_kw[c][kw]*x_topic_kw[c][kw]
    x_clustersum[c]=sum

def read_topic_file2(fn):
  cur_topic=0
  for l in open(fn,'r'):
    l = l.strip()
    if l.startswith('Topic'):
      cur_topic=l.split(' ')[1][:-3]
    else:
      w,s=filter(None,l.split(' '))
      s=float(s)
      if w not in x_kw_topic:
        x_kw_topic[w]=[]
      x_kw_topic[w].append((cur_topic,s))
      
def proc(l):
  l_cluster=[]
  l_kw_s=[]

  for f in fs.split(';'):
    ff1,s=f.split('=')
    s=float(s)
    ff=ff1.split('.')
    if len(ff)==3:
      #if ff[1]=='0' or f[1]=='1': 
      if ff[1]=='0': 
        #l_kw.append(ff[2])
        l_kw_s.append((ff[2],s))
        if '_' in ff[2]:
          l_kw_s.extend((w,s) for w in ff[2].split('_'))
  x_kw={}
  for w,s in l_kw_s:
    if w not in x_kw:
      x_kw[w]=s
    else:  
      x_kw[w]+=s
  #print x_kw

  #for w in x_kw:
    #print w,x_kw[w],
  #print 
  
  for c in x_topic_kw:
    cossim_score = cos_sim(x_kw, x_topic_kw[c],c)
    #print '-----------------'
    #print '--------score:',c,cossim_score
    l_cluster.append((c,cossim_score))
    #print '-----------------'
  l_cluster=sorted(l_cluster,key=itemgetter(1), reverse=True)
  #print '=======SCORE========'
  #l_cluster2= [(x,s) for x,s in l_cluster if s >0.0]
  #print l_cluster2
  
  #return filter((lambda x:x<=0.0),l_cluster)[:5]
  return [x for x,s in l_cluster if s >=threshold][:output_cluster_num]

def proc2(l):
  l_cluster=[]
  #l_kw=[]
  l_kw_s=[]

  for f in fs.split(';'):
    ff1,s=f.split('=')
    s=float(s)
    ff=ff1.split('.')
    if len(ff)==3:
      #if ff[1]=='0' or f[1]=='1': 
      if ff[1]=='0': 
        #l_kw.append(ff[2])
        l_kw_s.append((ff[2],s))
        if '_' in ff[2]:
          l_kw_s.extend((w,s) for w in ff[2].split('_'))
  print l_kw_s

  x_cluster_scoresum={}
  for kw,s in l_kw_s: 
    if kw in x_kw_topic:
      #print kw,x_kw_topic[kw]
      #print f 
      #l_cluster.extend(x_kw_topic[kw])
      for c,s1 in x_kw_topic[kw]:
        if c not in x_cluster_scoresum:
          x_cluster_scoresum[c]=0
        x_cluster_scoresum[c]+=s*s1

  #print l_cluster
  x_cluster={}
  for c in l_cluster:
    x_cluster[c[0]]=0 
  for (c,s) in l_cluster:
    x_cluster[c]+=s
  
  #print x_cluster
  
  #l_cluster=sorted(x_cluster.iteritems(),key=itemgetter(1), reverse=True)
  l_cluster=sorted(x_cluster_scoresum.iteritems(),key=itemgetter(1), reverse=True)
  return l_cluster[:5]

read_topic_file(sys.argv[1])
tagpre=sys.argv[2]
cluster_topkw=20
#for each kw, sort its clusters
for w in x_kw_topic:
  #print w,x_kw_topic[w]
  x_kw_topic[w]=sorted(x_kw_topic[w],key=itemgetter(1), reverse=True)
  #print x_kw_topic[w]

for l in sys.stdin:
  l= l.strip()
  if len(l.split('\t')) !=3:
    sys.stderr.write('Red error:'+e+'\n')
    continue
  co,t,fs  = l.split('\t')
  l_cluster=proc(fs)
  #print len(l_cluster)
  #print l_cluster
  l_labels=[]
  for c in l_cluster:
    l_labels.append(tagpre+'_'+c+'=1')
  
  if l_labels:
    print '\t'.join([co,t,fs+';'+';'.join(l_labels)])
    pass
  else:
    print '\t'.join([co,t,fs])
    pass
  
