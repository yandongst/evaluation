import sys

x_feature={}
x_feature_uniq={}

x_feature_adx={}
x_feature_adx_uniq={}

x_target_feature={}
x_target_feature_uniq={}

x_cotarget_feature={}
x_cotarget_feature_uniq={}

x_nontrivial_feature=set([])
#3 counts: target_feature, impr_feature, click_feature, and each's count alone

pixels = {}
threshold=5

pixels['retarg']=[]
pixels['impr']=[]
pixels['click']=[]

def match_cotarget(input, pixel):
  for p in pixels[pixel]:
    if input == 'c.t.'+p:
      return True
  return False

def match_target(input, pixel):
  for p in pixels[pixel]:
    if input == 't.'+p:
      return True
  return False

def read_target_pixels(fn):
  for l in open(fn,'r'):
    l = l.strip()
    if l.startswith('#'):
      continue 
    tag,pixel = l.split(':')
    pixel = pixel.replace('-','_')
    if tag not in pixels:
      pixels[tag]=[]
    pixels[tag].append(pixel)

def inc_count(x,type,f,c):
  if type not in x:
    x[type]={}

  if f not in x[type]:
    x[type][f]=c
  else:
    x[type][f]+=c

def proc(l):
  #if len(l.split('\t')) !=2:
    #print 'err:'+l
    #return
  k,v = l.split('\t')
  kk = k.split('-')
  v1,v2 = v.split(' ')
  v1=float(v1)
  v2=float(v2)


  #feature-target count
  if len(kk)==2:
    if v2>=threshold:
      if kk[1] not in x_nontrivial_feature:
        if kk[1] == '':
          #print 'added:%s'%l
          return
        x_nontrivial_feature.add(kk[1]) 
      #if co feature-target pair
      for key in ['retarg','impr','click']: 
        if match_target(kk[0], key):
          inc_count(x_target_feature_uniq,key,kk[1], v1)
          inc_count(x_target_feature,key,kk[1], v2)
        if match_cotarget(kk[0], key):
          #print 'matched cotarget', kk[0], key
          inc_count(x_cotarget_feature_uniq,key,kk[1], v1)
          inc_count(x_cotarget_feature,key, kk[1],v2) 
          #print x_cotarget_feature
      else:
        pass
  #single targeto or feature count
  else:
    if k.startswith('t.'):
      #if k == 't.'+target:
        #print l
      ##do nothing for target count. not used in calculation
      pass 
    elif k.startswith('adx.'):
      if v2>=threshold:
        x_feature_adx_uniq[k[4:]]=v1
        x_feature_adx[k[4:]]=v2
    else:
      if v2>=threshold:
        x_feature_uniq[k]=v1
        x_feature[k]=v2

def print_header():
    print 'feature\tadx_cnt\tfeature_cnt\tretarg_cnt\tretarg_prob\tviewers\tclickers\tclicker_rate\tviews\tclicks\tCTR'

def get_ratio(x,k1,k2):
  if k1 not in x or k2 not in x:
    return 0.0
  else:
    return x[k1]/x[k2]

def get_ratio_str(x,k1,k2):
  cnt1 = 0.0
  cnt2 = 0.0
  if k1 in x:
    cnt1 = x[k1]
  if k2 in x:
    cnt2 = x[k2]
  ratio = 0.0
  if cnt1>0.0:
    ratio = cnt2/cnt1

  str = '%.1f\t%.1f\t%.5f'%(cnt1,cnt2,ratio)
  return str

def output_stats(merge_cocount):
  #print x_cotarget_feature
  #print x_feature_uniq
  for k in x_nontrivial_feature:
    count_uniq = {} #feature's co-count with target
    count_nonuniq = {} #feature's nonuniq co-count with target
    cocount_uniq = {} #feature's co-count with co-target
    cocount_nonuniq = {}


    for key in ['retarg','impr','click']: 
      if k in x_target_feature_uniq[key]:
        count_uniq[key] = x_target_feature_uniq[key][k]
      if k in x_target_feature[key]:
        count_nonuniq[key] = x_target_feature[key][k] 
      if k in x_cotarget_feature_uniq[key]:
        cocount_uniq[key] = x_cotarget_feature_uniq[key][k]
      if k in x_cotarget_feature[key]:
        cocount_nonuniq[key] = x_cotarget_feature[key][k] 

    feature_cnt_uniq = 0 #feature itself #occurrenec, with target or not
    if k in x_feature_uniq:
      feature_cnt_uniq = x_feature_uniq[k]
    feature_cnt_nonuniq = 0
    if k in x_feature:
      feature_cnt_nonuniq = x_feature[k]

    feature_adx_cnt_uniq = 0 #feature itself #occurrenec, with target or not
    if k in x_feature_adx_uniq:
      feature_adx_cnt_uniq = x_feature_adx_uniq[k]
    feature_adx_cnt_nonuniq = 0
    if k in x_feature_adx:
      feature_adx_cnt_nonuniq = x_feature_adx[k]
    #else:
      #sys.stderr.write('no key in adx cnt:'+k+'!\n')
  
    count_uniq['feature'] = feature_cnt_uniq
    count_nonuniq['feature'] = feature_cnt_nonuniq

    count_uniq['feature_adx'] = feature_cnt_uniq
    count_nonuniq['feature_adx'] = feature_cnt_nonuniq
    
  
    non_coreach = {}
    for key in ['retarg','impr','click']: 
      non_coreach[key] = feature_cnt_uniq
      if key in cocount_nonuniq:
        non_coreach[key] = feature_cnt_uniq- cocount_nonuniq[key]
    

    #add co-count to count. if T1 and T2 are the same, then only co-count has non-zero values
    if merge_cocount:
      for key in ['retarg','impr','click']: 
        if key in cocount_uniq:
          if key not in count_uniq:
            count_uniq[key] = cocount_uniq[key]
          else:
            count_uniq[key] += cocount_uniq[key]
        if key in cocount_nonuniq:
          if key not in count_nonuniq:
            count_nonuniq[key] = cocount_nonuniq[key]
          else:
            count_nonuniq[key] += cocount_nonuniq[key]

    #print count_nonuniq

    #print '%s\t%s\t%s\t%s'%(k,str_retarg_uniq, str_ratio, str_ctr)
    print '%s\t%d\t%s\t%s\t%s'%(k,feature_adx_cnt_uniq,get_ratio_str(count_uniq,'feature','retarg'), get_ratio_str(count_uniq,'impr','click'), get_ratio_str(count_nonuniq,'impr','click')) 

fn = sys.argv[1]
merge_cocount=True
if len(sys.argv) > 2:
  if sys.argv[2]=='--cocount':
    merge_cocount=True

if merge_cocount:sys.stderr.write('coconut\n')

read_target_pixels(fn)
sys.stderr.write('pixels:'+str(pixels)+'\n')

for key in ['retarg','impr','click']: 
  x_target_feature[key]={}
  x_target_feature_uniq[key]={}
  x_cotarget_feature[key]={}
  x_cotarget_feature_uniq[key]={}

print_header()

for l in sys.stdin:
  l = l.strip()
  proc(l)

#print x_target_feature

output_stats(merge_cocount)
