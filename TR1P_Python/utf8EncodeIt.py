#!/usr/bin/env python
# Python V2 encode file to avoid wordlist processing errors
# Tr1p 11-16-18
import sys, codecs
infile = sys.argv[1]
outfileName = ""
data = codecs.open(infile,'rb').read().split('\n')

if len(infile.split('/')) > 1:
    userArg = infile.split('/')
    targetFile = userArg[-1]
    print(targetFile)
    outfileName =  "utf8_" + targetFile
else:
    outfileName = "utf8_" + infile
print(outfileName)
outfile = open(''.join(outfileName),'w')
for item in data:
    print >> outfile, item
outfile.close()
