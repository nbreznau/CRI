library("rmarkdown")
library("here")

# Workflow step: 2. Data Pre-Preparation
rmarkdown::render(here::here("data_prep/001_CRI_Prep_Subj_Votes.Rmd"))
rmarkdown::render(here::here("data_prep/002_CRI_Data_Prep.Rmd"))
rmarkdown::render(here::here("data_prep/003_CRI_Multiverse_Simulation.Rmd"))

rmarkdown::render(here::here("code/01_CRI_Descriptives.Rmd"))
rmarkdown::render(here::here("code/02_CRI_Common_Specifications.Rmd"))
rmarkdown::render(here::here("code/03_CRI_Spec_Analysis.Rmd"))
rmarkdown::render(here::here("code/04_CRI_Main_Analyses.Rmd"))
rmarkdown::render(here::here("code/05_CRI_Main_Analyses_Variance_Function.Rmd"))
rmarkdown::render(here::here("code/06_CRI_Multiverse.Rmd"))
rmarkdown::render(here::here("code/07_CRI_DVspecific_Analyses.Rmd"))
