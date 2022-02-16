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


### Step 0. Activate conda environment
```
$ conda activate day4_phyl
```

### Step 1. Gather large terminase proteins from the bins and database
First you need to gather the large terminase sequences from your bins and from the reference database. To do the latter, go to [NCBI Virus](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/) and follow steps below:

1. Click on 'Find Data' and then in 'All viruses' (A).
2. Select only RefSeq genomes (B).
3. In the 'Proteins' section (C), write __terminase__ and select 'terminase large subunit' from the drop-down menu (D).
4. Then, click 'Download' (E). Select 'Protein', 'Download all records', 'Build custom', and add 'Family', 'Genus' and 'Species' by clicking 'Add' (F).  
5. Click 'Download' and save the file to `refseq_terl.faa`.

![Image]({{ page.root }}/fig/ncbi_virus.png)

To gather the large terminases annotated in the bins, you can use the python script `gather_terminases_bins.py`. Have a look at the help message to see the parameters you need. Save the results in `bins_terl.faa`.

~~~
# Run the script get the bins terminases
$ python gather_terminases_bins.py ...
~~~
{: .language-bash}

After this, use `cat` to merge in the file `bins_refseq_terl.faa` the RefSeq terminases you downloaded and the terminases from the bins.

### Step 2. Multiple sequence alignment
Align the sequences using Mafft. Check the [Mafft manual](https://mafft.cbrc.jp/alignment/software/algorithms/algorithms.html).
**Q:** Which method do you think best fits our data? Can you use one of the most accurate methods?

### Step 3. Infer the TerL phylogeny
Use fasttree to infer the TerL phylogeny from the multiple sequence alignment.

Use the script "create_itol_families_colors.py" to create an annotation file which you can use to decorate your tree. Once you have this, upload your treefile  to [iToL](https://itol.embl.de/). (explain a bit of iToL).
Then, in the "Datasets" section upload your annotation file.

**Q:** Can you explain what you see? Where do our (bins) terminases fall? Are there any long branches that seem out of place?


### Step 4. Refine the tree
Look at the multiple sequence alignment (MSA) with Aliview. Are there any sequences that seem out of place? If so, remove those sequences. Trim the MSA to remove positions with a high abundance of gaps using trimal and the -gt parameter.

Use this trimmed MSA to construct the TerL phylogeny by repeating steps 2 and 3. Does this improve the tree?

Look at your tree. Do you notice anything in particular that seems odd?


Go to the ICVT website and download the podoviridae report (to do: find link). How did they determine the taxonomy for this group?


**To do:**
- make conda environments (Jeroen)
- make script to gather terl proteins (step 1, Dani) - Done, script `gather_terminases_bins.py`
- add nucleotide-based protein annotation to day 3 (???) - Not necessary, we download reference terminases directly from ncbi
- make script for iTol decoration (Dani) - Done, script `create_itol_annots.py`
- add explanation of iTol (step3, Dani?)
- add link to podoviridae report (Jeroen)
{% include links.md %}
