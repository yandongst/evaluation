import sys
import re

ls_uniq=[]
ls_total=[]
current_c='' 

for l in sys.stdin:
  l = l.strip()

  if(len(l.split('\t'))!=2): 
    sys.stderr.write('Red metrics error:'+l+'\n')
    continue

  c,f = l.split('\t') 

  f1,f2 = f.split(' ')

  if current_c == '' and c!='':
    current_c = c

  if current_c != c:
    x = sum(ls_uniq)
    x2 = sum(ls_total)
    #if x>0.0:
    print current_c+'\t'+str(x)+' '+str(x2)
    current_c = c
    del ls_uniq[:]
    del ls_total[:]

  ls_uniq.append(float(f1)) 
  ls_total.append(float(f2)) 

print current_c+'\t'+str(sum(ls_uniq))+' '+str(sum(ls_total))
