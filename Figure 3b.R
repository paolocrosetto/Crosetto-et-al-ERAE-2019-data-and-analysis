###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Figure 3b of the paper -- the plot on the top right corner of Figure 3

## selecting relevant variables and rows
ns <- df %>% 
  select(subject, caddy, treatment, product, quantity, couleur_SENS) %>% 
  filter(quantity !=0) %>% 
  filter(treatment == "SENS")

## fixing the NAs as 'no label'
ns$couleur_SENS[is.na(ns$couleur_SENS)] <- "No label"

## renaming the SENS level to their respective simple language labels
ns <- ns %>% 
  mutate(couleur_SENS = as.factor(couleur_SENS)) %>% 
  mutate(couleur_SENS = fct_relevel(couleur_SENS, "No label", "4", "3", "2", "1")) %>% 
  mutate(couleur_SENS = fct_recode(couleur_SENS, "Every day" = "1", "1 or 2 times per week" = "3",
                                   "Several times per week" = "2", "Occasionally" = "4")) 

## creating the number of products of each category for each color
ns <- ns %>% mutate(caddy = as.factor(as.character(caddy))) %>% 
  select(-treatment) %>%
  group_by(subject, caddy, couleur_SENS) %>% 
  summarise(n = sum(quantity)) %>% 
  ungroup() %>% 
  spread(caddy,n) 

## compute difference variable, mean and confidence interval of change by color over subjects
ns <- ns %>%   
  mutate(diff = `2` - `1`) %>% 
  group_by(couleur_SENS) %>% 
  summarise(mdiff = mean(diff, na.rm = T), sediff = sd(diff, na.rm = T)/sqrt(n())) %>% 
  mutate(cil = mdiff-2*sediff, cih = mdiff + 2*sediff)


## plotting -- Figure 3b - behavioral changes with SENS (excluding products with no label)
ns %>% 
  filter(couleur_SENS != "No label") %>% 
  ggplot(aes(couleur_SENS, mdiff, fill=couleur_SENS))+geom_col()+
  geom_errorbar(aes(ymin = cil, ymax = cih), width = 0.1, color="grey40")+
  theme_minimal()+
  scale_fill_manual(values = rev(c("#3caa37","#007fc6","#ef7d00","#842082")))+
  theme(legend.position = "none")+xlab("SENS category")+ylab("Mean number of changes, caddy 2 vs caddy 1")+
  ggtitle("Absolute number of product changes by SENS category, by subject")
ggsave("Figures/Figure_3b.png", width = 8, height = 5, units = "in", dpi = 300)

## cleaning up
rm(ns)
