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

## import data
df <- read_csv("ERAE_2019_data_initial_version_23_may_19_noNSRL_newnames.csv")

###################
###   Figures   ###
###################

## Figure 1
source("Figure 1.R")

## Figure 2
source("Figure 2.R")

## Figure 3a -- NutriScore
source("Figure 3a.R")

## Figure 3b -- SENS
source("Figure 3b.R")

## Figure 3c -- NutriMark
source("Figure 3c.R")

## Figure 3d -- NutriCouleur
source("Figure 3d.R")

## Figure 3e -- NutriRepère
source("Figure 3e.R")

##################
###   Tables   ###
##################

## Table 2 - WRST and t-tests 
source("Table2.R")

## Table 3 - diff-in-diff estimation, overall and by income class
source("Table3.R")

## Table 4 - robustness checks

## Table 5 - expenditure
source("Table5.R")

## Table 6 - expenditure diff-in-difftest
source("Table6.R")

## Table 7 - behavioral indicators

## Table 8 - qualitative label assessment

## Table A.9 - sample demographics

## Table B.10 - robustness diff-in-diff estimations

## Table B.11 - diff-in-diff with individual controls




#### from here on: OLD STUFF

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


##analysis by product category
source("bycategory.R")

## What if we use LIM instead?
#source("analysisLIM.R")œ

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



