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
### Add to day 3:
This are proteins coming from a reference set that we will use tomorrow. Add them to your already predicted proteins and annotate them with a function...

### Step 0. Activate conda environment
```
$ conda activate day4_phyl
```

### Step 1. Gather terminase proteins.
Take the proteins that were annotated as "terminase large subunit" yesterday. Add the crassvirales terminases from `crassvirales_terl.faa`. (maybe add script to do this).

### Step 2. Alignment
Align the sequences using Mafft. Check the [Mafft manual](https://mafft.cbrc.jp/alignment/software/algorithms/algorithms.html).
**Q:** Which method do you think best fits our data? Can you use one of the most accurate methods?

### Step 3. Make the tree
Use fasttree to construct the TerL phylogeny from the multiple sequence alignment (MSA).

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
- make script to gather terl proteins (step 1, Dani)
- add nucleotide-based protein annotation to day 3 (???)
- make script for iTol decoration (Dani)
- add explanation of iTol (step3, Dani?)
- add link to podoviridae report (Jeroen)
{% include links.md %}
