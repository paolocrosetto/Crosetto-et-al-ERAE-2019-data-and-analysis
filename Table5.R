###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Table 5 of the paper

## NOTE
## the produced table differs from the paper version in appearance
## this is because the final table was tweaked by hand to make it more compact and readable


## Building the ndicator of total expenditure by shopping basket
dp <- df %>% 
  ungroup() %>% 
  group_by(treatment, caddy, subject) %>% 
  summarise(expenditure = sum(actual_price))

## average difference by treatment
diff <- dp %>% 
  group_by(treatment, subject) %>% 
  spread(caddy, expenditure) %>% 
  mutate(diff = `2`-`1`) %>% 
  group_by(treatment) %>% 
  select(-subject) %>% 
  summarise_all(.funs = mean) %>% 
  mutate_if(is.numeric, round, digits = 2)

## wilcoxon ranksum test
test <- dp %>% 
  group_by(treatment) %>% 
  do(tidy(wilcox.test(.$expenditure~.$caddy, paired = T))) %>% 
  select(treatment, p.value) %>% 
  transmute("p-value" = round(p.value, 2))

## Table 5
diff %>% 
  left_join(test, by = "treatment") %>% 
  write_csv("Tables/Table5.csv")

## Cleanup
rm(test, diff, dp)

