#!/usr/bin/env python
import re
import sys

if __name__ == "__main__":
  augfile = sys.stdin.read()
  translations = re.findall("protein sequence = \[([^\]]+)\]", augfile, re.MULTILINE)
  count = 0
  for pep in translations:
    count += 1
    seq = pep.replace(' ', '').replace('#', '').replace('\n', '')
    print ">s%04d\n%s" % (count, seq)
