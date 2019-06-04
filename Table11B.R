###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Table B11 of the paper -- main diff-in-diff regression

## NOTE
## the produced table differs from the paper version in appearance
## this is because the final table was tweaked by hand to make it more compact and readable
## the output depends on the package huxtable -- available on CRAN

## getting the needed demographic varibales
regdemo <- df %>%
  ungroup() %>%
  select(subject, personal_weight, height, female, age_categorical, income2,
         incomeclass, edu_categorical, familysize, children,occupation) %>%
  distinct()


## computing the FSA indicator
ind <-  df %>% 
  ungroup() %>% 
  group_by(treatment, subject,caddy) %>% 
  summarise(indicator = (sum(FSAKcal))/sum(actual_Kcal))

## joining into the dataset used for the regression
reg <- left_join(ind,regdemo, by="subject") %>%
  ungroup() %>%
  mutate(incomeclass = as_factor(incomeclass),
         caddy = as_factor(caddy)) %>% 
  mutate(occupation = as_factor(occupation)) %>% 
  mutate(occupation = fct_relevel(occupation, "foyer")) %>% 
  mutate(treatment = fct_relevel(treatment, "Benchmark"),
         bmi = personal_weight/((height/100)**2))


### regressions with controls

general_specification <- "indicator~caddy*treatment + incomeclass + female + age_categorical + occupation + edu_categorical + familysize + children  + bmi"
diff_diff_specification <- "indicator~caddy*treatment  + age_categorical + edu_categorical + familysize + children + female + bmi + occupation"

#all the sample
reg_bare <- reg %>% 
  lm(general_specification, data=.)

#separate regressions for the three income groups
reg_poor <- reg %>%
  filter(incomeclass == 1) %>% 
  lm(diff_diff_specification, data=.)

reg_middle <- reg %>% 
  filter(incomeclass == 2) %>% 
  lm(diff_diff_specification, data=.)

reg_rich <- reg %>% 
  filter(incomeclass == 3) %>% 
  lm(diff_diff_specification, data=.)


# formatting output with huxtable
output <- huxreg("Interactions only" = reg_bare, 
                 # "With controls" = reg_control, 
                 "Low income only" = reg_poor, 
                 "Middle income only" = reg_middle, 
                 "High income only" = reg_rich,bold_signif = 0.05, 
                 coefs = c("Intercept" = "(Intercept)", "Basket 2" = "caddy2",
                           "NutriScore" = "treatmentNutriScore",
                           "NutriMark" = "treatmentNutriMark",
                           "NutriCouleur" = "treatmentNutriCouleur",
                           "NutriRepere" = "treatmentNutriRepère",
                           "SENS" = "treatmentSENS",
                           "NutriScore X Basket 2" = "caddy2:treatmentNutriScore",
                           "NutriMark X Basket 2" = "caddy2:treatmentNutriMark",
                           "NutriCouleur X Basket 2" = "caddy2:treatmentNutriCouleur",
                           "NutriRepere X Basket 2" = "caddy2:treatmentNutriRepère",
                           "SENS X Basket 2" = "caddy2:treatmentSENS",
                           "Middle income" = "incomeclass2",
                           "High income" = "incomeclass3",
                           "Age 30-44" = "age_categorical30-44",
                           "Age 45-59" = "age_categorical45-59",
                           "Age >60" = "age_categorical>60",
                           "Family size" = "familysize",
                           "# of children" = "children",
                           "Body Mass Index" = "bmi",
                           "Worker" = "occupationtravail",
                           "Unemployed" = "occupationchomage",
                           "Student" = "occupationetudiant",
                           "Retired" = "occupationretraite",
                           "High school degree" = "edu_categoricalhigh school",
                           "University degree" = "edu_categoricaluniversty or >"
                 ))

output <- output %>% 
  theme_article                                                  %>% 
  # set_background_color(1:nrow(output), evens, grey(.95)) %>% 
  set_font_size(final(), 1, 9)                                   %>% 
  set_bold(final(), 1, FALSE)                                    %>%
  set_top_border(final(), 1, 1)                                  %>%
  set_caption('')


output %>% write_csv("Tables/Table11B.csv")
