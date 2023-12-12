#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov 17 13:09:02 2023

@author: maxchin
"""

#import module
from Bio import SeqIO

#take in user inputs
inFile = input("Input .fasta/.fna file: ")
scaffCutoff = int(input("Scaffold size cutoff in bp: "))
dipProb = float(input("Diploid probability: "))
tripProb = float(input("Triploid probability: "))
outFile = input("output .tsv file: ")


#variables to store scaff names and length
seqN = []

#keep scaffolds above 100kb
for record in SeqIO.parse(inFile, "fasta"):
    if len(record.seq) >= scaffCutoff :
        seqN.append(record.name)
                
#write scaffolds to file       
out = open(outFile, 'w')
out.write("CONTIG_NAME\tPLOIDY_PRIOR_2\tPLOIDY_PRIOR_3\n")
for i in range(0,len(seqN)):
    out.write(seqN[i] + "\t" + str(dipProb) + "\t" + str(tripProb) + "\n")

out.close()




