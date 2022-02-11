#!/bin/bash
# Creates 2 input files required for Vcontact2:
# 1. a fasta-formatted amino acid file (PROTEIN_OUT)
# 2. a gene-to-genome mapping csv file (TMPFILE)
DATA_PATH=/net/mgx/linuxhome/mgx/courses/Viromics_2022/day_4
IN_PATH=$DATA_PATH/vcontact2-input
mkdir $IN_PATH

ORF_FILE=$DATA_PATH/fasta/l200.proteins.faa

####################################
# make gene to genome mapping file #
####################################

#protein_id,contig_id,keywords
#keywords must be separated by semicolon.
G2GFILE=$IN_PATH/gene-to-genome.csv
rm -f $G2GFILE

echo "protein_id,contig_id,keywords" >>$G2GFILE

cat $DATA_PATH/fasta/l200.proteins.faa | grep ">" | cut -f 1 -d " " | sed 's/^>//g' > $IN_PATH/protein_id.csv
cat $DATA_PATH/fasta/l200.proteins.faa | grep ">" | cut -f 1 -d " " | sed 's/^>//g' | sed 's/_[0-9]*$//g' > $IN_PATH/contig_id.csv
paste -d , $IN_PATH/protein_id.csv $IN_PATH/contig_id.csv >> $G2GFILE
rm $IN_PATH/protein_id.csv
rm $IN_PATH/contig_id.csv
