import sys

fn_stats = sys.argv[1]
fn_pixels = sys.argv[2]

x={}

for l in open(fn_pixels,'r'):
  l = l.strip()
  name,pixel = l.split('","')
  name=name.replace('"','')
  pixel=pixel.replace('"','')
  x[pixel]=name
  #print pixel,name

for l in open(fn_stats,'r'):
  l = l.strip()
  if l.startswith('a.'):
    pixel,r=l.split('\t',1)
    if pixel[2:] in x:
      print 'a.'+x[pixel[2:]]+'\t'+r
    else:
      print l 
  else:
    print l
