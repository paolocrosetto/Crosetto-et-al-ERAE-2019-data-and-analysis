###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Table 8 of the paper

## NOTE
## the produced table differs from the paper version in appearance
## this is because the final table was tweaked by hand to make it more compact and readable


## selecting the questionnaire data
t8 <- df %>% 
  select(subject, treatment, easy, helps, influences, 
         precise, reassuring, betterdiet, betterhealth,
         justadv, helpschoice, givesnutrinfo, givesliminfo, useful ) %>%
  distinct() %>% 
  filter(treatment != "Benchmark")

## recoding all variables
## The initial variables had 4 levels:
## 1. yes/a lot
## 2. mostly
## 3. not really/little
## 4. no/none
## Here we translate them to the values of 1, 0.75, 0.25, 0
t8 <- t8 %>% 
  mutate_at(c("easy", "helps","influences","precise","reassuring","betterdiet","betterhealth", "justadv", "useful"), 
                       funs(fct_recode(., "1" = "oui", "0" = "non", "0.25" = "pasVraiment", "0.75" = "plutot"))) %>% 
  mutate_at(c("helpschoice","givesnutrinfo","givesliminfo"), 
            funs(fct_recode(., "1" = "beaucoup", "0" = "pas", "0.25" = "peu", "0.75" = "assez")))


## changing type of variable from factor to float
t8 <- t8 %>%  mutate_if(is.factor, 
                        funs(as.numeric(as.character(.)))) 


## computing means by treatment and question
t8 <- t8 %>% 
  select(-subject) %>% 
  group_by(treatment) %>% 
  summarise_all(vars(mean(., na.rm = T))) %>% 
  mutate_if(.predicate = is.numeric, .funs = round, digits = 2)


## formatting the table
t8 <- t8 %>%
  gather(var, val, -treatment) %>% 
  spread(treatment, val)

## renaming the variables for clarity
t8 <- t8 %>% 
  mutate(var = as_factor(var)) %>% 
  mutate(var = fct_recode(var, 
                          "help build a better diet" = "betterdiet",
                          "influence my shopping" = "influences",
                          "help in following health recommendations" = "betterhealth",
                          "easy to understand" = "easy",
                          "a tip for good choices" = "helpschoice",
                          "just advertisement" = "justadv",
                          "give information about food items to limit" = "givesliminfo",
                          "give information on the nutritional composition" = "givesnutrinfo",
                          "show me the nutritional quality" = "helps"
                          ))

## export to csv
t8 %>% 
  write_csv("Tables/Table8.csv")

## cleanup 
rm(t8)