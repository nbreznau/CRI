# Code

The .Rmd files in this folder contain the main analytical steps for the project. Sub-folder [`team_code`](..code/team_code) in the `team_code_R.Rmd` file merges together the submitted results from all teams. It also includes all of their anonymized source code.

Sub-folder [`data_prep`](..code/data_prep) cleans and merges the team results with subjective voting and participant survey results leading to the main analytical data:

1. `cri.csv` = model-level data, numerical values
2. `cri_team.csv` = team-level data
3. `cri_str.csv` = model-level data, string values

The knitted .html files in all folders list all code and results at once - can be viewed without R in any web browser.

The folder [`script`](../code/script/) contains two helper functions for plotting and standard error corrections.

## List of Command Code Files and their Functions

*All of the following are located in the main or sub-folders of the folder [`code`](../code/).*

|Filename|Location|Description|Output|
|---------|------|------------------------|----------------|
|[`001_CRI_Prep_Subj_Votes.Rmd`](../code/data_prep/001_CRI_Prep_Subj_Votes.Rmd)|[`data_prep`](..code/data_prep/)|Compile peer ranking of models|[`FigS4`](../results/FigS4.png)|
|[`002_CRI_Data_Prep.Rmd`](../code/data_prep/002_CRI_Data_Prep.Rmd)|[`data_prep`](..code/data_prep/)|Primary data cleaning and merging; measurement of researcher characteristics|[`TblS1`](../results/TblS1.xlsx);|
|[`003_CRI_Multiverse_Simulation.Rmd`](../code/data_prep/003_CRI_Multiverse_Simulation)|[`data_prep`](..code/data_prep/)|Sets up multiverse data| |
|[`01_CRI_Descriptives.Rmd`](../code/01_CRI_Descriptives.Rmd)|[`code`](../code/)|Descriptive statistics; codebook of 107 model design steps|[`FigS5`](../results/FigS5.png);[`FigS10`](../results/FigS10.png)|
|[`02_CRI_Common_Specifications.Rmd`](../code/02_CRI_Common_Specifications.Rmd)|[`code`](../code/)|identifying (dis)similarities across models|[`TblS4`](../results/TblS4.csv)



1. `01_CRI_Descriptives.Rmd` - final cleaning and descriptive analysis
2. `02_CRI_Common_Specifications.Rmd` - identifying and counting model specifications and dissimilarities
3. `03_CRI_Spec_Analysis.Rmd` - plotting specification curves
4. `04_CRI_Main_Analyses.Rmd` - main regression models aiming to explain variance within and between teams in both effects and subjective conclusions
5. `05_CRI_Main_Analyses_Variance_Function.Rmd` - variance function regressions that additionally aim to explain variation in variance by team, also contains plots of intercepts and variance against researcher characteristics
6. `06_CRI_Multiverse.Rmd` - uses a function to test all possible combinations of model specifications to explain variance
7. `07_CRI_DVspecific_Analyses-Rmd` - re-running main models separately by dependent variable (out of the 6 ISSP survey questions)