#############################################
### NEW INTRO HEADER
#############################################

## libraries
library(tidyverse)
library(broom)


## TODOs
# bring all library dependencies to the front up here
# further clean the initial base 
#   - eliminate NutriScore limité
#   - factor levels
#   - see in files below and treat accordingly

## import data
df <- read_csv("ERAE_2019_data_initial_version_23_may_19_noNSRL_newnames.csv")

### this aprt: changes to be merged in the df later
# calculating fat per Kcal
df <- df %>% 
  mutate(FatKcal = (lipides_100/100)*actual_weight*actual_Kcal,
         SFAKcal = (ags_100/100)*actual_weight*actual_Kcal,
         SugarKcal = (sucres_100/100)*actual_weight*actual_Kcal,
         SaltKcal = (sel_100/100)*actual_weight*actual_Kcal)

# demogaphic variables

# recoding education and translating from French levels to readable output
df <- df %>% 
  mutate(edu_categorical = fct_recode(education, "< high school" = "aucun", "< high school" = "bp",
                           "< high school" = "cap", "high school" = "bac", "universty or >" = "sup2",
                           "universty or >" = "sup4", "universty or >" = "autre"))

# transforming age into a categorical variable
df <- df %>% 
  mutate(age_categorical = cut(age, breaks = c(0,29,44,59,100), labels = c("<30","30-44","45-59",">60")))

# computing standard of living
df <- df %>% 
  mutate(income_numeric = case_when(
    income=="0_1000" ~ 1000,
    income=="1000_2000" ~ 1500,
    income=="2000_3000" ~ 2500,
    income=="3000_4000" ~ 3500,
    income=="4000_5000" ~ 4500,
    income=="5000_6000" ~ 5500,
    income=="6000_7000" ~ 6500,
    income=="7000_8000" ~ 7500,
    income=="8000_plus" ~ 8000
  ))

# 0 children was coded as NA
df <- df %>% 
  mutate(children = if_else(is.na(children), 0, children))

# computing living standards per year, then split into three equal groups
df <- df %>% 
  mutate(consumption_units = (1+(familysize-children-1)*0.5 + children*0.3)) %>% 
  mutate(living_standard = income_numeric/consumption_units) %>% 
  mutate(living_standard_year = living_standard*12) %>%
  ungroup() %>% 
  mutate(incomeclass = ntile(living_standard_year, 3))




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
##TODO source("Table3.R")

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



## Considering the FSA score first
source("main_plot_EN_paper.R")
source("neutre_paper.R")
source("all_paper.R")
source("all_paper_revision.R")
source("main_plot_EN_revision.R")
source("analysisFSA.R")
source("analysisPauvres.R")


## What if we use LIM instead?
#source("analysisLIM.R")œ

##what if we use salt instead?
# source("analysisSALT.R")





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



