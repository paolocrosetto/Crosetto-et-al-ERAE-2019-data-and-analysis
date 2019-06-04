###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Table 3 of the paper -- main diff-in-diff regression

## NOTE
## the produced table differs from the paper version in appearance
## this is because the final table was tweaked by hand to make it more compact and readable
## the output depends on the package huxtable -- available on CRAN

## getting the needed demographic varibales
regdemo <- df %>%
  ungroup() %>%
  select(subject, incomeclass) %>%
  distinct()


## computing the FSA indicator
ind <-  df %>% 
  ungroup() %>% 
  group_by(treatment, subject,caddy) %>% 
  summarise(indicator = (sum(FSAKcal))/sum(actual_Kcal))

## joining into the dataset used for the regression
reg <- left_join(ind,regdemo, by="subject") %>% 
  mutate(caddy = as_factor(caddy))


## regressions

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

# formatting of the output with huxtable
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
                           "NutriRepere X Basket 2" = "caddy2:treatmentNutriRepère",
                           "SENS X Basket 2" = "caddy2:treatmentSENS"))

output <- output %>% 
  theme_article                                                  %>% 
  # set_background_color(1:nrow(output), evens, grey(.95)) %>% 
  set_font_size(final(), 1, 9)                                   %>% 
  set_bold(final(), 1, FALSE)                                    %>%
  set_top_border(final(), 1, 1)                                  %>%
  set_caption('')

## Table 3 -- save to file
output %>% write_csv("Tables/Table3.csv")

## cleaning up
rm(ind, reg, reg_bare, reg_poor, reg_middle, reg_rich, regdemo, output)
