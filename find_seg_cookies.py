import sys

'''
convert multiple tags to double-click
'''


x_features=[]
x_tags=[]

def read_feature_list(fn,x):
  for l in open(fn,'r'):
    x.add(l.strip()) 

num_args = len(sys.argv) 
i=1
num_tags = 0
while i< num_args:
  tag = sys.argv[i]
  i+=1
  fn_feature = sys.argv[i]
  i+=1
  x_features.append(set([]))
  x_tags.append(tag)
  read_feature_list(fn_feature,x_features[num_tags])
  num_tags+=1

#print x_features
#print x_tags
#print 'num_tags:'+str(num_tags)

def feature_in_seg(l_f1): 
  for i in range(num_tags):
    for f1 in l_f1:
      if f1.split('=')[0] in x_features[i]:
        #print 'in tier:'+str(i)+' '+f1
        return x_tags[i]
  return None

for l in sys.stdin:
  l = l.strip()
  ll = l.split('\t')
  if(len(ll) !=3):
    sys.stderr.write('Map user-model error:'+l+'\n')
    continue
  in_seg=False
  #for f1 in ll[2].split(';'):
    #f,v = f1.split('=')
  tag=feature_in_seg(ll[2].split(';'))
  if tag:
    #print l
    print '%s\t{"double_click":["%s"]}\tsqi'%(ll[0],tag)
