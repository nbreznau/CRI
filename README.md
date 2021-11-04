# The Hidden Universe of Data-Analysis

## Research Design and Analysis:

**Nate Breznau** </br>
**Eike Mark Rinke** </br>
**Alexander Wuttke** </br>
**Hung H.V. Nguyen** </br>

## Participant Researchers:

<details>
<summary><em>Show all participant co-researchers</em></summary>
Muna Adem, Jule Adriaans, Amalia Alvarez-Benjumea, Henrik Andersen, Daniel Auer, Flavio Azevedo, Oke Bahnsen, Dave Balzer, Paul C. Bauer, Gerrit Bauer, Markus Baumann, Sharon Baute, Verena Benoit, Julian Bernauer, Carl Berning, Anna Berthold, Felix S.Bethke, Thomas Biegert, Katharina Blinzler, Johannes N. Blumenberg, Licia Bobzien, Andrea Bohman, Thijs Bol, Amie Bostic, Zuzanna Brzozowska, Katharina Burgdorf, Kaspar Burger, Kathrin Busch, Juan Carlos-Castillo, Nathan Chan, Pablo Christmann, Roxanne Connelly, Christian Czymara, Elena Damian, Alejandro Ecker, Achim Edelmann, Maureen A.Eger, Simon Ellerbrock, Anna Forke, Andrea Forster, Chris Gaasendam, Konstantin Gavras, Vernon Gayle, Theresa Gessler, Timo Gnambs, Amélie Godefroidt, Alexander Greinert, Max Grömping, Martin Groß, Stefan Gruber, Tobias Gummer, Andreas Hadjar, Jan Paul Heisig, Sebastian Hellmeier, Stefanie Heyne, Magdalena Hirsch, Mikael Hjerm, Oshrat Hochman, Jan H. Höffler, Andreas Hövermann, Sophia Hunger, Christian Hunkler, NoraHuth, Zsofia Ignacz, LauraJacobs, Jannes Jacobsen, Bastian Jaeger, Sebastian Jungkunz, Nils Jungmann, Mathias Kauff, Manuel Kleinert, Julia Klinger, Jan-Philipp Kolb, Marta Kołczyńska, John Kuk, Katharina Kunißen, Dafina Kurti, Philipp Lersch, Lea-Maria Löbel, Philipp Lutscher, Matthias Mader, Joan Madia, Natalia Malancu, Luis Maldonado, Helge Marahrens, Nicole Martin, Paul Martinez, Jochen Mayerl, Oscar J. Mayorga, Patricia McManus, Kyle McWagner, Cecil Meeusen, Daniel Meierrieks, Jonathan Mellon, Friedolin Merhout, Samuel Merk, Daniel Meyer, Jonathan Mijs, Cristobal Moya, Marcel Neunhoeffer, Daniel Nüst, Olav Nygård, Fabian Ochsenfeld, Gunnar Otte, Anna Pechenkina, Christopher Prosser, Louis Raes, Kevin Ralston, Miguel Ramos, Frank Reichert, Leticia Rettore Micheli, Arne Roets, Jonathan Rogers, Guido Ropers, Robin Samuel, Gregor Sand, Constanza Sanhueza Petrarca, Ariela Schachter, Merlin Schaeffer, David Schieferdecker, Elmar Schlueter, Katja Schmidt, Regine Schmidt, Alexander Schmidt-Catran, Claudia Schmiedeberg, Jürgen Schneider, Martijn Schoonvelde, Julia Schulte-Cloos, Sandy Schumann, Reinhard Schunck, Jürgen Schupp, Julian Seuring, Henning Silber, Willem Sleegers, Nico Sonntag, Alexander Staudt, Nadia Steiber, Nils Steiner, Sebastian Sternberg, Dieter Stiers, Dragana Stojmenovska, Nora Storz, Erich Striessnig, Anne-Kathrin Stroppe, Janna Teltemann, Andrey Tibajev, Brian Tung, Giacomo Vagni, Jasper Van Assche, Metavan der Linden, Jolanda van der Noll, Arno Van Hootegem, Stefan Vogtenhuber, Bogdan Voicu, Fieke Wagemans, Nadja Wehl, Hannah Werner, Brenton Wiernik, Fabian Winter, Christof Wolf, Nan Zhang, Conrad Ziller, Björn Zakula, Stefan Zins and Tomasz Żółtak
</details>

## Abstract

This is the repository for preparation and analysis of data obtained from the *Crowdsourced Replication Initiative* ([Breznau, Rinke and Wuttke et al 2018](https://doi.org/10.31235/osf.io/6j9qb)) and used as the basis for the paper [Observing Many Researchers Using the Same Data and Hypothesis 
Reveals a Hidden Universe of Uncertainty](https://doi.org/10.31222/osf.io/cd5j9). 

Recently, many researchers independently testing the same hypothesis using the same data, reported tremendous variation in results across scientific disciplines. This variability must derive from differences in each research process. Therefore, observation of these differences should reduce the implied uncertainty. Through a controlled study involving 73 researchers/teams we tested this assumption. Taking all research steps as predictors explains at most 2.6% of total effect size variance, and 10% of the deviance in subjective conclusions. Expertise, prior beliefs and attitudes of researchers explain even less. Ultimately, each model was unique, and as a whole this study provides evidence of a vast universe of research design variability normally hidden from view in the presentation, consumption, and perhaps even creation of scientific results. 

## Workflow

The workflow is provided in a literate programming format, R Markdown notebooks (`.Rmd`), and split across a number of files as described below.
Next to the `.Rmd` files, there are also `.html` files of the same name. The latter contain HTML renderings of the notebooks with the created figures and tables, so that non-R users may view the workflow results more easily with any regular browser software.
For example, the file `01_CRI_Descriptives.Rmd` has a corresponding `01_CRI_Descriptives.html` file in the same folder for easy viewing without the need for running any R code.
Paths in the notebooks are handled with the `here` package and the paths are all relative to the projects root directory (where this README.md file is located).
You can open an interactive environment to explore and execute the analysis yourself based on [Binder](https://mybinder.org) ([Project Jupyter, 2018](https://doi.org/10.25080/Majora-4af1f417-011)):

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/nbreznau/CRI/HEAD?urlpath=rstudio)

The runtime environment created for the Binder uses an [MRAN](https://mran.microsoft.com/) snapshot of 2020-03-29 (see file `.binder/runtime.txt`) and installs all required R packages in the file `.binder/install.R`.

The workflow includes a [shinyapp](https://github.com/nbreznau/CRI/tree/master/shiny) that allows users to interact with results using specification curves. 

[![](shiny/Shiny-shinyapps.svg)](https://nate-breznau.shinyapps.io/shiny/)

### 1. Source Code Cleaning

We collected the code from 73 teams and cleaned it for public sharing. This involved qualitative identification of model specifications, ensuring replicability, extracting Average Marginal Effects (AMEs) and redacting any identifying features. The resulting codes are compiled by software type in the sub-folders of this project, ordered by team ID number (in folder [`team_code`](team_code/), and sub-folders: [`team_code_SPSS`](team_code/team_code_SPSS), [`team_code_Stata`](team_code/team_code_Stata), [`team_code_Mplus`](team_code/team_code_Mplus) and [`team_code_R`](team_code/team_code_R)). The code in the [`team_code_R`](team_code/team_code_R)) folder imports the results from all other codes to compile a final joined dataset of effect sizes and confidence interval measures.

Users should be aware that the main data files include team zero, which is the results and model specifications from the study of Brady and Finnigan [(2014)](https://doi.org/10.1177/0003122413513022) providing a launching point for the CRI; team zero is dropped from our main analyses but provides a point of comparison.

### 2. Data Pre-Preparation

Prior to our main analyses we import data from the Participant Survey including subjective voting on model quality, and the voting during the post-result deliberation. The code for these files (001-003) are contained in the folder [`data_prep`](code/data_prep/). It is not necessary to run these scripts as their output is already saved in the [`data`](data/) folder. 

### 3. Code

Our primary analyses and results are in the [`code`](code/) folder. Many of the results in this folder depend on data preparation done in the [`data_prep`](code/data_prep/) folder. 

#### List of Command Code Files and their Functions

*All of the following are located in the main or sub-folders of the folder [`code`](../master/code/).*

|Filename|Location|Description|Output|
|---------|------|------------------------|----------------|
|[`001_CRI_Prep_Subj_Votes.Rmd`](../master/code/data_prep/001_CRI_Prep_Subj_Votes.Rmd)|[`data_prep`](../master/code/data_prep/)|Compile peer ranking of models|[`FigS4`](/../master/results/FigS4.png)|
|[`002_CRI_Data_Prep.Rmd`](../master/code/data_prep/002_CRI_Data_Prep.Rmd)|[`data_prep`](../master/code/data_prep/)|Primary data cleaning and merging; measurement of researcher characteristics|[`TblS1`](../master/results/TblS1.xlsx);[`TblS3`](../master/results/TblS3.xlsx);[`FigS3`](../master/results/FigS3.png);[`FigS3_fit_stats`](../master/results/FigS3_fit.xlsx)|
|[`003_CRI_Multiverse_Simulation.Rmd`](../master/code/data_prep/003_CRI_Multiverse_Simulation.Rmd)|[`data_prep`](../master/code/data_prep/)|Sets up multiverse data| |
|[`01_CRI_Descriptives.Rmd`](../master/code/01_CRI_Descriptives.Rmd)|[`code`](../master/code/)|Descriptive statistics; codebook of 107 model design steps|[`FigS5`](../master/results/FigS5.png);[`FigS10`](../master/results/FigS10.png)|
|[`02_CRI_Common_Specifications.Rmd`](../master/code/02_CRI_Common_Specifications.Rmd)|[`code`](../master/code/)|identifying (dis)similarities across models|[`TblS4`](../master/results/TblS4.csv)|
|[`03_CRI_Spec_Analysis.Rmd`](../master/code/03_CRI_Spec_Analysis.Rmd)|[`code`](../master/code/)|Plotting specification curves|[`Fig1`](../master/results/Fig1.png);[`FigS6`](../master/results/FigS6.png);[`FigS7`](../master/results/FigS7.png);[`FigS8`](../master/results/FigS8.png);[`FigS9`](../master/results/FigS9.png)|
|[`04_CRI_Main_Analyses.Rmd`](../master/code/04_CRI_Main_Analyses.Rmd)|[`code`](../master/code/)|Main regression models explaining outcome variance within and between teams|[`Fig3`](../master/results/Fig3.png);[`TblS5`](../master/results/TblS5.xlsx);[`TblS6(see bottom of S5)`](../master/results/TblS5.xlsx);[`TblS7`](../master/results/TblS7.xlsx)|
|[`05_CRI_Main_Analyses_Variance_Function.Rmd`](../master/code/05_CRI_Main_Analyses_Variance_Function.Rmd)|[`code`](../master/code/)|Variance function regressions to explain variation in variance by team|[`Fig2`](../master/results/Fig2.png);[`FigS11`](../master/results/FigS11.png);[`FigS12`](../master/results/FigS12.png);[`FigS13`](../master/results/FigS12.png);[`TblS11`](../master/results/TblS11.csv)|
|[`06_CRI_Multiverse.Rmd`](../master/code/06_CRI_Multiverse.Rmd)|[`code`](../master/code/)|Function to test all possible combinations of submitted model specifications to explain variance|[`TblS8`](../master/results/TblS8.csv);[`TblS10`](../master/results/TblS10.xlsx)|
|[`07_CRI_DVspecific_Analyses.Rmd`](../master/code/07_CRI_DVspecific_Analyses.Rmd)|[`code`](../master/code/)|re-running main models separately by dependent variable (6 ISSP survey questions)|[`TblS9`](../master/results/TblS9.xlsx)|



### 4. Users may Run All Code

The following scripts run _all_ notebook files in order to check there are no code issues.

```r
source("all.R")
```

## Source Data

The data preparation code is in the sub-folder [`data_prep`](data_prep/). After the data preparation files, all data files ready for the data analysis are in the [`data`](data/) folder. There are numerous data files because the different participants' codes often require individual special files to run properly. The data files needed to reproduce all of the data analysis are:

| Filename | Description | Source |
| ----| -------|---|
| **MAIN FILES** | Used in Main Analyses 01-07 | |
| `cri.csv` | Main data analysis file, model & team-levels. All specifications coded by the PIs, team test results and researcher characteristics in numeric format | Worked up in [`CRI/data_prep`](CRI/code/data_prep) |
| `cri_str.csv` | A string-format only version of `cri.csv` | Worked up in [`CRI/data_prep`](CRI/code/data_prep) |
| `cri_team.csv` | A version of `cri_str.csv` aggregated team-level means (N = 89 because 16 teams conducted independent hypothesis tests by 'stock' and 'flow' immigration measures) | Worked up in [`CRI/data_prep`](CRI/code/data_prep) |
| `popdf_out.Rdata` |The peer review/deliberation scoring of model specifications as ranked by all participants; excepting non-response | Generated in sub-folder [`CRI/data_prep`](CRI/code/data_prep) | Participant survey and Kialo deliberation (see section "Kialo deliberation" in file [`data_prep/001_CRI_Prep_Subj_Votes.Rmd`](code/data_prep/001_CRI_Prep_Subj_Votes.Rmd)) |
|   |        |   |
| **SUB-FILES** | Used in Preparation of Data or App| |
| `Research Design Votes.xlsx` | Based on participant pre-registered designs, plus cursory review of all research designs. Not a fully accurate portrayal of final research designs because, (a) the broad range of specifications not reported in basic research designs and (b) the participant's often deviated from their proposed designs, if only slightly | This is a copy of the actual template (a Google Sheet) used to create the peer review voting system in the Participant Survey | 
| `cri_shiny.csv` | The model-level data needed to run the shiny app | Generated in [`CRI/data_prep`](CRI/code/data_prep) |
| `cri_shiny_team.csv` | The team-level data needed to run the shiny app | Generated in [`CRI/data_prep`](CRI/code/data_prep) |

### Important Documents

[Current Working Paper Version](https://doi.org/10.31222/osf.io/cd5j9)

[Current Supplementary Materials](https://osf.io/d4zqy/)

[Executive Report - describing the full study](https://doi.org/10.31235/osf.io/6j9qb)

### Start local Binder

Install [`repo2docker`](https://github.com/jupyterhub/repo2docker) and then run

```bash
repo2docker --editable .
```
