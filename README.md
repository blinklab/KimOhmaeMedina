# KimOhmaeMedina

KimOhmaeMedina is a repository containing the data and analysis code supporting the findings of Kim, Ohmae, & Medina (2019 initial submission, Nature Neuroscience).


## What programs can you use to access the data in this repository?

- Matlab (scripts developed and tested in Matlab 2018b)
  - Can be used to access all quantitative behavioral and electrophysiological data used for this publication. Quantitative data is replicated in a format more amenable for use in R to take advantage of R's statistical packages, but you could access everything with Matlab.
  - Some custom scripts for plotting and analysis are included in this repository. To avoid errors, make sure to run any of the provided Matlab scripts from this directory or to add this repository to your path.
- R (scripts developed and tested in R version 3.6.0)
  - If you are new to R, you may prefer to look at/run these scripts in RStudio (an open source IDE for R, which could be found [here](https://rstudio.com/) on 9.26/2020)
  - Can be used to access quantitative behavioral and electrophysiological data that were run through pairwise tests or nparLD tests in the manuscript. These files are stored in .csv format.
  - Can be used to access the scripts written to perform the statistical analyses. The particular scripts here require installation of the following publicly available packages:
    - nparLD
    - coin
    - effsize
    - nlme
    - lsmeans
    - tidyverse
    - ggpubr
    - rstatix
    - car
    - multcompView
    - sjstats


## How this repository is organized

Data and the corresponding analysis code can be found in the main folder of this repository. Each script and data file is named according to the figure of the paper that it supports. The format of the data is described in the appropriate Matlab and R scripts. Methodoligical details can be found in the Online Methods section of the paper.


## Questions, Comments, and Concerns

Please reach out to the corresponding author (Javier F. Medina, PhD) at jfmedina@bcm.edu with any questions, comments, or concerns.