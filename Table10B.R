regression <- function(var, type = "other") {
  ##create indicator
  if (type == "other") {
    df <- df %>% mutate(tempvar = ((!!var)/100)*actual_weight*actual_Kcal)  
    ind <-  df %>% ungroup() %>% group_by(treatment, subject,caddy) %>% summarise(indicator = (sum(tempvar))/sum(actual_Kcal))
  }
  
  if (type == "LIM") {
    ind <-  df %>% ungroup() %>% group_by(treatment, subject,caddy) %>% summarise(indicator = (sum(!!var))/sum(actual_Kcal))
  }
  
  
  
  #removing subj not used
  ind <- ind %>% 
    filter(indicator != 0) %>% 
    mutate(caddy = as_factor(caddy))

bare_spec <-  "indicator~caddy*treatment"
#regression
ind %>%  lm(bare_spec, data=.)
}

#separate regressions for the three income groups
reg_ags <- regression(quo(ags_100))
reg_salt <- regression(quo(sel_100))
reg_fat <- regression(quo(lipides_100))
reg_sugar <- regression(quo(sucres_100))
reg_lim <- regression(quo(LIMKcal), type = "LIM")


library(huxtable)
output <- huxreg("LIM" = reg_lim,
                 "Salt" = reg_salt, 
                 "Sugar" = reg_sugar, 
                 "Fat" = reg_fat, 
                 "SFA" = reg_ags,
                 bold_signif = 0.05,
                 coefs = c("Intercept" = "(Intercept)", "Caddy 2" = "caddy2",
                           "NutriScore" = "treatmentNutriScore",
                           "NutriMark" = "treatmentNutriMark",
                           "NutriCouleur" = "treatmentNutriCouleur",
                           "NutriRepere" = "treatmentNutriRepère",
                           "SENS" = "treatmentSENS",
                           "NutriScore#caddy2" = "caddy2:treatmentNutriScore",
                           "NutriMark#caddy2" = "caddy2:treatmentNutriMark",
                           "NutriCouleur#caddy2" = "caddy2:treatmentNutriCouleur",
                           "NutriRepere#caddy2" = "caddy2:treatmentNutriRepère",
                           "SENS#caddy2" = "caddy2:treatmentSENS"))

output <- output %>% 
  theme_article                                                  %>% 
  # set_background_color(1:nrow(output), evens, grey(.95)) %>% 
  set_font_size(final(), 1, 9)                                   %>% 
  set_bold(final(), 1, FALSE)                                    %>%
  set_top_border(final(), 1, 1)                                  %>%
  set_caption('')

## Table B10 export
output %>% write_csv("Tables/Table10B.csv")

## cleaning up
rm(reg_salt, reg_sugar, reg_lim, reg_ags, reg_fat, output regression)


