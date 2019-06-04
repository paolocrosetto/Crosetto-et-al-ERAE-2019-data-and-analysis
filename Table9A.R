###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Table A9 in the Appendix of the paper -- demographics of the sample and randomization checks

## NOTE
## the produced table differs from the paper version in appearance
## this is because the final table was tweaked by hand to make it more compact and readable
## the chi2 tests are provided as a separate table


#### Part 1: the table without statistcial testing

# getting the data into a connected data frame
demo <- df %>% select(subject, treatment, female, age_categorical, occupation, profession,
                      edu_categorical, incomeclass, familysize, children, familytype) %>% 
               ungroup() %>% 
               group_by(subject) %>% 
               distinct(.keep_all = TRUE) 

# statistics by treatment
bytreat <- demo %>% ungroup() %>%
  select(treatment, female, age_categorical, incomeclass, edu_categorical,  profession, occupation, familytype)  %>%  
  gather(variable, value, female, age_categorical, incomeclass, edu_categorical, profession, occupation, familytype, factor_key = TRUE) %>%
  group_by(treatment, variable, value) %>%
  summarise (n = n()) %>%
  mutate(freq = round(n*100 / sum(n),2)) %>% select(-n) %>% group_by(variable, value) %>% spread(treatment, freq, fill = 0)


# statistics overall
global <- demo %>% ungroup() %>%
  select(female, age_categorical, incomeclass, edu_categorical,  profession, occupation, familytype)  %>%
  gather(variable, value, female, age_categorical, incomeclass, edu_categorical,  profession, occupation, familytype) %>%
  group_by(variable, value) %>%
  summarise (n = n()) %>%
  mutate(freq = round(n*100 / sum(n),2)) %>% group_by(variable, value)

# Table A9
left_join(bytreat, global, by=c("variable","value")) %>% 
  write_csv("Tables/TableA9.csv")


### Part 2: randomization tests

### randomization tests for Table A9 (last column of the table)
demo %>% 
  select(subject, treatment, female, age_categorical, incomeclass, edu_categorical, profession, occupation, familytype) %>% 
  gather(variable, value, -subject, -treatment) %>% 
  group_by(variable) %>% 
  summarise(pvalue = chisq.test(value, treatment)$p.value) %>% 
  write_csv("Tables/TableA9_tests.csv")

## cleanup
rm(global, bytreat, demo)
