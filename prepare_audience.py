import sys

'''
convert to double-click format
add to shuffled data
'''


x_printed=set([])

def read_seg_fn(fn, tag):
  for l in open(fn,'r'):
    cookie = l.strip()
    if cookie not in x_printed:
      print '%s\t{"double_click":["%s"]}\tsqi'%(cookie,tag)
      x_printed.add(cookie)

num_args = len(sys.argv) 
i=1
while i< num_args:
  fn = sys.argv[i]
  i+=1
  tag = sys.argv[i]
  i+=1
  read_seg_fn(fn,tag)
