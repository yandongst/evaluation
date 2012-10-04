import sys
from operator import itemgetter


l_c=[]
T=0.01
if len(sys.argv)>3:
  T=float(sys.argv[3])
 
sys.stderr.write('Threshold:'+str(T))

for l in open(sys.argv[1],'r'): 
  l = l.strip()
  c,o=l.split('\t')
  l_c.append(c)

l_top_t=[]
for l in open(sys.argv[2],'r'): 
  l = l.strip()
  l_t=l.split(' ')
  l_t2=[]
  for x in range(len(l_t)):
    l_t2.append((float(l_t[x]),x))
  l_t3=sorted(l_t2,key=itemgetter(0),  reverse=True)
  l_t4= l_t3[:5]
  #print l_t4
  l_tops=[]
  for x in range(5):
    if l_t4[x][0]<T:
      del l_t4[x:5]
      break
    l_tops.append('LDA_'+str(l_t4[x][1]))
  #print l_t4
  #print l_tops
  #l_tops = [map(str, x) for x in l_tops]
  l_top_t.append(','.join(l_tops))

if len(l_c) != len(l_top_t):
  sys.stderr.write('length not match\n')
  sys.exit(1)

for x in range(len(l_c)):
  print l_c[x]+'\t'+l_top_t[x]
  
