#!/usr/bin/env python
import sys

for line in sys.stdin:
  if "\tintron\t" not in line:
    continue
  line = line.rstrip()
  fields = line.split("\t")
  length = int(fields[4]) - int(fields[3]) + 1
  print "%d\t%s" % (length, line)
