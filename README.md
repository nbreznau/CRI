# The Hidden Universe of Data-Analysis


### Research Design and Analysis:

**Nate Breznau**
<br>**Eike Mark Rinke**
<br>**Alexander Wuttke**
<br>**Hung H.V. Nguyen**

### Participant Researchers:
<details>
<<<<<<< HEAD
<summary>*Participant Co-Researchers*</summary>
Muna Adem, Jule Adriaans, Amalia Alvarez-Benjumea, Henrik Andersen, Daniel Auer, Flavio Azevedo, Oke Bahnsen, Dave Balzer, Paul C. Bauer, Gerrit Bauer, Markus Baumann, Sharon Baute, Verena Benoit, Julian Bernauer, Carl Berning, Anna Berthold, Felix S.Bethke, Thomas Biegert, Katharina Blinzler, Johannes N. Blumenberg, Licia Bobzien, Andrea Bohman, Thijs Bol, Amie Bostic, Zuzanna Brzozowska, Katharina Burgdorf, Kaspar Burger, Kathrin Busch, Juan Carlos-Castillo, Nathan Chan, Pablo Christmann, Roxanne Connelly, Christian Czymara, Elena Damian, Alejandro Ecker, Achim Edelmann, Maureen A.Eger, Simon Ellerbrock, Anna Forke, Andrea Forster, Chris Gaasendam, Konstantin Gavras, Vernon Gayle, Theresa Gessler, Timo Gnambs, Amélie Godefroidt, Alexander Greinert, Max Grömping, Martin Groß, Stefan Gruber, Tobias Gummer, Andreas Hadjar, Jan Paul Heisig, Sebastian Hellmeier, Stefanie Heyne, Magdalena Hirsch, Mikael Hjerm, Oshrat Hochman, Jan H. Höffler, Andreas Hövermann, Sophia Hunger, Christian Hunkler, NoraHuth, Zsofia Ignacz, LauraJacobs, Jannes Jacobsen, Bastian Jaeger, Sebastian Jungkunz, Nils Jungmann, Mathias Kauff, ManuelKleinert, Julia Klinger, Jan-Philipp Kolb, Marta Kołczyńska, John Kuk, Katharina Kunißen, Dafina Kurti, Philipp Lersch, Lea-Maria Löbel, Philipp Lutscher, Matthias Mader, Joan Madia, Natalia Malancu, Luis Maldonado, Helge Marahrens, Nicole Martin, Paul Martinez, Jochen Mayerl, Oscar J. Mayorga, Patricia McManus, Kyle McWagner, Cecil Meeusen, Daniel Meierrieks, Jonathan Mellon, Friedolin Merhout, Samuel Merk, Daniel Meyer, Jonathan Mijs, Cristobal Moya, Marcel Neunhoeffer, Daniel Nüst, Olav Nygård, Fabian Ochsenfeld, Gunnar Otte, Anna Pechenkina, Christopher Prosser, Louis Raes, Kevin Ralston, Miguel Ramos, Frank Reichert, Leticia Rettore Micheli, Arne Roets, Jonathan Rogers, Guido Ropers, Robin Samuel, Gregor Sand, Constanza Sanhueza Petrarca, Ariela Schachter, Merlin Schaeffer, David Schieferdecker, Elmar Schlueter, Katja Schmidt, Regine Schmidt, Alexander Schmidt-Catran, Claudia Schmiedeberg, Jürgen Schneider, Martijn Schoonvelde, Julia Schulte-Cloos, Sandy Schumann, Reinhard Schunck, Jürgen Schupp, Julian Seuring, Henning Silber, Willem Sleegers, Nico Sonntag, Alexander Staudt, Nadia Steiber, Nils Steiner, Sebastian Sternberg, Dieter Stiers, Dragana Stojmenovska, Nora Storz, Erich Striessnig, Anne-Kathrin Stroppe, Janna Teltemann, Andrey Tibajev, Brian Tung, Giacomo Vagni, Jasper Van Assche, Metavan der Linden, Jolanda van der Noll, Arno Van Hootegem, Stefan Vogtenhuber, Bogdan Voicu, Fieke Wagemans, Nadja Wehl, Hannah Werner, Brenton Wiernik, Fabian Winter, Christof Wolf, Nan Zhang, Conrad Ziller, Björn Zakula, Stefan Zins and Tomasz Żółtak
=======
</details>


### Abstract

This is the repository for preparation and analysis of data obtained from the *Crowdsourced Replication Initiative* [(Breznau, Rinke and Wuttke et al 2018)](https://osf.io/preprints/socarxiv/6j9qb/) used to investigate variability in research results across researchers and their model specifications. Results from 162 researchers in 73 teams testing the same hypothesis with the same data reveals a universe of unique possibilities in the process of data analysis. Contrary to our expectations, variance in results and subjective conclusions are little explained by model specifications and even less by characteristics of the researchers in each team. Although there were common specifications across many teams regarding sample selection, variance components, estimator and additional independent variables, each of the 1,261 test models submitted by the teams was ultimately a unique combination of specifications. As such, the extreme variation in substantive research outcomes and researcher conclusions suggests that researcher-specific if not model-specific idiosyncratic variation is an important source of unreliability in science. Moreover, variance in the decisions made during the data analytic process cannot be explained much by the characteristics of the researchers, such as their methodological and topical expertise, or prior beliefs. These findings highlight the often underappreciated complexity and ambiguity inherent in the process of data analysis in science. They also demonstrate that recent calls for running countless alternative model specifications may not bring scientists any closer to reliability because the noise of idiosyncratic research variability remains. This adds to ongoing debates about the replicability and credibility of social science research. It thus raises far-ranging questions about the conditions for, and indeed possibility of, reaching scientific or meta-scientific consensus about substantive social questions based on available data alone.

### Workflow

In addition to providing the raw R code in Rmd (markdown) files. We also knit each Rmd file into an html document so that non-R users may view the workflow. Therefore, each markdown file has a corresponding html file that can be opened by any browser software. For example, the file `01_CRI_Descriptives.Rmd` has a corresponding `01_CRI_Descriptives.html` file in the same folder for easy viewing (without the need for R).

The main data files include team zero, which is the results and model specificaitons from the study of Brady and Finnigan [(2014)](https://doi.org/10.1177/0003122413513022) providing a launching point for the CRI; team zero is dropped from our main analyses but provides a point of comparison.

#### 1. Source Code Cleaning

We collected the code from 73 teams and cleaned it for public sharing. This involved qualitative identification of model specifications, ensuring replicability, extracting Average Marginal Effects (AMEs) and redacting any identifying features. The resulting code are compiled by software type in the sub-folders of this project, orderd by team ID number (in folder **team_code**, and sub-folders: *team_code_SPSS*,*team_code_Stata*,*team_code_Mplus* and *team_code_R*). The code in the *team_code_R* folder imports the results from all other codes to compile a final dataset of effect sizes and confidence interval measures. 

#### 2. Data Pre-Preparation

Prior to our main analyses we import data from the Participant Survey including subjective voting on model quality, and the voting during the post-result deliberation. The code for these files are contained in the folder **data_prep**. It is not necessary to run these as their output is already saved in the **data** folder. In the **data_prep** folder are three command files:

1. `001_CRI_Prep_Subj_Votes.Rmd` - prepares the subjective voting on the quality of models
2. `002_CRI_Data_Prep.Rmd` - cleans up the variables into workable formats, prepares shiny app data, provides correlations, and runs a measurement model to estimate researcher characteristics
3. `003_CRI_Multiverse_Simulation` - sets up data to analyze how much variance we should expect to explain via model specifications

#### 3. Workflow

Our primary analyses and result out put are in the **code** folder. It contains:

1. `01_CRI_Descriptives.Rmd` - final cleaning and descriptive analysis
2. `02_CRI_Common_Specifications.Rmd` - identifying and counting model specifications and dissimilarities
3. `03_CRI_Spec_Analysis.Rmd` - plotting specification curves
4. `04_CRI_Main_Analyses.Rmd` - main regression models aiming to explain variance within and between teams in both effects and subjective conclusions
5. `05_CRI_Main_Analyses_Variance_Function.Rmd` - variance function regressions that additionally aim to explain variation in variance by team, also contains plots of intercepts and variance against reseracher characteristics
6. `06_CRI_Multiverse.Rmd` - uses a function to test all possible combinations of model specifications to explain variance
7. `07_CRI_DVspecific_Analyses` - re-running main models separately by dependent variable (out of hte 6 ISSP survey questions)

### Source Data

The data preparation code is in the sub-folder CRI/data_prep. After the data prep files, all necessary data analysis files are in the CRI/data folder. These files are many because participants' code often requires special files to run properly. The data files needed to reproduce the data anlysis. These files are:

| Filename | Description | Source |
| ----| -------|---|
| ### MAIN FILES | Used in Main Analyses 01-07 | |
| ***cri.csv*** | Main data analysis file, model & team-levels. All specifications coded by the PIs, team test results and researcher characteristics in numeric format | Worked up in *CRI/data_prep* |
| ***cri_str.csv*** | A string-format only version of *cri_str.csv* | Worked up in *CRI/data_prep* |
| ***cri_team.csv*** | A version of *cri_str.csv* aggregated team-level means (N = 89 because 16 teams conducted independent hypothesis tests by 'stock' and 'flow' immigration measures) | Worked up in **CRI/data_prep** |
| ***popdf_out.Rdata*** |The peer review/deliberation scoring of model specifications as ranked by all participants; excepting non-response|Generated in sub-folder *CRI/data_prep* | Participant survey and Kialo deliberation |
|   |        |   |
| ### SUB-FILES | Used in Preparation of Data or App| |
| ***Research Design Votes.xlsx*** | Based on participant pre-registered designs, plus cursory review of all research designs. Not a fully accurate portrayal of final research designs because, (a) the broad range of specifications not reported in basic research designs and (b) the participant's often deviated from their proposed designs, if only slightly | This is a copy of the actual template (a Google Sheet) used to create the peer review voting system in the Participant Survey | 
| ***cri_shiny.csv***| The model-level data needed to run the shiny app | Generated in *CRI/data_prep* |
| ***cri_shiny_team.csv***| The team-level data needed to run the shiny app | Generated in *CRI/data_prep* |

### Important Documents

[Current Working Paper Version](https://drive.google.com/file/d/11Y3ebvEKjbdyQ9TDtM4uoJYcHeRgYXbx/view?usp=sharing)

[Current Supplementary Materials](https://drive.google.com/file/d/1COLKFvQlRGDd25cxAnHLNReAiiDNBbj2/view?usp=sharing)

[Executive Report - describing the full study](https://osf.io/preprints/socarxiv/6j9qb/)




