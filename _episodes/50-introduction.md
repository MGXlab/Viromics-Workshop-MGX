---
start: true
title: "Track alpha and beta diversity dynamics of viral/microbial communities"
teaching: 120
exercises: 0
questions:
- "What is compositional data?"
- "How to do compositional data analysis?"
- "What is Hill Number?"
objectives:
- "Compositionality"
- "Hill number of alpha divesity"
keypoints:
- "Next Generation Sequencing data is compositional and should be analyzed using compositional data analysis methods"
- "Hill number is linear and more intuitive than original alpha diversity measures"
---
## Basic ecology

#### Watching:
- Alpha Diversity [Microbiome Discovery 7: Alpha Diversity](https://youtu.be/9ZvoR89HYP8)
- Beta Diversity [Microbiome Discovery 8: Beta Diversity](https://youtu.be/lcbp6EecDg4)

## Compositional data and analysis

Compositionality
- Definition: a D-part composition is positive real vector of D components describing the parts of some whole. It only carries relative information between the parts.
- Three principles of compositional data (analysis)
  - Scale invariance
  - Permutation invariance
  - Subcompositional coherence  
 
#### Reading:
- Microbiome Datasets Are Compositional: And This Is Not Optional ([Gregory B. Gloor et al fmicb 2017](https://www.frontiersin.org/articles/10.3389/fmicb.2017.02224/full))
- A field guide for the compositional analysis of any-omics data ([Thomas P Quinn et al GigaScience 2019](https://pubmed.ncbi.nlm.nih.gov/31544212/))
- Exploring MGS Bias ([Ryan Moore](https://www.tenderisthebyte.com/apps/mgs_bias))

#### Watching:
- Compositionality [Microbiome Discovery 19: Compositionality](https://youtu.be/X60nFYpLWRs) 
- Compositional data analysis [Compositional Data Analysis Approaches to Improve Microbiome Studies: from Collection to Conclusions](https://youtu.be/j1IbfQrT2Cs) 

## Alpha diversity

#### Reading:
- Estimating diversity in networked ecological communities [Amy D Willis et al Biostatistics 2022](https://academic.oup.com/biostatistics/article/23/1/207/5841114?login=true)
- Hill number as a bacterial diversity measure framework with high-throughput sequence data [Sanghoon Kang et al nature 2016](https://www.nature.com/articles/srep38263) 

## Differential abundance and correlations

#### Reading:
- Understanding sequencing data as compositions: an outlook and review [Thomas P Quinn et al bioinformatics 2018](https://academic.oup.com/bioinformatics/article/34/16/2870/4956011)
- propr: An R-package for Identifying Proportionally Abundant Features Using Compositional Data Analysiss [Thomas P. Quinn et al Biostatistics 2022](https://www.nature.com/articles/s41598-017-16520-0)
{% include links.md %}

## Acknowledgement
The content and material of the course today is heavily based on the MCAW-EPSCoR Microbial Community Analysis Workshop by Viral Ecology and Informatics Lab in the University of Delaware.

