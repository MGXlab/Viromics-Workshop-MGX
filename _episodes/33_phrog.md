---
title: "Functional annotation"
teaching: 30
exercises: 30
questions:
- ""
objectives:
- ""
keypoints:

---

We now know where our protein encoding sequences are located on the genome and what their amino acid sequence is, however, we do not know what their function in the phage is. To figure this out we will compare the by `meta` predicted protein sequences to the PHROG database using [HHsuite](https://github.com/soedinglab/hh-suite).

First we have to download the HHsuite index from the PHROG website. The models in the index file only have an ID, like `phrog_13`, which is not informative by itself. Hence we also download the `phrog_annot_v3.tsv` to link the ID to annotations (e.g. `terminase protein`).

### Downloading the phrog HH-suite and corresponding annotation table

Again make sure we are in `~/day3/`, then run the code below

~~~
mkdir phrog
cd phrog
wget https://phrogs.lmge.uca.fr/downloads_from_website/phrog_annot_v3.tsv
wget https://phrogs.lmge.uca.fr/downloads_from_website/phrogs_hhsuite_db.tar.gz
tar -xvzf phrogs_hhsuite_db.tar.gz
cd ..
~~~
{: .language-bash}

> ## Annotated proteins
> - __How many phrog annotation did we download (see the tsv)?__
{: .challenge}

### Annotating the predicted proteins

Unfortunately we cannot just pass our `default_proteins.faa` to hhsuite (unlike [hmmer](http://hmmer.org/) search. We first have to create a FASTA file for each invidiual protein sequence to do this we will use `seqkit`.

~~~
cd prodigal_default
mkdir single_fastas
seqkit split -i -O single_fastas/ proteins.faa
~~~
{: .language-bash}

#### Running hhblits on phrog

Now we can finally annotate the protein sequences! We have to be in the prodigal_default directory for this and the next step.

~~~
mkdir hhsearch_results
for file in single_fastas/*.faa; do base=`basename $file .faa`; echo "hhblits -i $file -blasttab hhsearch_results/${base}.txt -z 1 -Z 1 -b 1 -B 1 -v 1 -d ../phrog/phrogs_hhsuite_db/phrogs -cpu 1" ; done > all_hhblits_cmds.txt
parallel --joblog hhblits.log -j8 :::: all_hhblits_cmds.txt
~~~
{: .language-bash}

> ## HHblits
> - __For our search we use `hhblits`, but we could have also used `hhsearch`, what is the difference?__ (see the [wiki](https://github.com/soedinglab/hh-suite/wiki))
> - __You probably noticed the message "WARNING: Ignoring invalid symbol '*', why is this happening?__
{: .challenge}

#### Parsing the results

Now it is time to parse the results :) For each query (predicted protein) we grab the best match (from `hhsearch_results`), link the ID to the annotation (in `phrog_annot_v3.tsv`) and find the genomic location in our Prodigal output file (`genes.txt`). Get the Python script to do this from GitHub:

~~~
wget https://raw.githubusercontent.com/rickbeeloo/day3-data/main/parse_hmm_single.py
python3 parse_hmm_single.py hhsearch_results/ hhsearch_results.txt ../phrog/phrog_annot_v3.tsv genes.txt
~~~
{: .language-bash}

I also wrote a script that will visualize the gene annotation of two provided contigs using [gggenes](https://cran.r-project.org/web/packages/gggenes/vignettes/introduction-to-gggenes.html). You can find the script [here.](https://github.com/rickbeeloo/day3-data/blob/main/plot_contigs.R). Like before create a new Rscript and copy paste the code. The line `df <- read.table(file.choose().... (line: x)` will open a file dialog where you can choose the `hhsearch_results.txt`. Then run the while loop that will ask you to provide two contig identifiers. Just a unique part is sufficient, such as `bin_01||F1M_NODE_1`. I added the option to save to an output file in case of weird symbols again... For example it will produce a figure like this:

![Image]({{ page.root }}/fig/rick.png)

Compare several of the following contigs:

```
bin_87||F4M_NODE_3
bin_01||F1M_NODE_1
bin_62||F3M_NODE_2
bin_13||F1T1_NODE_28
```

> ## HHblits
> Take a closer look at the contigs `bin_01||F1M_NODE_1` vs `bin_62||F3M_NODE_2` - both crassphages.
> - __What do you notice in this comparison?__
>
> - __Go to Figure 7 of [this paper](https://www.nature.com/articles/s41467-021-21350-w), is this what you thought? How are we going to tackle this?__
{: .challenge}


### Annotating two contigs with a different translation table

In the paper a modified version of Prodigal is used. Instead of modifying Prodigal we will use translation table 15 where TAG is considered a coding codon instead of a STOP(*).

- __How do we tell Prodigal to use this translation table? [wiki](https://github.com/hyattpd/prodigal/wiki)__

(NOTE: using a different translation table is not supported in meta mode, so we have to use the normal gene prediction here)

We have to go back to the `~/day3/` directory and then run the following

~~~
mkdir prodigal_dif_table
cd prodigal_dif_table
touch two_contigs.fasta
cat ../fasta_bins/bin_01.fasta > two_contigs.fasta
cat ../fasta_bins/bin_62.fasta >> two_contigs.fasta
prodigal -i two_contigs.fasta -a two_contig_proteins.faa -o two_contig_genes.txt -f sco -g 15
mkdir single_fastas
seqkit split -i -O single_fastas/ two_contig_proteins.faa
mkdir hhsearch_results
for file in single_fastas/*.faa; do base=`basename $file .faa`; echo "hhblits -i $file -blasttab hhsearch_results/${base}.txt -z 1 -Z 1 -b 1 -B 1 -v 1 -d ../phrog/phrogs_hhsuite_db/phrogs -cpu 1"; done > all_hhblits_cmds.txt
parallel --joblog hhblits.log -j8 :::: all_hhblits_cmds.txt
wget https://raw.githubusercontent.com/rickbeeloo/day3-data/main/parse_hmm_single.py
python3 parse_hmm_single.py hhsearch_results/ two_contig_hhsearch_results.txt ../phrog/phrog_annot_v3.tsv two_contig_genes.txt
~~~
{: .language-bash}

Use the script from the previous step (this time loading the two_contig_hhsearch_results) and again visualize the contigs `bin_01||F1M_NODE_1` vs `bin_62||F3M_NODE_2`.

> ## Compare predictions
> - __How did the prediction change? and what about `bin_01||F1M_NODE_1`?__
{: .challenge}





{% include links.md %}
