---
start: True
title: "Setup and run DeepVirFinder"
teaching: 15
exercises: 15
questions: 
- "Why do we use different environments for different tools?"
- "How do we run DeepVirFinder?" 
objectives:
- "Create a conda environment from a .yaml file"
- "Download DeepVirFinder and start a run"
keypoints:
- "Different tools have different environments. Keeping them in separate environments makes runs reproducible and prevents a variety of problems."
- "We are running DeepVirFinder during the lecture, because the run takes ~50 minutes."
---

Today you will use different virus discovery tools and do a basic comparison of their performance on the assemblies that you created yesterday. To do this, we will heavily rely on conda to keep our computer environments clean and functional ([Anaconda on Wikipedia](https://anaconda.org/)). Conda enables us to create multiple separate environments on our computer, where different programs can be installed without affecting our global virtual environment. 

**Why is this useful?** Most of the time, tools rely on other programs to be able to run correctly - these programs are the tool's dependencies. For example: you cannot run a tool that is coded in Python 3 on a machine that only has Python 2 installed (or no Python at all!). 

**So, why not just install everything into one big global environment that can run everything?** We will focus on two reasons: compatibility and findability. The issue with findability is that sometimes, a tool will not "find" its dependency even though it is installed. To reuse the Python example: If you try to run a tool that requires Python 2, but your global environment's default Python version is Python 3.7, then the tool will not run properly, even if Python 2 is technically installed. In that case, you would have to manually change the Python version anytime you decide to run a different tool, which is tedious and messy. The issue with compatibility is that some tools will just plain uninstall versions of programs or packages that are incompatible with them, and then reinstall the versions that work for them, thereby "breaking" another tool (this might or might not have happened during the preparation of this course ;) ). To summarize: keeping tools in separate conda environments will can save you a lot of pain.

First, download the conda environments for today from [here](https://github.com/MGXlab/Viromics-Workshop-MGX/raw/gh-pages/data/day_2/day2_envs.tar.gz) and use the file *deepvir.yaml* to create the conda environment for DeepVirFinder ([Ren et al. 2020](https://link.springer.com/article/10.1007/s40484-019-0187-4); [DeepVirFinder Github](https://github.com/jessieren/DeepVirFinder)).

~~~
# create the directory for today's tools and results
$ mkdir tools
$ mkdir results

# download and unzip the conda environemnts
$ wget https://github.com/MGXlab/Viromics-Workshop-MGX/raw/gh-pages/data/day_2/day2_envs.tar.gz
$ tar zxvf day2_envs.tar.gz
$ cd envs

# create the conda environment dvf for DeepVirFinder from deepvir.yaml
$ conda env create -f deepvir.yaml
~~~
{: .language-bash}


This will take a couple of minutes. In the meantime, you can open another terminal window and download the DeepVirFinder github repository that contains the scripts.

~~~
# download the DeepVirFinder Github Repository
$ cd ~/ViromicsCourse/day2/tools/
$ git clone https://github.com/jessieren/DeepVirFinder

# Copy yesterday's contigs from the results
$ cp /path/to/yesterdays/scaffolds.fasta ~/ViromicsCourse/day2/
~~~
{: .language-bash}

The file *dvf.py* inside the folder tools/DeepVirFinder/ contains the code to run DeepVirFinder. Once the conda environment has been successfully created, run DeepVirFinder on the contigs you have assembled yesterday (use the scaffolds from the cross-assembly, not the pooled separate assemblies). We want to focus on the most reliable contigs and will therefore only input contigs that are over 300 nucleotides in length (DeepVirFinder actually has an option that makes it pass sequences below a certain length, but some of the other tools do not have that option).

~~~
# Find out until which line you have to truncate the file to only include contigs longer than 300nt
$ less -N scaffolds.fasta
# While reading the file with less, you can look for a pattern by typing
/_length_300_

# Make truncated contig file (replace xxx with the last line number you want to include - the sequence of the last contig longer than 200nt)
$ head -n xxx ~/ViromicsCourse/day2/scaffolds.fasta > ~/ViromicsCourse/day2/scaffolds_over_300.fasta

# Activate the deepvir conda environment
$ conda activate dvf

# Run DeepVirFinder
(dvf)$ python3 dvf.py -i ~/ViromicsCourse/day2/scaffolds_over_300.fasta -o ~/ViromicsCourse/day2/results/
~~~
{: .language-bash}


DeepVirFinder will now start writing lines containing which part of the file it is processing.

While DeepVirFinder is running, listen to the lecture.


{% include links.md %}
