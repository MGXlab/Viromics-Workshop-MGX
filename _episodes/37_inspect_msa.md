---
title: "Inspecting the MSAs"
teaching: 10
exercises: 30
questions:
- ""
objectives:
- ""
keypoints:

---

### Quality of the multiple sequence alignment

If the MSAs we base our search on are of poor quality we cannot expect to find
matches when querying the PHROG database.

> ## MSA quality
> - __Think of what factors will influence the quality of our MSAs__
{: .challenge}

For a small set of proteins we can manually inspect the MSAs, however, for thousands of proteins this will take too long. Hence I used [MstatX](https://github.com/gcollet/MstatX) to automatically assess the quality of the MSAs.

Among one of the factors that might influence the quality of our MSAs is our clustering using mmseqs2 - the input for `mafft`. Specfically the parameters we chose, like the sensitivity (`-s`), and also the default values for identity (`--min-seq-id`) and coverage(`-c`). Ideally we would try different values and carefully read the manual on how to choose the most suitable parameters (e.g. [here](https://github.com/soedinglab/mmseqs2/wiki#how-to-set-the-right-alignment-coverage-to-cluster) for the coverage). For now I ran MstatX on all the MSAs from the other step. You can see the distribution here:

![Image]({{ page.root }}/fig/rick2.png)

You can get the MSA for the highest entropy MSA [here](https://github.com/rickbeeloo/day3-data/blob/main/101471_heighest.fasta) and the [lowest](https://github.com/rickbeeloo/day3-data/blob/main/131523_lowest.fasta) entropy MSA here. Install Jalview from [here](https://www.jalview.org/) and visualize the
alignments.

> ## Entropy values
> - __In Jalview, can you explain the high and low entropy values?__
> - __Do you think high, middle or low entropy would be the best to do a model search?__
{: .challenge}


{% include links.md %}
