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
|[`001_CRI_Prep_Subj_Votes.Rmd`](../code/data_prep/001_CRI_Prep_Subj_Votes.Rmd)|[`data_prep`](../code/data_prep/)|Compile peer ranking of models|[`FigS4`](../results/FigS4.png)|
|[`002_CRI_Data_Prep.Rmd`](../code/data_prep/002_CRI_Data_Prep.Rmd)|[`data_prep`](../code/data_prep/)|Primary data cleaning and merging; measurement of researcher characteristics|[`TblS1`](../results/TblS1.xlsx);[`TblS3`](../results/TblS3.xlsx);[`FigS3`](../results/FigS3.png);[`FigS3_fit_stats`](../results/FigS3_fit.xlsx)|
|[`003_CRI_Multiverse_Simulation.Rmd`](../code/data_prep/003_CRI_Multiverse_Simulation)|[`data_prep`](../code/data_prep/)|Sets up multiverse data| |
|[`01_CRI_Descriptives.Rmd`](../code/01_CRI_Descriptives.Rmd)|[`code`](../code/)|Descriptive statistics; codebook of 107 model design steps|[`FigS5`](../results/FigS5.png);[`FigS10`](../results/FigS10.png)|
|[`02_CRI_Common_Specifications.Rmd`](../code/02_CRI_Common_Specifications.Rmd)|[`code`](../code/)|identifying (dis)similarities across models|[`TblS4`](../results/TblS4.csv)|
|[`03_CRI_Spec_Analysis.Rmd`](../code/03_CRI_Spec_Analysis.Rmd)|[`code`](../code/)|Plotting specification curves|[`Fig1`](../results/Fig1.png);[`FigS6`](../results/FigS6.png);[`FigS7`](../results/FigS7.png);[`FigS8`](../results/FigS8.png);[`FigS9`](../results/FigS9.png)|
|[`04_CRI_Main_Analyses.Rmd`](../code/04_Main_Analyses.Rmd)|[`code`](../code/)|Main regression models explaining outcome variance within and between teams|[`Fig3`](../results/Fig3.png);[`TblS5`](../results/TblS5.xlsx);[`TblS6`](../results/TblS5.xlsx);[`TblS7`](../results/TblS7.xlsx)|
|[`05_CRI_Main_Analyses_Variance_Function.Rmd`](../code/05_CRI_Main_Analyses_Variance_Function.Rmd)|[`code`](../code/)|Variance function regressions to explain variation in variance by team|[`Fig2`](../results/Fig2.png);[`FigS11`](../results/FigS11.png);[`FigS12`](../results/FigS12.png);[`FigS13`](../results/FigS12.png);[`TblS11`](../results/TblS11.csv)|
|[`06_CRI_Multiverse.Rmd`](../code/06_CRI_Multiverse.Rmd)|[`code`](../code/)|Function to test all possible combinations of submitted model specifications to explain variance|[`TblS8`](../results/TblS8.csv);[`TblS10`](../results/TblS10.xlsx)|
|[`07_CRI_DVspecific_Analyses.Rmd`](../code/07_CRI_DVspecific_Analyses.Rmd)|[`code`](../code/)|re-running main models separately by dependent variable (6 ISSP survey questions)|[`TblS9`](../results/TblS9.xlsx)|
