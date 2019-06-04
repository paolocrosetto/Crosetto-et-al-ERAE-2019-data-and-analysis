###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### Ful analysis to reproduce all Figures and Tables of the paper
###
### 1. install dependencies
### 2. run this script
### 3. Figures are then stored in the Figures/ subdirectory, and Tables in the Tables/ one
### 4. Figures are identical to the ones in the paper but for the appearance and theming 
###    (code to produce the fianl theming is provided but need further dependencies not available on CRAN)
### 5. Tables contain the same numbers and information as in the paper but their appearance is generally different
###    (because the paper is .tex and because some tweakings were done by hand)
###
### License CC BY-NC-SA
###
### Full data from the experiment is stored in the file Crosetto_et_al_ERAE2019_data.csv
###
### Contact: paolo.crosetto@inra.fr


## libraries
library(tidyverse)
library(broom)
library(huxtable)

## import data
df <- read_csv("Crosetto_et_al_ERAE2019_data.csv")


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

