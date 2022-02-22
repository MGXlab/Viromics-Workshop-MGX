#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 27 09:54:30 2022

@author: tina
"""

import sys

category_translation={1:1.00,
                      2:0.70,
                      0:0.51
                      }

def grab_contig_ids(infile):
    pred={}
    fastafile=infile.rsplit('/', 1)[0]+'/fasta/input_sequences.fna'
    with open(fastafile) as inf:
        for line in inf:
            if line.startswith('>'):
                contig_id=line.rstrip().split('_',1)[1]
                number=int(contig_id.split('_')[1])
                pred[number]=[contig_id,0]
    return pred

def reformat_virsorter(infile, outfile, pred):
    category=0
    with open(infile) as inf:
        for line in inf:
            if not line.startswith('#'):
                contig_id=line.split(',')[0].split('_', 1)[1].rsplit('-',1)[0]
                number=int(contig_id.split('_')[1])
                pred[number][1]=1
                if category==0:
                    print('Error!')
                else:
                    score=category_translation[category%3]
                    pred[number].append(score)
                
            else:
                if line[3].isdigit():
                    category=int(line[3])
            
    with open(outfile, 'w') as outf:
        numbers=list(pred.keys())
        numbers.sort()
        outf.write('name,pred,score\n')
        for n in numbers:
            if len(pred[n])>2:
                outf.write('{},{},{}\n'.format(pred[n][0],pred[n][1],pred[n][2]))
            else:
                outf.write('{},{},{}\n'.format(pred[n][0],pred[n][1],0))

if __name__=='__main__':
    inf=sys.argv[1]
    outf=sys.argv[2]
    print("Grabbing contig sequences")
    pred=grab_contig_ids(inf)
    print("Reformatting Virsorter output")
    reformat_virsorter(inf, outf, pred)
