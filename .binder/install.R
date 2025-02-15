# packages party discovered using
#sort(
#    unique(
#        c(attachment::att_from_rmds(path = "code"),
#          attachment::att_from_rmds(path = "data_prep"),
#          attachment::att_from_rscripts(path = "shiny"),
#          attachment::att_from_rmds(path = "team_code/team_code_R/")
#       )
#     )
#)
# and searching for 'pacman::p_load'

# needed for kableExtra::as_image
install.packages("webshot")
webshot::install_phantomjs()

# This might re-install some already available packages, but we favour clarity of efficiency here
install.packages("Amelia")
install.packages("brms")
install.packages("broom")
install.packages("car")
install.packages("corrplot")
install.packages("countrycode")
install.packages("data.table")
install.packages("DescTools")
install.packages("DiagrammeR")
install.packages("doBy")
install.packages("dplyr")
install.packages("dummies")
install.packages("effectsize")
install.packages("epiDisplay")
install.packages("ExPanDaR")
install.packages("factoextra")
install.packages("fastDummies")
install.packages("flextable")
install.packages("foreign")
install.packages("ggeffects")
install.packages("ggplot2")
install.packages("ggpubr")
install.packages("ggrepel")
install.packages("ggtext")
install.packages("grid")
install.packages("haven")
install.packages("here")
install.packages("Hmisc")
install.packages("hrbrthemes")
install.packages("insight")
install.packages("jtools")
install.packages("kableExtra")
install.packages("knitr")
install.packages("labelled")
install.packages("lavaan")
# lavaanPlot was archived from CRAN on 2021-02-22
#install.packages("lavaanPlot")
install.packages("remotes")
remotes::install_url("https://cran.r-project.org/src/contrib/Archive/lavaanPlot/lavaanPlot_0.6.0.tar.gz", upgrade = "never")
install.packages("leaps")
install.packages("lfe")
install.packages("lme4")
install.packages("lmerTest")
install.packages("lmtest")
install.packages("ltm")
install.packages("lubridate")
install.packages("magick")
install.packages("magrittr")
install.packages("margins")
install.packages("MASS")
install.packages("mdthemes")
install.packages("mfx")
install.packages("mice")
install.packages("miceadds")
install.packages("mirt")
install.packages("mlogit")
install.packages("multilevelTools")
install.packages("MuMIn")
install.packages("nlme")
install.packages("nnet")
install.packages("officer")
install.packages("oglmx")
install.packages("openxlsx")
install.packages("ordinal")
install.packages("pacman")
install.packages("parallel")
install.packages("parameters")
install.packages("plm")
install.packages("plotscale")
install.packages("plyr")
install.packages("psych")
install.packages("purrr")
install.packages("R2jags")
install.packages("ragg")
install.packages("Rcpp")
install.packages("readstata13")
install.packages("readxl")
install.packages("reshape")
install.packages("reshape2")
install.packages("rmarkdown")
install.packages("rowr")
install.packages("rstan")
install.packages("rvest")
install.packages("sandwich")
install.packages("semPlot")
install.packages("shiny")
install.packages("shinyjs")
install.packages("skimr")
install.packages("sjlabelled")
install.packages("sjmisc")
install.packages("sjPlot")
install.packages("sjstats")
install.packages("smooth")
install.packages("stats")
install.packages("stargazer")
install.packages("stringr")
install.packages("summarytools")
install.packages("textreg")
install.packages("tibble")
install.packages("tidyr")
install.packages("tidyverse")
install.packages("wbstats")
install.packages("WeightedCluster")
install.packages("xlsx")
install.packages("xtable")
install.packages("zoo")

#remotes::install_github("easystats/insight")
#remotes::install_github("easystats/effectsize")
