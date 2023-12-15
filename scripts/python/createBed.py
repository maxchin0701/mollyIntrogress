#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 15 17:12:59 2023

@author: maxchin
"""
#import module
from Bio import SeqIO

#take in user inputs
inFile = input("Input .fasta/.fna file: ")
scaffCutoff = int(input("Scaffold size cutoff in bp: "))
intervalSize = int(input("Interval size in bp: "))
outFile = input("output .bed file: ")


#variables to store scaff names and length
seqN = []
seqL = []

#keep scaffolds above 100kb
for record in SeqIO.parse(inFile, "fasta"):
    if len(record.seq) >= scaffCutoff :
        seqL.append(len(record.seq))
        seqN.append(record.name)

#variables to store scaff names, start, and end
scaffL = []
startL = []
stopL = []
        
#loop through scaffolds
for i in range(0,len(seqN)) :
    
    #define name, start, and end for current scaffold
    scaffCur = seqN[i]
    startCur = 0
    stopCur = 0
    
    #while loop to iterate until we exceed scaffold length
    while stopCur < (seqL[i] - 1) :
        #append scaffold and current start
        scaffL.append(scaffCur)
        startL.append(startCur)
        
        #get current end
        stopCur = startCur + intervalSize
        
        #check if current stop is larger than or equal to scaffold size
        if stopCur >= seqL[i]:
            stopCur = seqL[i] - 1
        
        #append stopCur
        stopL.append(stopCur)
        
        #set startCur to new value
        startCur = startCur + intervalSize
  
#write file
print("Writing .bed file")
out = open(outFile, 'w')

for i in range(0,len(scaffL)):
    out.write(scaffL[i] + "\t" + str(startL[i]) + "\t" + str(stopL[i]) + "\n")

out.close()

print("Done")


        