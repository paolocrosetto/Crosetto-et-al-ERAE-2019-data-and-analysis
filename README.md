# Data analysis for the ERAE 2019 paper "Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence" by Crosetto, Lacroix, Muller, Ruffieux

This repository contains data and analysis for the Paolo Crosetto, Anne Lacroix, Laurent Muller, and Bernard Ruffieux ERAE 2019 paper "Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence". It allows anyone to reproduce all the analyses carried out in the paper and to download the data for further analysis.

## Dependencies TEST

To run the analysis you need `R` and the following packages (available on CRAN):

- `tidyverse` -- a set of tools to work with tidy -- i.e. well behaved -- data
- `broom` -- a library to tidy the output of tests, regressions, so that it can be used with `tidyverse`
- `huxtable` -- a tool to make beautiful tables by my friend Dave Hugh-Jones

Optional, but highly recommended, is to install `Rstudio`. You can run all this in a standard `R` console, but `Rstudio` gives you a comprehensive IDE to run your analysis, see your plots, interact with gitHub, and more. 

## How to run the analysis

1. Download this repository. 
2. Open the `.Rproj` file 

The analysis is carried out in the file `Analysis.R`. This file:

- loads the packages (install them first if you do not have them)
- loads the data
- calls on individual files to generate individual figures or tables

For each figure or table in the paper, there is one dedicated file. The files are self-standing and can be executed in any order. 

Figures are saved to the `Figures/` folder. They are the high-resolution images (and do not fit well in the github preview screen) included in the paper. Some figures are not 100% identical to those in the paper as for the final figures we used the package `hrbrthemes` that is not on CRAN but must be installed via `devtools`. To reduce dependencies the final theme tweakings are not included, but can be turned on by uncommenting the relevant lines at the end of each Figure script. Follow directions therein to install the theme and use it.

Tables are saved to the `Tables/` folder. They contain the exact same information as in the paper, but their formatting is in general different from the one of the paper, because a. some fine-tuning has been done by hand; b. the .tex version of the tables is somewhat different and c. for some tables the results of statistical tests was incorporated by hand. 