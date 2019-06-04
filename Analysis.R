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
#   - MOVE Table B11 to the paper (as it has changed slightly)
#   - MOVE figure 3 (all of it) to the paper just in case

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
source("Table10B.R")

## Table B.11 - diff-in-diff with individual controls
source("Table11B.R")

######## Thanks for running the code, this is the end!

