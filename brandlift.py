import sys

s_target=set([])
def get_targetset(fn):
  for l in open(fn,'r'):
    if l.startswith('#'):continue
    s_target.add(l.strip())
  #s_target.add('t.RTB_Samsung_AV.imprcnt')
  #s_target.add('t.RTB_Samsung_HA_HighSQI.imprcnt')
  #s_target.add('t.RTB_Samsung_HA_LowSQI.imprcnt')
  #s_target.add('t.RTB_Samsung_HA_Regular.imprcnt')
  sys.stderr.write(str(s_target)+'\n')

s_feature=set([])
def get_featureset(fn):
  for l in open(fn,'r'):
    if l.startswith('#'):continue
    s_feature.add(l.strip())
  sys.stderr.write(str(s_feature)+'\n')
  #s_feature.add('4.99.shopping_home_garden')

l_clusters=[]

x_cnt={}
def get_clusters():
  for i in xrange(50):
    cluster_key='a.LDA_'+str(i)
    l_clusters.append(cluster_key)
    x_cnt[cluster_key]={}
    x_cnt[cluster_key]['cnt_e_f']=0
    x_cnt[cluster_key]['cnt_e_nf']=0
    x_cnt[cluster_key]['cnt_ne_f']=0
    x_cnt[cluster_key]['cnt_ne_nf']=0


def has_target(ts):
  for t in ts.split(';'):
    k,v=t.split('=')
    if k in s_target:
      return True
  return False

def has_feature(ts):
  for t in ts.split(';'):
    k,v=t.split('=')
    # 99 level match
    if k[2:] in s_feature:
    # change to 
    #  if k in s_feature:
    # for exact feature match
      return True
  return False

def get_cluster_list(ts):
  l=[]
  for t in ts.split(';'):
    k,v=t.split('=')
    if k in x_cnt:
      l.append(k)
  return l


fn_targetset=sys.argv[1]
fn_featureset=sys.argv[2]

sys.stderr.write('target file:'+fn_targetset+'\n')
sys.stderr.write('feature file:'+fn_featureset+'\n')

get_targetset(fn_targetset)
get_featureset(fn_featureset)
get_clusters()


for l in sys.stdin:
  l = l.strip()
  c,ts,fs=l.split('\t')
  exposed=has_target(ts)
  hasf=has_feature(fs)
  l_c=get_cluster_list(fs)
  #print l_c
  #print c,exposed,hasf
  for c in l_c:
    if exposed and hasf:
      x_cnt[c]['cnt_e_f']+=1
    elif exposed and not hasf:
      x_cnt[c]['cnt_e_nf']+=1
    elif not exposed and hasf:
      x_cnt[c]['cnt_ne_f']+=1
    elif not exposed and not hasf:
      x_cnt[c]['cnt_ne_nf']+=1
    else:
      sys.stderr.write('Error!\n')
      sys.exit(1)

for c in x_cnt:
  print c+':',
  cnt_e_f = float(x_cnt[c]['cnt_e_f'])
  cnt_e_nf = float(x_cnt[c]['cnt_e_nf'])
  cnt_ne_f = float(x_cnt[c]['cnt_ne_f'])
  cnt_ne_nf = float(x_cnt[c]['cnt_ne_nf'])
  #exposed= float(x_cnt[c]['cnt_e_f'])/float(x_cnt[c]['cnt_e_f']+x_cnt[c]['cnt_e_nf'])
  #nexposed= float(x_cnt[c]['cnt_ne_f'])/float(x_cnt[c]['cnt_ne_f']+x_cnt[c]['cnt_ne_nf'])
  exposed=0.0
  if (cnt_e_f+cnt_e_nf)>0.0: 
    exposed= cnt_e_f/(cnt_e_f+cnt_e_nf)
  nexposed=0.0
  if (cnt_ne_f+cnt_ne_nf)>0.0:
    nexposed= cnt_ne_f/(cnt_ne_f+cnt_ne_nf)
  if nexposed>0.0:
    print nexposed,exposed,exposed/nexposed,cnt_e_f,cnt_e_f+cnt_e_nf,cnt_ne_f, cnt_ne_f+cnt_ne_nf
  else:
    print nexposed,exposed,0.0,cnt_e_f,cnt_e_f+cnt_e_nf,cnt_ne_f, cnt_ne_f+cnt_ne_nf
