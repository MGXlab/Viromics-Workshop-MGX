---
title: "Clustering proteins"
teaching: 30
exercises: 30
questions:
- ""
objectives:
- ""
keypoints:

---

We now queried our protein sequences directly against the models from the PHROG database. To increase sensitivity of our search we could first build models, more specifically Hidden Markov Models (HMMs), ourselves and query these against the database. Take a look at the EBI description [here](https://www.ebi.ac.uk/training/online/courses/pfam-creating-protein-families/what-are-profile-hidden-markov-models-hmms/) to get an idea of what this will look like. To build these we will go through the following steps:


*   Clustering similar protein sequences together ([MMSEQ2](https://github.com/soedinglab/MMseqs2))
*   Generation of a MSA for each cluster ([MAFFT](https://github.com/GSLBiotech/mafft))
* Querying the MSAs against the PHROG models using HHBlits

For our clustering (and thus HMM building) we will also include all viral RefSeq sequences. We have to go back to the ~/day3/ directory and then run the following

~~~
mkdir refseq
cd refseq
wget https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.1.protein.faa.gz .
wget https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.2.protein.faa.gz .
wget https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.3.protein.faa.gz .
wget https://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.4.protein.faa.gz .
zcat viral* >> refseq_proteins.faa
rm -rf *.gz*
cd ..
~~~
{: .language-bash}

> ## RefSeq
> - __Why would we include RefSeq viral sequences and not just our phage proteins?__
> - __How many RefSeq sequences did we download?__
{: .challenge}

We will create a new FASTA file that has both our predicted proteins and the RefSeq protein sequences (again, check if you are in `~/day3/`).

~~~
mkdir refseq_clusters
cd refseq_clusters
touch proteins_with_refseq.fasta
cat ../prodigal_default/proteins.faa > proteins_with_refseq.fasta
cat ../refseq/refseq_proteins.faa >> proteins_with_refseq.fasta
~~~
{: .language-bash}

Let the clustering begin! (still in the `refseq_clusters` folder)

~~~
mkdir mmseqs_db
mkdir mmseqs_clusters
mmseqs createdb proteins_with_refseq.fasta mmseqs_db/protein.with.refseq.db
time mmseqs cluster mmseqs_db/protein.with.refseq.db mmseqs_clusters/proteins.with.refseq.db tmp -s 7.5 --threads 8
mmseqs createtsv mmseqs_db/protein.with.refseq.db mmseqs_db/protein.with.refseq.db mmseqs_clusters/proteins.with.refseq.db refseq_clusters.tsv
~~~
{: .language-bash}


> ## MMseqs2
> - __Look at the `cluster` parameters for mmseqs2, why do we set -s to 7.5? (look at [the manual](https://github.com/soedinglab/MMseqs2/wiki))__
> - __How many clusters did MMSeqs2 find? ( see `refseq_clusters.tsv` )__
{: .challenge}

To align the sequences within each cluster we first have to generate a FASTA file from them. Querying clusters just contianing one sequence would be the same as our previous query hence we only include clusters satisfying the following criteria:

*   At least one prodigal predicted protein (exclusively RefSeq clusters are discarded)
*   At least 2 sequences in total

I wrote a script to get the FASTA files from the clusters, align these using MAFFT and then search these against PHROG. However since this combined will take more than 2 hours we will just download the results:

~~~
wget https://raw.githubusercontent.com/rickbeeloo/day3-data/main/msa_hhsearch_results.txt
~~~
{: .language-bash}

The commands that I used are here:

~~~
#  mkdir output
#  python3 ../scripts/get_cluster_fastas.py output proteins_with_refseq.fasta refseq_clusters.tsv --min_seqs 2
# for file in output/Fasta/*.fasta; do name=`basename $file`; mafft --globalpair --maxiterate 1000 $file > ../MSA/${name}; done
# for file in output/MSA/*.fasta; do base=`basename $file .fasta`; hhblits -i $file -M 50 -blasttab output/HMM/${base}.txt -cpu 8 -d ../phrog/phrogs_hhsuite_db/phrogs -v 1 -z 1 -Z 1 -b 1 -B 1; done
# python3 ../scripts/parse_hmm_cluster.py output/HMM/ msa_hhsearch_results.txt ../phrog/phrog_annot_v3.tsv ../prodigal_default/genes.txt refseq_clusters.tsv output/cluster_stats.txt
~~~
{: .language-bash}

# A look at the clusters

Again create a new Rscript and paste the code from [here](https://github.com/rickbeeloo/day3-data/blob/main/msa_cluster_plot.R), then load the `msa_hhsearch_results.txt` file and generate the figures. Like before it will also save the plot.

> ## Clusters
> - __What do you see?__
{: .challenge}

There are some proteins that are found frequently in different viruses and our contigs (see `NA`s in the figure). Lets take a look at `386 NA` with sequence:

`MGYDYEMILDEVDKLSLQGRVEEAKEFVRELVPPLFAIDFTNLMELIERNTYKL`

[Blast the protein](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastp&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) against NCBI.

> ## Blast
> - __Did you find a functional annotation?__
>
> - __We tried a single protein search and a more sensitive profile-profile search. What else can we do to get a clue about the function of this protein?__
{: .challenge}

> ## Bonus
> One other thing we can try is to predict its protein structure and compare that to the database as even with deviating amino acids structures can be similair. Go to the [alphafold notebook](https://colab.research.google.com/github/sokrypton/ColabFold/blob/main/AlphaFold2.ipynb) and follow the instructions. Basically replace the `query sequence` by the protein seqence above and then press the "play arrow" for each cell in the notebook from top to bottom - each time waiting for the previous one to finish. Then download the zip file (unzip it) and choose one of the `.pdb` files to upload it to http://shape.rcsb.org/ ([paper](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1007970)) to perform a search against the PDB database. When an assembly is availalbe (assembly column) you can press on the image to view the protein and its annotation in the database.
>
> - __Do the results give you any clues?__
>
>We can look a bit more in detail by aligning our protein structure with that of a match. For example align it with [4HEO](https://www.rcsb.org/3d-view/4HEO/1). Press the `Download files > pdb format`. Then go to [TM-align](https://zhanggroup.org/TM-align/) and input one of the predicted structure pdb files and that of 4HEO.
>
> - __Does the alignment look good?__
{: .testimonial}



{% include links.md %}
