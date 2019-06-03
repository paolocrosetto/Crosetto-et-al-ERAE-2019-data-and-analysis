###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Table 4 of the paper

## NOTE
## the produced table differs from the paper version in appearance


## This function computes summary statistics for each indicator (one row of table 4)
## It taks as input the name of the variable to summarise and the name you want displayed in the final table
## It generates as output a row for the variable and a column for each treatment
## For the normalization by weight the extra parameter "w" is needed; the function defaults to using kcal as a normalization
robustness_check <- function(var, name, type = "k") {
  var <- enquo(var)
  
  ## creating the LIM indicator
  if (type == "k") {
    ind <-  df %>% 
      ungroup() %>% 
      group_by(treatment, subject,caddy) %>% 
      summarise(indicator = (sum(!!var))/sum(actual_Kcal))    
  }
  
  if (type == "w") {
    ind <-  df %>% 
      ungroup() %>% 
      group_by(treatment, subject,caddy) %>% 
      summarise(indicator = (sum(!!var))/sum(actual_weight))     
  }
  
  ## testing
  tests <- ind %>% 
    group_by(treatment) %>% 
    do(tidy(wilcox.test(indicator ~ caddy, data = .)))%>% 
    select(treatment, p.value)
  
  ## computing the diff variable
  ind <- ind %>% 
    spread(caddy, indicator) %>% 
    mutate(diff = (`2`-`1`))
  
  ## summarising
  ind <- ind %>% 
    group_by(treatment) %>% 
    summarise(mean = round(mean(diff, na.rm = TRUE),2), sd = round(sd(diff, na.rm = TRUE),2))
  
  ## merging the summary and the tests
  ind <- left_join(ind, tests, by = "treatment")
  
  ## using symbols to convey test information in the table
  ind <- ind %>% 
    mutate(p.value = cut(p.value, breaks = c(0, 0.0009, 0.009, 0.049, 0.099, 1), labels = c("***","**","*","†","")))
  
  ## formatting and preparing f or later merge
  row <- ind %>% 
     mutate(effect = paste(round(mean,2), p.value, " (", round(sd,2), ")", sep="")) %>% select(treatment, effect) %>% 
     spread(treatment, effect) %>% mutate(Indicator = name) %>% select(Indicator, everything()) 
  
  row
}



## applying the function, binding and exporting to csv
rbind(robustness_check(LIMKcal, "LIM"),
      robustness_check(FatKcal, "Fat"),
      robustness_check(SFAKcal, "Saturated Fatty Acids"),
      robustness_check(SugarKcal, "Sugar"),
      robustness_check(SaltKcal, "Salt"),
      robustness_check(FSAgram, "Normalized by weight","w")) %>% 
  write_csv("Tables/Table4.csv")

## cleanup
rm(robustness_check)
