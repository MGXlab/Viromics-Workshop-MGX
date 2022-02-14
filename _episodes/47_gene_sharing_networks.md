---
title: "Gene sharing networks with Vcontact2"
teaching: 15
exercises: 15
questions:
- "How do we run Vcontact2 and Cytoscape?"
- "What are the signals Vcontact2 uses to infer taxonomy?"
- "To how many contigs can we assign a genus-level taxonomic annotation?"
- "How does this compare to other tools?"

objectives:
- "Run Vcontact2"
- "analyse the output with Cytoscape"

keypoints:
- ""

---
### 0. install Vcontact2 & cytoscape.
The solution to get Vcontact2 running is:
```
$ conda create --name vContact2 python=3.7
$ conda activate vContact2
# pandas need to be 0.25.3 - https://bitbucket.org/MAVERICLab/vcontact2/issues/17/error-vcontact2-error-in-contig-clustering
$ mamba install pandas=0.25.3
$ mamba install vcontact2
$ mamba install -y mcl blast diamond
# Downgrade Numpy
$ mamba install numpy=1.19.5
```

(add how to install cytoscape)

### 1. activate the vcontact2 conda environment
### 2. run the `code/day4/vcontact2.sh` script to generate the required input files for Vcontact2.

### 3. run Vcontact2 on the protein data.
Check the [Vcontact2 manual](https://bitbucket.org/MAVERICLab/vcontact2/wiki/Home) to find out how to do this.
> ## Task: run Vcontact2
> Check the [Vcontact2 manual](https://bitbucket.org/MAVERICLab/vcontact2/wiki/Home) to find out how to do this.
> > ## solution
> > vcontact2 --raw-proteins myproteins.faa --rel-mode 'Diamond' --proteins-fp gene-to-genome.csv --db 'ProkaryoticViralRefSeq94-Merged' --pcs-mode MCL --vcs-mode ClusterONE --c1-bin LOCATION_OF_CLUSTER_ONE --output-dir OUT_DIR
> {: .solution}
{: .challenge}


### 4. open cytoscape, load the network file, add the gene to genome mapping.  
Note: Possibly Cytoscape (in cytoscape conda env) is not working if you start it with `. cytoscape.sh:`
```
Error occurred during initialization of boot layer
java.lang.module.FindException: Module javafx.web not found
```
Running it by directly calling `/home/jeroen/miniconda3/envs/cytoscape/share/cytoscape-3.9.1-0/Cytoscape` does work.

### 5. Remove duplicate links and self loops.
Check steps 5 and later from this [walkthrough](https://www.protocols.io/view/applying-vcontact-to-viral-sequences-and-visualizi-x5xfq7n) to see how to do this

### 6. Explore the data and explain what you see. You can colour the nodes based on different things, such as clustering status, viral cluster number, or a taxonomic rank such as genus. What do each of these terms indicate? Refer to the Vcontact2 manual (under "VC statuses") or paper if necessary.

### 7. Can you locate the crassphages in this network?

### 8. How many contigs can be annotated with Vcontact2? At what taxonomic level?

### 9. Try to find the contigs you've annotated in the previous steps. Where are they in this network? Can you annotate more or fewer contigs/bins? Interpret your results.



**TO DO**
- make conda environment (jeroen)
- should we run vcontact on contigs or bins?
- check running time for bins (Jeroen)
- Cytoscape interface isn't the most intuitive, I could write a short guide w/ figures on how to color nodes etc. 
{% include links.md %}
