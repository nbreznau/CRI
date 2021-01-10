# The Reliability of Scientific Data-Analysis


### Research Design and Data Analysis

**Nate Breznau**
<br>**Eike Mark Rinke**
<br>**Alexander Wuttke**
<br>**Hung H.V. Nguyen**

<details>
<summary>*Participant Co-Researchers*</summary>
Muna Adem, Jule Adriaans, Amalia Alvarez-Benjumea, Henrik Andersen, Daniel Auer, Flavio Azevedo, Oke Bahnsen, Dave Balzer, Paul C. Bauer, Gerrit Bauer, Markus Baumann, Sharon Baute, Verena Benoit, Julian Bernauer, Carl Berning, Anna Berthold, Felix S.Bethke, ThomasBiegert, KatharinaBlinzler, Johannes N. Blumenberg, Licia Bobzien, Andrea Bohman, Thijs Bol, AmieBostic, Zuzanna Brzozowska, Katharina Burgdorf, Kaspar Burger, Kathrin Busch, Juan Carlos-Castillo, Nathan Chan, Pablo Christmann, Roxanne Connelly, Christian Czymara, Elena Damian, Alejandro Ecker, Achim Edelmann, Maureen A.Eger, Simon Ellerbrock, Anna Forke, Andrea Forster, Chris Gaasendam, Konstantin Gavras, Vernon Gayle, Theresa Gessler, Timo Gnambs, Amélie Godefroidt, Alexander Greinert, Max Grömping, Martin Groß, Stefan Gruber, Tobias Gummer, Andreas Hadjar, Jan Paul Heisig, Sebastian Hellmeier, Stefanie Heyne, Magdalena Hirsch, Mikael Hjerm, Oshrat Hochman, Jan H. Höffler, Andreas Hövermann, Sophia Hunger, Christian Hunkler, NoraHuth, Zsofia Ignacz, LauraJacobs, Jannes Jacobsen, Bastian Jaeger, Sebastian Jungkunz, Nils Jungmann, Mathias Kauff, ManuelKleinert, Julia Klinger, Jan-Philipp Kolb, Marta Kołczyńska, John Kuk, Katharina Kunißen, Dafina Kurti, Philipp Lersch, Lea-Maria Löbel, Philipp Lutscher, Matthias Mader, Joan Madia, Natalia Malancu, Luis Maldonado, Helge Marahrens, Nicole Martin, Paul Martinez, Jochen Mayerl, Oscar J. Mayorga, Patricia McManus, Kyle McWagner, Cecil Meeusen, Daniel Meierrieks, Jonathan Mellon, Friedolin Merhout, Samuel Merk, Daniel Meyer, Jonathan Mijs, Cristobal Moya, Marcel Neunhoeffer, Daniel Nüst, Olav Nygård, Fabian Ochsenfeld, Gunnar Otte, Anna Pechenkina, Christopher Prosser, Louis Raes, Kevin Ralston, Miguel Ramos, Frank Reichert, Leticia Rettore Micheli, Arne Roets, Jonathan Rogers, Guido Ropers, Robin Samuel, Gregor Sand, Constanza Sanhueza Petrarca, Ariela Schachter, Merlin Schaeffer, David Schieferdecker, Elmar Schlueter, Katja Schmidt, Regine Schmidt, Alexander Schmidt-Catran, Claudia Schmiedeberg, Jürgen Schneider, Martijn Schoonvelde, Julia Schulte-Cloos, Sandy Schumann, Reinhard Schunck, Jürgen Schupp, Julian Seuring, Henning Silber, Willem Sleegers, Nico Sonntag, Alexander Staudt, Nadia Steiber, Nils Steiner, Sebastian Sternberg, Dieter Stiers, Dragana Stojmenovska, Nora Storz, Erich Striessnig, Anne-Kathrin Stroppe, Janna Teltemann, Andrey Tibajev, Brian Tung, Giacomo Vagni, Jasper Van Assche, Metavan der Linden, Jolanda van der Noll, Arno Van Hootegem, Stefan Vogtenhuber, Bogdan Voicu, Fieke Wagemans, Nadja Wehl, Hannah Werner, Brenton Wiernik, Fabian Winter, Christof Wolf, Nan Zhang, Conrad Ziller, Björn Zakula, Stefan Zins and Tomasz Żółtak
</details>


### Abstract

This R project Git presents the workflow for data obtained from the Crowdsourced Replication Initiative [Breznau, Rinke and Wuttke et al 2018](https://osf.io/preprints/socarxiv/6j9qb/) used to investigate variability in research results across researchers and their model specifications. Calls on a 'reliability crisis' in science suggest that researchers fail to produce consistent results, in particular to replicate previous studies, because of systematic bias. This bias comes in myriad formats, p-hacking, publication bias, unethical practices, etc. In this research we investigate how if there are sources of bias in idiosyncratic characteristics of researchers or decisions taken during the data-analysis process. We attempted to remove as many factors of systematic bias as possible to be able to observe researchers conducting real-world research and to test the same hypothesis with the same data. We conlcude that idioisyncratic bias found in a hidden universe of data analysis should be taken seriously in addition to questionable reserach practices stemming from structural biases as both threaten scientific reliability.

### Workflow

#### 1. Source Code Cleaning

We collected the code from 73 teams and cleaned it for public sharing. This involved qualitative identification of model specifications, ensuring replicability, extracting Average Marginal Effects (AMEs) and redacting any identifying features. The resulting code are compiled by software type in the sub-folders of this project, orderd by team ID number (in sub-folder **team_code**, and sub-folders: *team_code_SPSS*,*team_code_Stata*,*team_code_Mplus* and *team_code_R*). The code in the *team_code_R* folder imports the results from all other codes to compile a final dataset of AMEs and confidence interval measures. 

#### 2. Data Pre-Preparation

Prior to our main analyses we import data from the Participant Survey including subjective voting on model quality, and the voting during the post-result deliberation on Kialo. The code for these files are contained in the folder *data_prep*. It is not necessary to run these as their output is already saved in the *data* folder.

#### 3. Workflow

The code in our workflow is contained in .Rmd files numbered from **01_** to **06_**. As these have already been run, users may skip directly to specific analyses without the need to run **01_** through **03_** where further data cleaning and sorting takes place.

### Important Documents

[Current Working Paper Version](https://docs.google.com/document/d/1Mlf8QANbUKt9zLxhXnp0ODt57-551YmmQatmENXEK88/edit#heading=h.4jbwvgc9efg)



### Source Data

The data preparation code is in the sub-folder CRI/data_prep. After the data prep files, all necessary data analysis files are in the CRI/data folder. These files are many because participants' code often requires special files to run properly. The data files needed to reproduce the data anlysis. These files are:

| Filename | Description | Source |
| ---| -------|---|
| MAIN FILES | Used in Main Analyses 01-07 | |
| **cri.csv** | Main data analysis file, model & team-levels. All specifications coded by the PIs, team test results and researcher characteristics in numeric format | Worked up in *CRI/data_prep* |
| **cri_str.csv** | A string-format only version of *cri_str.csv* | Worked up in *CRI/data_prep* |
| **cri_team.csv** | A version of *cri_str.csv* aggregated team-level means (N = 89 because 16 teams conducted independent hypothesis tests by 'stock' and 'flow' immigration measures) | Worked up in **CRI/data_prep** |
| **popdf_out.Rdata** |The peer review/deliberation scoring of model specifications as ranked by all participants; excepting non-response|Generated in sub-folder *CRI/data_prep* | Participant survey and Kialo deliberation |
| SUB-FILES | Used in Preparation of Data or App| |
| **Research Design Votes.xlsx** | Based on participant pre-registered designs, plus cursory review of all research designs. Not a fully accurate portrayal of final research designs because, (a) the broad range of specifications not reported in basic research designs and (b) the participant's often deviated from their proposed designs, if only slightly | This is a copy of the actual template (a Google Sheet) used to create the peer review voting system in the Participant Survey | 
| **cri_shiny.csv**| The model-level data needed to run the shiny app | Generated in *CRI/data_prep* |
| **cri_shiny_team.csv**| The team-level data needed to run the shiny app | Generated in *CRI/data_prep* |

The cri main files include team zero, which is the state of the art study from Brady and Finnigan [(2014)](https://doi.org/10.1177/0003122413513022) providing a launching point for the CRI coded in all the same ways, but the two authors were not participants therefore it is dropped from most analyses.


