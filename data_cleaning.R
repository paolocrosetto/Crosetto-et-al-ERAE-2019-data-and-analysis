
df <- read_csv("ERAE_2019_data_initial_version_23_may_19_noNSRL_newnames.csv")

### this aprt: changes to be merged in the df later
# calculating fat per Kcal
df <- df %>% 
  mutate(FatKcal = (lipides_100/100)*actual_weight*actual_Kcal,
         SFAKcal = (ags_100/100)*actual_weight*actual_Kcal,
         SugarKcal = (sucres_100/100)*actual_weight*actual_Kcal,
         SaltKcal = (sel_100/100)*actual_weight*actual_Kcal)

# demogaphic variables

# recoding education and translating from French levels to readable output
df <- df %>% 
  mutate(edu_categorical = fct_recode(education, "< high school" = "aucun", "< high school" = "bp",
                                      "< high school" = "cap", "high school" = "bac", "universty or >" = "sup2",
                                      "universty or >" = "sup4", "universty or >" = "autre"))

# transforming age into a categorical variable
df <- df %>% 
  mutate(age_categorical = cut(age, breaks = c(0,29,44,59,100), labels = c("<30","30-44","45-59",">60")))

# computing standard of living
df <- df %>% 
  mutate(income_numeric = case_when(
    income=="0_1000" ~ 1000,
    income=="1000_2000" ~ 1500,
    income=="2000_3000" ~ 2500,
    income=="3000_4000" ~ 3500,
    income=="4000_5000" ~ 4500,
    income=="5000_6000" ~ 5500,
    income=="6000_7000" ~ 6500,
    income=="7000_8000" ~ 7500,
    income=="8000_plus" ~ 8000
  ))

# 0 children was coded as NA
df <- df %>% 
  mutate(children = if_else(is.na(children), 0, children))

# computing living standards per year, then split into three equal groups
ls <- df %>% 
  mutate(consumption_units = (1+(familysize-children-1)*0.5 + children*0.3)) %>% 
  mutate(living_standard = income_numeric/consumption_units) %>% 
  mutate(living_standard_year = living_standard*12) %>%
  ungroup() %>% 
  select(subject, living_standard_year) %>% 
  distinct() %>% 
  mutate(incomeclass = ntile(living_standard_year, 3))

df <- df %>% 
  left_join(ls, by = "subject")

## eliminate unused variables

## nutritional details 
df <- df %>% 
  select(-session, -disp, -ingr, -nutr, -remo, -Nremo, -Ndisp,
         -picture, -kcal_100, -glucides_100, -proteines_100,  -fibres_100, -view,
         -portion_NM, -portion_marque_NM, -unit_portion_NM, -nb_portion_NM, -unit_portion_marque_NM, -kcal_portion_NM,
         -kj_portion_NM, -pourcent_kcal_portion_NM, -lipides_portion_NM, -pourcent_lipides_portion_NM,-ags_portion_NM,
         -sel_portion_NM, -pourcent_ags_portion_NM, -pourcent_sucres_portion_NM,
         -sel_portion_NC, -lipides_portion_NC,
         -starts_with('kj'), -treatcol, -FSAJulia, -lettre_NSRL, -couleur_NSRL,
         -kcal_100_NM, -kcal_100_NC, )

## more
df <- df %>% 
  select(-unit_portion_NC, -unit_portion_NR, -sucres_portion_NM, -sucres_portion_NC, -sucres_portion_NR,-pourcent_sel_portion_NM,
         -pourcent_kcal_portion_NC, -pourcent_lipides_portion_NC, -pourcent_ags_portion_NC, -pourcent_sucres_portion_NC, 
         -pourcent_sel_portion_NC)

## even more
df <- df %>% 
  select(-portion_NC, -portion_NR, -kcal_portion_NC, -ags_portion_NC, -ags_portion_NR, -kcal_portion_NR, -lipides_portion_NR,
         -ags_portion_NC, -ags_portion_NR, -sel_portion_NR, -kcal_100_NR, -kcal_portion_NR, -income2)

df %>% write_csv("Crosetto_et_al_ERAE2019_data.csv")

## cleaning up
rm(ls)
