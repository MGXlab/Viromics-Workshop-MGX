---
title: "Setup and run VirSorter"
teaching: 10
exercises: 20
questions:
- "How do we install and run VirSorter?"
- "How is VirSorter different than the previous tools?" 
objectives:
- "Install and run VirSorter"
keypoints:
- "VirSorter is a homology-based tool."
- "Because Virsorter has to compare each sequence to a database, it is slower that many other tools."
---

The last virus identification tool, which we will run over lunch, is called VirSorter ([Roux et al. 2015](https://peerj.com/articles/985/)). VirSorter is different from the other tools in that it actually considers homology in predicting whether a contig belongs to a phage or a microbe. VirSorter distinguishes between "primary" and "secondary" metrics when deciding how to annotate a sequence. Primary metrics are the presence of viral hallmark genes an their homologs, and the enrichment of known viral genes. Secondary metrics include an enrichment in uncharacterized genes, depletion of PFAM-affiliated genes, and two metrics of genome structure.



> ## Challenge: Viral genome structure
> VirSorter uses two genome structure metrics to distinguish phage sequences from bacterial sequences. Can you think of viral genome structure metrics that could be useful for prediction?
>
>
> > ## Solution
> > VirFinder uses:
> > 1. an enrichment of short genes
> > 2. depletion in strand switch
> {: .solution}
{: .challenge}

To run VirSorter, first create the necessary environment from virsorter.yaml and activate it. Then, download virsorter into the day2/tools folder.
Note that the following code is in bash again.

~~~
# Install Virsorter
$ git clone https://github.com/simroux/VirSorter.git
$ cd VirSorter/Scripts
$ make clean
$ make

# Make symbolic link of executable scripts in the environment's bin
# It is important to use the absolute path and not the relative path to the Scripts folder
$ ln -s ~/JenaViromics2022/day2/tools/VirSorter/wrapper_phage_contigs_sorter_iPlant.pl ~/miniconda/envs/virsorter/bin
$ ln -s ~/JenaViromics2022/day2/tools/VirSorter/Scripts ~/miniconda/envs/virsorter/bin

~~~
{: .language-bash}

Finally, install metagene_annotator into the conda environment.

~~~
# Install metagene_annotator
$ conda install metagene_annotator -c bioconda
~~~
{: .language-bash}


Finally, run VirSorter. Note that VirSorter is very particular about its working directory. It is best if it doesn't exist beforehand (VirSorter will create it). If a run fails, then completely remove the working directory before you restart it.

~~~
# Run VirSorter
# Under the argument --data-dir put the link https://blahblah.com/virsorter-data
$ wrapper_phage_contigs_sorter_iPlant.pl -f ../../contigs_over_200.fasta --db 1 --wdir ../../results/virsorter --ncpu 1 --data-dir ./virsorter-data
~~~
{: .language-bash}


If your run fails because "Step 1 failed", then check the error file in ../../results/virsorter/logs/. If the error is "Can't locate Bio/Seq.pm in @inc (you may need to install the Bio::Seq module)...", then you need to copy a perl folder in the virsorter environment folder.

~~~
# Error fix for Can't locate Bio/Seq.pm in @inc
$ cd ~/miniconda/envs/virsorter/lib/
$ cp -r perl5/site_perl/5.22.0/Bio/ site_perl/5.26.2/x86_64-linux-thread-multi/
~~~
{: .language-bash}

Then try to run the command again. If you have more problems, let us know.
Guten Appetit! Eet smakkelijk! Have a good lunch!



{% include links.md %}
