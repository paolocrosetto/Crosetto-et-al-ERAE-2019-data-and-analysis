#############################################
### NEW INTRO HEADER
#############################################

## libraries
library(tidyverse)


## TODOs
# bring all library dependencies to the front up here
# further clean the initial base 
#   - eliminate NutriScore limité
#   - factor levels
#   - see in files below and treat accordingly

df <- read_csv("ERAE_2019_data_initial_version_23_may_19_noNSRL_newnames.csv")

## Figure 1
source("Figure 1.R")

## Figure 2
source("Figure 2.R")


#### from here on: TODO

### demographics of the sample
source("Demographics.R")

### some useless stuff
source("Playground.R")

## for revision: alternative income definitions
#source("Income_revision.R")

## declarative analysis of labels
source("Declaratif.R")
source("Declaratif_summaryTable.R")

## Considering the FSA score first
source("main_plot_EN_paper.R")
source("neutre_paper.R")
source("all_paper.R")
source("all_paper_revision.R")
source("main_plot_EN_revision.R")
source("analysisFSA.R")
source("analysisPauvres.R")

##behavioral analysis
source("Behavioral_main.R")
source("Behavioral_NS.R")
source("Behavioral_NM.R")
source("Behavioral_NC.R")
source("Behavioral_NR.R")
source("Behavioral_SENS.R")

##analysis by product category
source("bycategory.R")

## What if we use LIM instead?
#source("analysisLIM.R")

##what if we use salt instead?
# source("analysisSALT.R")

##price analysis
source("AnalysisPrice.R")
source("Price_advanced.R")
source("Price_vs_FSA.R")
source("Price_vs_FSA_R2_bare_cost.R")


## Most used products
source("AnalysisProduct.R")


#regressions over difference variable
source("Regressions.R")

#regression over 'simple' variable
source("Regressions_FSA.R")
source("Regressions_FSA_revision.R")
source("Regressions_FSA_revision_referee.R")

#robustness: LIM
source("main_plot_EN_paper_LIM.R")
source("Regressions_LIM.R")

#robustness: salt
source("main_plot_EN_paper_salt.R")
source("Regressions_salt.R")

#robustness: fat
source("main_plot_EN_paper_fat.R")
source("Regressions_fat.R")

#robustness: sugar
source("main_plot_EN_paper_sugar.R")
source("Regressions_sugar.R")

#robustness: AGS
source("main_plot_EN_paper_ags.R")
source("Regressions_ags.R")

#robustness: by weight
source("main_plot_EN_paper_weight.R")
source("Regressions_weight.R")

source("Regressions_allcontrols.R")

source("Regressions_allcontrols_revision.R")




#tests
source("Tests.R")
source("Tests_weight.R")
source("Tests_LIM.R")

#NSRL
source("AnalysisNSRL.R")



