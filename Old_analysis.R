#############################################
### Label 4 data analysis
#############################################

## getting data
setwd("~/Dropbox/Grenoble/Projects/Label4/09 - données/Données Brutes XP/")
load(file = "label4_alldata.Rdata")

## libraries
library(tidyverse)
library(forcats)

setwd("~/Dropbox/Grenoble/Projects/Label4/09 - données/Analysis/")


## saving aside all the behavioral tracker data
alldata <- df

## data cleaning
df <- df %>% filter(bought == 1)
df <- df %>% select(session_number, subject, treatment, date, personal_weight = weight.x, weight = weight.y, everything())

## add the manually filled data
source("fill_data.R")

## detailed data cleaning
source("Data_Cleaning.R")

### some testing on poverty and consumption


###exporting for chantal
#exp <- df
#WriteXLS::WriteXLS("exp","new_export_chantal.xlsx")

## export for Cédric
# source("Ced_export.R")


## export data for Anne
# source("Anne_export.R")

##save data as .xls for others
# WriteXLS::WriteXLS("df","alldata.xlsx")

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



