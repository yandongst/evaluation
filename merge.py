import sys

x={}

for l in sys.stdin:

  l = l.strip()
  ll = l.split('\t')

  if len(ll) != 3:
    #sys.stderr.write(l+'\n')
    continue

  c,adg,ts = l.split('\t')
  #print c
  #print adg
  #print ts
  if c not in x:
    x[c]=set([])
  x[c].add(adg)

for c in x:
  print c+'\t'+str(','.join(x[c]))
