---
title: "Phylogeny based on marker genes"
teaching: 0
exercises: 60
questions:
- "Can we use marker genes to infer phylogeny and taxonomy?"
objectives:
- "Make a phylogeny based on terminase large subunit"

keypoints:
- ""

---

As we discussed this morning, we can use the evolutionary history of certain genes to 
address questions about the evolution and function of viruses. Although there are no
universal marker genes for all the viruses, but many viral lineages share one or more
marker genes that can be used for to assess relationships between the viruses carrying 
them. Our samples were metaviromes from the human gut. Like many biomes, the human gut
virome contains many bacteriophages, and we can use the large subunit of the terminase 
(TerL) gene to study how they are related. The TerL
gene, present in all members of the _Caudovirales_, pumps the genome inside an empty
procapsid shell during virus maturation by using both enzymatic activities necessary
for packaging in such viruses: the adenosine triphosphatase (ATPase) that powers
DNA translocation and an endonuclease that cleaves the concatemeric genome at both
initiation and completion of genome packaging.


### Step 0. Activate environment and download software
```
# Activate environment
$ conda activate day4_phyl

# Download Aliview for multiple sequence alignment inspection
$ wget https://ormbunkar.se/aliview/downloads/linux/linux-versions-all/linux-version-1.28/aliview.tgz
$ tar zxvf aliview.tgz
```

### Step 1. Gather large terminase proteins from the bins and database
First you need to gather the large terminase sequences from your bins and from the reference database. To do the latter, go to [NCBI Virus](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/) and follow steps below:

1. Click on 'Find Data' and then in 'All viruses' (A).
2. Select only RefSeq genomes (B).
3. In the 'Proteins' section (C), write __terminase__ and select 'terminase large subunit' from the drop-down menu (D).
4. Then, click 'Download' (E). Select 'Protein', 'Download all records', 'Build custom', and add 'Family', 'Genus' and 'Species' by clicking 'Add' (F).  
5. Click 'Download' and save the file to `refseq_terl.faa`.

![Image]({{ page.root }}/fig/ncbi_virus.png)


After this, use the script `extract_random_refseq_terl.py`. This script reads the
terminases FASTA file you just downloaded from RefSeq and creates a tabular file
with the taxonomy information. You will use it later to annotate the tree. By default,
it keeps all the TerL sequences (~2k), although you can downsize it to _n_ random
sequences per family (look at the `n_random` option). Since RefSeq does not contain
(yet) all the diversity of crassphages described so far, we provide you with the
 `crassvirales_repr_terls.faa` file, with the terminases of representatives crassphages.
Use this FASTA file with the option `--crassvirales_faa`, and its taxonomy annotation
with `--crassvirales_summary`. Create two versions of this ouput file, one with all
the RefSeq proteins and another downsized (you choose the value for `n_random`).

~~~
# download reference crassphages
$ wget https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-2022/gh-pages/code/day1/crassvirales_repr_terls.faa
$ wget https://raw.githubusercontent.com/MGXlab/Viromics-Workshop-2022/gh-pages/code/day1/crassvirales_repr_terls.summary

# process reference TerL sequences
$ python extract_random_refseq_terl.py -f refseq_terl.faa \
  -n <N_DOWNSIZE> -c crassvirales_repr_terls.faa \
  -s crassvirales_repr_terls.summary -o refseq_crass_terl.faa \
  -a refseq_crass_terl.annot
~~~

Now, to gather the large terminases annotated in the bins, you can use the python script `get_terl_bins.py`. Have a look at the help message to see the parameters you need. Save the results in `bins_terl.faa`.

~~~
# Run the script get the bins terminases
$ python gather_terminases_bins.py ...
~~~
{: .language-bash}


After this, use `cat` to merge RefSeq, Crassvirales and bins terminases in the file `bins_refseq_crass_terl.faa`..

### Step 2. Multiple sequence alignment
Align the sequences using the MAFFT software. Check the [manual](https://mafft.cbrc.jp/alignment/software/algorithms/algorithms.html) for more information.

> ## Alignment algorithm
> Have a look at the different algorithms available with MAFFT. __Which one do you
> think best fits our data? Can you use one of the most accurate?__
{: .challenge}

### Step 3. Infer the TerL phylogeny
Use `fasttree` to infer the TerL phylogeny from the multiple sequence alignment. Once
finished, upload the tree to [iToL](https://itol.embl.de/). Add taxonomic annotation
in the _Datasets_ section for a better understanding of the tree.

> ## Alignment algorithm
> - __Can you explain what you see? Where do our (bins) terminases fall? Are there any long branches that seem out of place?__
{: .challenge}


### Step 4. Refine the tree

Look at the multiple sequence alignment (MSA) with Jalview as you did yesterday. **Are there any sequences that seem out of place?** If so, remove those sequences. Trim the MSA to remove positions with a high abundance of gaps using `trimal` and the `-gt` parameter.

Use this trimmed MSA to construct the TerL phylogeny by repeating steps 2 and 3. Does this improve the tree?

{% include links.md %}
