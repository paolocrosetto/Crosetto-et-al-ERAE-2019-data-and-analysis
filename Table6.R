###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Table 6 of the paper

## NOTE
## the produced table differs from the paper version in appearance
## this is because the final table was tweaked by hand to make it more compact and readable


## computing the across-baskets difference in the FSA indicator
nutritional <-  df %>% 
  ungroup() %>% 
  group_by(treatment, subject,caddy) %>% 
  summarise(indicator = (sum(FSAKcal))/sum(actual_Kcal)) %>% 
  spread(caddy, indicator) %>% 
  mutate(FSAdiff = (`2`-`1`)) %>% 
  select(treatment, subject, FSAdiff) %>% 
  mutate(FSAdiff = -FSAdiff)

## computing the across-basket difference in expenditure
expenditure <- df %>% 
  ungroup() %>% 
  group_by(treatment, caddy, subject) %>% 
  summarise(paid = sum(actual_price)) %>% 
  group_by(treatment, caddy) %>% 
  spread(caddy, paid) %>% 
  mutate(EXPdiff = `2` - `1`) %>% 
  select(treatment, subject, EXPdiff)

## computing the FSA gain for each extra euro spent
dp <- left_join(nutritional, expenditure, by = c("treatment", "subject"))

## Table 6
dp %>% 
  lm(EXPdiff~FSAdiff*treatment, data=.) %>% 
  tidy() %>% 
  mutate_if(.predicate = is.numeric, round, digits = 2) %>% 
  write_csv("Tables/Table6.csv")

## Cleanup
rm(expenditure, nutritional, dp)


