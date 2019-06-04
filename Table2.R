###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Table 2 of the paper

## NOTE
## the produced table differs from the paper version in appearance
## this is because the final table was tweaked by hand to make it more compact and readable
## in particular, the results of the three tables were compactly formatted into only one table


## Computing the individual socreFSA by shopping basket
ind <-  df %>% 
  ungroup() %>% 
  group_by(treatment, subject,caddy) %>% 
  summarise(indicator = (sum(FSAKcal))/sum(actual_Kcal))


## Simple difference indicator used in analysis
ind <- ind %>% 
  spread(caddy, indicator) %>% 
  mutate(diff = (`2`-`1`)) %>% 
  select(treatment, subject, FSA1 = `1`, FSA2 = `2`, diff)


## Wilcoxon rank-sum tests, upper triangle of Table 2
pairwise.wilcox.test(ind$diff, ind$treatment, p.adjust.method = "none") %>% 
  tidy() %>% 
  mutate(p.value = round(p.value, 3)) %>% 
  spread(group1, p.value) %>% 
  write_csv("Tables/Table2_upper.csv")


## Two-tailed t-tests, lower triangle of Table 2
pairwise.t.test(ind$diff, ind$treatment) %>% 
  tidy() %>% 
  mutate(p.value = round(p.value, 3)) %>% 
  spread(group2, p.value) %>% 
  write_csv("Tables/Table2_lower.csv")


## Mean effect of each label, diagonal of Table 2
ind %>% 
  group_by(treatment) %>% 
  summarise(mean = round(mean(diff, na.rm = T),2)) %>% 
  write_csv("Tables/Table2_diagonal.csv")

## cleaning up
rm(ind)

