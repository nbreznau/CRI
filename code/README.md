# Code

The .Rmd files in this folder contain the main analytical steps for the project. The datasets analyzed in this folder were produced in the sub-folder [`team_code`](../team_code) in the  `team_code_R.Rmd` file and then in the project sub-folder [`data_prep`](../data_prep). The knitted .html files in this folder list all code and results at once - can be viewed without R in any web browser.

The datasets analyzed:

1. `cri.csv` = model-level data, numerical values
2. `cri_team.csv` = team-level data
3. `cri_str.csv` = model-level data, string values

## List of Command Code Files and their Functions

|Filename|Location|Description|Output|
|---------|------|------------------------|----------------|
|001_CRI_Prep_Subj_Votes.Rmd|[`data_prep`](../data_prep)|Compile peer ranking of models|FigS4|
|01_CRI_Descriptives.Rmd|[`code`](../code)|Descriptive statistics; codebook of 107 model design steps|[`FigS5.png`](../results/FigS5.png);FigS10.png|


1. `01_CRI_Descriptives.Rmd` - final cleaning and descriptive analysis
2. `02_CRI_Common_Specifications.Rmd` - identifying and counting model specifications and dissimilarities
3. `03_CRI_Spec_Analysis.Rmd` - plotting specification curves
4. `04_CRI_Main_Analyses.Rmd` - main regression models aiming to explain variance within and between teams in both effects and subjective conclusions
5. `05_CRI_Main_Analyses_Variance_Function.Rmd` - variance function regressions that additionally aim to explain variation in variance by team, also contains plots of intercepts and variance against researcher characteristics
6. `06_CRI_Multiverse.Rmd` - uses a function to test all possible combinations of model specifications to explain variance
7. `07_CRI_DVspecific_Analyses-Rmd` - re-running main models separately by dependent variable (out of the 6 ISSP survey questions)