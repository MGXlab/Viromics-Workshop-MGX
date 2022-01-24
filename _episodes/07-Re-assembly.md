---
title: "Re-assembly"
teaching: 10
exercises: 20
questions:
- ""
objectives:
- "Run another assembly with the binned scaffolds."
- "Check if the binned scaffolds are contained in any of the re-assembled scaffolds."
keypoints:
- "If you got this far, you are a pro."
---

In this section we will try to get a complete genome from the scaffolds of our bin. For this, we will do another assembly as follows:
- Using the binned scaffolds as a _backbone_ to guide the assembler
- Using only one sample to minimize between-sample heterogeneity and microorganisms' diversity. Both factors make harder for the assembler to get a contiguous, complete genome.

>## Discussion: Sample for the re-assembly
> Look at the heatmap in `3_profiles/heatmap.png` and explain what you see. With which sample do you think it will be easier for the assembler to reconstruct the complete genome?
{: .challenge}

We will use SPAdes with the same parameters as in the cross-assembly, but also with `--trusted-contigs` for the binned scaffolds. This time it should take only one or two minutes.

~~~
# create a directory 4_re-assembly
$ mkdir 4_re-assembly

# change the extension of the FASTA file from .fna to .fasta . SPAdes complains otherwise
$ mv 0_raw-data/F2T1.fna 0_raw-data/F2T1.fasta

# run SPAdes
$ spades.py --iontorrent --only-assembler --trusted-contigs 3_profiles/scaffolds_corr_90.fasta --careful -s 0_raw-data/F2T1.fasta -o 4_re-assembly/spades_output

# inspect the results by looking at the re-assembled scaffolds identifiers
$ grep '>' 4_re-assembly/spades_output/scaffolds.fasta | head
~~~

To know if our binned scaffolds are contained in any scaffold of the re-assembly, we will use BLAST locally. The database will be the scaffolds from the re-assembly, and we will BLAST the binned scaffolds to them to see if there is any getting most of the matches. First we need to build the database with `makeblastdb`, and then do the actual BLAST with `blastn`.

~~~
# build the database
$ mv 4_re-assembly/spades_output/scaffolds.fasta 4_re-assembly/re-scaffolds.fasta
$ makeblastdb -in 4_re-assembly/re-scaffolds.fasta -out 4_re-assembly/re-scaffolds.blastdb -dbtype nucl

# run BLAST
$ blastn -db 4_re-assembly/re-scaffolds.blastdb -query 3_profiles/scaffolds_corr_90.fasta -out 4_re-assembly/corr_scaffolds_to_re.txt -outfmt 6
~~~

Open `4_re-assembly/corr_scaffolds_to_re.txt` to inspect the results. Each line represents an alignment between a binned scaffold (or **query**, first column) and a re-assembled scaffold from the database (or **subject**, second column). Interesting columns to look at are the **%similarity** (column 3), **alignment length** (column 4), **evalue** (column 11) or **bitscore** (column 12).

If everything went well, you should see that one of re-assembled scaffolds is around ~96Kb and contains most of the scaffolds of our bin. Open the FASTA file, look for that scaffold and Blast it online.

Congratulations, you just rediscovered the crAssphage :)


{% include links.md %}
