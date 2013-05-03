#!/usr/bin/env python

import sys
import numpy as np
import re
from sklearn.svm import LinearSVC
from scipy.sparse import lil_matrix
from sklearn.linear_model import LogisticRegression

(feat_dict,n)=({},0)
for x in open('petco_feat.txt'):
    feat_dict[x.strip()] = n
    n += 1
d = len(feat_dict)
#print >> sys.stderr, feat_dict, d
#sys.exit(1)

(y, X_sp) = (np.zeros(500000), lil_matrix((500000, d)))

n = 0
for line in sys.stdin:
    fields = line.strip().split('\t')
  
    if len(fields) < 3: continue

    # feature
    for feat in fields[2].strip().split(';'):
        (k,v) = feat.split('=',1)
        if k in feat_dict and type(feat_dict[k]) == int:
            X_sp[n,feat_dict[k]] = v

    # target
    if re.search(r't.Rw.retargcnt', fields[1].strip()) or re.search(r't.Rx.retargcnt', fields[1].strip()):
        y[n] = 1

    #print >> sys.stderr, 'n=', n
    n += 1

print >> sys.stderr, 'finished loading X_sp and y'
print >> sys.stderr, X_sp.shape, y.shape

for c in [0.001,0.002,0.003,0.004,0.005]:
    linearsvc_model = LinearSVC(C=c, penalty="l1", dual=False)
    #print >> sys.stderr, 'successfully initialize the linearsvc_model'
    linearsvc_model.fit(X_sp, y)
    print >> sys.stderr, 'successfully fit the linearsvc_model'
    e = linearsvc_model.score(X_sp,y)
    print >> sys.stderr, 'C is', c, 'mean acc is', e

    logreg_model = LogisticRegression(C=c, penalty="l1", dual=False)
    #print >> sys.stderr, 'successfully initialize the logreg_model'                                                                                                
    logreg_model.fit(X_sp, y)
    print >> sys.stderr, 'successfully fit the logreg_model'
    e = logreg_model.score(X_sp,y)
    print >> sys.stderr, 'C is', c, 'mean acc is', e
