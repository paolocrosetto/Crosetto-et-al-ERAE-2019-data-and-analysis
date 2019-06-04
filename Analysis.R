#############################################
### TODO NEW INTRO HEADER
#############################################

## libraries
library(tidyverse)
library(broom)
library(huxtable)


## TODOs
# bring all library dependencies to the front up here
# further clean the initial base 
#   - eliminate NutriScore limité
#   - factor levels
#   - see in files below and treat accordingly

## import data
df <- read_csv("alldata_june_4th.csv")


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
source("Table4.R")

## Table 5 - expenditure
source("Table5.R")

## Table 6 - expenditure diff-in-difftest
source("Table6.R")

## Table 7 - behavioral indicators
source("Table7.R")

## Table 8 - qualitative label assessment
source("Table8.R")

## Table A.9 - sample demographics
source("Table9A.R")

## Table B.10 - robustness diff-in-diff estimations

## Table B.11 - diff-in-diff with individual controls




#### from here on: OLD STUFF


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



