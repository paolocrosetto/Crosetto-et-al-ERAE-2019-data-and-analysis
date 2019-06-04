# Data analysis for the ERAE 2019 paper "Nutritional and Economic Impact of ..." by Crosetto, Lacroix, Muller, Ruffieux

This repository contains data and analysis for the Crosetto, Lacroix, Muller, Ruffieux ERAE 2019 paper "Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence"

## Dependencies 

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

Figures are saved to the `Figures/` folder. 