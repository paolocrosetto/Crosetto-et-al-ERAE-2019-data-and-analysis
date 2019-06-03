
## TODO how to export a huxtable to csv? simple: with write_csv -> not tbhe best look but it works


# ## getting the needed demographic varibales
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

reg <- left_join(ind,regdemo, by="subject") %>%
  ungroup() %>%
  mutate(caddy = as_factor(caddy)) %>% 
  mutate(treatment = fct_relevel(treatment, "Benchmark"),
                       bmi = personal_weight/((height/100)**2))


### main regressions: without controls

#all the sample
reg_bare <- reg %>% 
  lm(indicator~caddy*treatment, data=.)

#separate regressions for the three income groups
reg_poor <- reg %>% 
  filter(incomeclass == 1) %>% 
  lm(indicator~caddy*treatment, data=.)

reg_middle <- reg %>% 
  filter(incomeclass == 2) %>% 
  lm(indicator~caddy*treatment, data=.)

reg_rich <- reg %>% 
  filter(incomeclass == 3) %>% 
  lm(indicator~caddy*treatment, data=.)



library(huxtable)
output <- huxreg("Interactions only" = reg_bare, 
                 # "With controls" = reg_control, 
                 "Low LS" = reg_poor, 
                 "Middle LS" = reg_middle, 
                 "High LS" = reg_rich,bold_signif = 0.05,
                 coefs = c("Intercept" = "(Intercept)",
                           "Basket 2" = "caddy2",
                           "NutriScore" = "treatmentNutriScore",
                           "NutriMark" = "treatmentNutriMark",
                           "NutriCouleur" = "treatmentNutriCouleur",
                           "NutriRepere" = "treatmentNutriRepère",
                           "SENS" = "treatmentSENS",
                           "NutriScore X Basket 2" = "caddy2:treatmentNutriScore",
                           "NutriMark X Basket 2" = "caddy2:treatmentNutriMark",
                           "NutriCouleur X Basket 2" = "caddy2:treatmentNutriCouleur",
                           "NutriReper X Basket 2" = "caddy2:treatmentNutriRepère",
                           "SENS X Basket 2" = "caddy2:treatmentSENS"))

output <- output %>% 
  theme_article                                                  %>% 
  # set_background_color(1:nrow(output), evens, grey(.95)) %>% 
  set_font_size(final(), 1, 9)                                   %>% 
  set_bold(final(), 1, FALSE)                                    %>%
  set_top_border(final(), 1, 1)                                  %>%
  set_caption('')



### OK it works unitl here


sink("main_regressions_revision.tex", append=FALSE, split=FALSE)
output %>% print_latex()
sink()

### main regressions: WITH controls

#all the sample
reg$incomeclass <- as.factor(reg$incomeclass)
reg_bare <- lm(as.formula(general_spec), data=reg)

#separate regressions for the three income groups
reg_poor <- lm(did_spec, data=reg[reg$incomeclass == 1,])
reg_middle <- lm(did_spec, data=reg[reg$incomeclass == 2,])
reg_rich <- lm(did_spec, data=reg[reg$incomeclass == 3,])



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
                           "Age 30-44" = "age230-44",
                           "Age 45-59" = "age245-59",
                           "Age >60" = "age2>60",
                           "Family size" = "familysize",
                           "# of children" = "children",
                           "Body Mass Index" = "bmi",
                           "Worker" = "occupationtravail",
                           "Unemployed" = "occupationchomage",
                           "Student" = "occupationetudiant",
                           "Retired" = "occupationretraite",
                           "High school degree" = "edu2bac",
                           "University degree" = "edu2Supérieur au bac"
                           ))

output <- output %>% 
  theme_article                                                  %>% 
  # set_background_color(1:nrow(output), evens, grey(.95)) %>% 
  set_font_size(final(), 1, 9)                                   %>% 
  set_bold(final(), 1, FALSE)                                    %>%
  set_top_border(final(), 1, 1)                                  %>%
  set_caption('')

sink("main_with_controls_revision.tex", append=FALSE, split=FALSE)
output %>% print_latex()
sink()

