---
title: "Gene sharing networks with Vcontact2"
teaching: 15
exercises: 15
questions:
- "For how many of the contigs can we assign a genus-level taxonomic annotation?"
- "Are there conflicts with the gene tree?"

objectives:
- "Run Vcontact2"
- "analyse the output with Cytoscape"

keypoints:
- ""

---

1. activate vcontact2 conda environment
2. run Vcontact2
3. open cytoscape, load the network file, add the gene to genome mapping.
4. Remove duplicate links and self loops.
5. Explore the data and explain what you see. You can colour the nodes based on different things, such as clustering status, viral cluster number, or a taxonomic rank such as genus. What do each of these terms indicate? Refer to the Vcontact2 manual or paper if necessary.
6. Can you locate the crassphages in this network?
7. How many contigs can be annotated with Vcontact2? At what taxonomic level?
6. Try to find the contigs you've annotated in the previous steps. Where are they in this network? Can you annotate more or fewer contigs/bins? Interpret your results.



**TO DO**
- make conda environment (jeroen)
- add links to manual & paper (jeroen)
- add terminal commands (jeroen)
- run vcontact on contigs or bins?
- check running time for bins (Jeroen)
- add description of how to open & navigate Cytoscape (manual sucks, Jeroen)
{% include links.md %}
