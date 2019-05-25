# !diagnostics off
######################################
# behavioral analysis of NutriScore  #
######################################


## TODO: this is completely off with respect to the paper -- find out why and fix it

## plot and table 1
## 
## number of items by color code in caddy 1 and caddy 2: sum total

ns <- df %>% select(subject, caddy, treatment, product, quantity,
                    kcal = pourcent_kcal_portion_NR, fat = pourcent_lipides_portion_NR, sfa = pourcent_ags_portion_NR,
                    sugar = pourcent_sucres_portion_NR, salt = pourcent_sel_portion_NR) %>% as_tibble() %>% 
                    filter(quantity !=0) %>% 
                    filter(treatment == "NutriRepère") %>% as_tibble() 

ns <- ns %>% ungroup() %>% select(-treatment) %>% mutate(caddy = as.factor(as.character(caddy))) %>% group_by(caddy) %>% 
  gather(key, value, -subject, -product, -caddy, -quantity) 

#discretizing the GDA value
ns$value[ns$value == ""] <- 0
ns$value[ns$value == "<1"] <- 0
ns$value <- as.numeric(ns$value)
ns$value <- cut(ns$value, breaks = c(-1,5,10,15,20,25,30,40,50,60,70,80,90,1000), labels = c("<5","5-10","10-15",
                                                                                       "15-20","20-25","25-30",
                                                                                       "30-40","40-50","50-60",
                                                                                       "60-70","70-80","80-90",">90"))

ns <- ns %>% group_by(caddy, key, value) %>% 
  summarise(n = sum(quantity)) %>% 
  spread(caddy,n) %>% 
  mutate(diff = `2` - `1`)


ns %>% ggplot(aes(value, diff))+geom_col()+theme_minimal()+facet_grid(key~.)+
  theme(strip.text = element_text(face = "bold"), legend.position = "none")+
  xlab("NutriRepère daily % intake, by nutrient")+ylab("Total number of changes, caddy 2 vs caddy 1")+
  ggtitle("Absolute number of product changes by NutriRepere %intake for all subjects", 'By nutrient, NutriCouleur treatment only')
##TODO: save this plot


## plot and table 2
## 
## number of items by color code in caddy 1 and caddy 2: sum total

ns <- df %>% select(subject, caddy, treatment, product, quantity,
                    kcal = pourcent_kcal_portion_NR, fat = pourcent_lipides_portion_NR, sfa = pourcent_ags_portion_NR,
                    sugar = pourcent_sucres_portion_NR, salt = pourcent_sel_portion_NR) %>% as_tibble() %>% 
  filter(quantity !=0) %>% 
  filter(treatment == "NutriRepère") %>% as_tibble() 

ns <- ns %>% ungroup() %>% select(-treatment) %>% mutate(caddy = as.factor(as.character(caddy))) %>% group_by(caddy) %>% 
  gather(key, value, -subject, -product, -caddy, -quantity) 

#discretizing the GDA value
ns$value[ns$value == ""] <- 0
ns$value[ns$value == "<1"] <- 0
ns$value <- as.numeric(ns$value)
ns$value <- cut(ns$value, breaks = c(-1,5,10,15,20,25,30,40,50,60,70,80,90,1000), labels = c("<5","5-10","10-15",
                                                                                             "15-20","20-25","25-30",
                                                                                             "30-40","40-50","50-60",
                                                                                             "60-70","70-80","80-90",">90"))

ns <- ns %>% group_by(subject, caddy, key, value) %>% 
  summarise(n = sum(quantity)) %>% 
  spread(caddy,n)

ns$`2`[is.na(ns$`2`)]<-0
ns$`1`[is.na(ns$`1`)]<-0

ns <- ns %>% 
  mutate(diff = `2` - `1`) %>% 
  group_by(key, value) %>% 
  summarise(mdiff = mean(diff, na.rm = T), sediff = sd(diff, na.rm = T)/sqrt(n())) %>% 
  mutate(cil = mdiff-2*sediff, cih = mdiff + 2*sediff)


ns %>% ggplot(aes(value, mdiff))+geom_col(fill="grey70")+theme_minimal()+facet_grid(key~.)+
  geom_errorbar(aes(ymin = cil, ymax = cih), width = 0.1, color="grey40")+
  theme(strip.text = element_text(face = "bold"), legend.position = "none")+
  xlab("NutriRepère daily % intake, by nutrient")+ylab("Mean number of changes, caddy 2 vs caddy 1")+
  ggtitle("Mean number of product changes by NutriRepere % intake by subjects", 'By nutrient, NutriRepère treatment only')
ggsave("Behavioral_NR_individual.png", width = 8, height = 9, units = "in", dpi = 300)

## treating the variable as numeric

ns <- df %>% select(subject, caddy, treatment, product, quantity,
                    kcal = pourcent_kcal_portion_NR, fat = pourcent_lipides_portion_NR, sfa = pourcent_ags_portion_NR,
                    sugar = pourcent_sucres_portion_NR, salt = pourcent_sel_portion_NR) %>% as_tibble() %>% 
  filter(quantity !=0) %>% 
  filter(treatment == "NutriRepère") %>% as_tibble() 

ns <- ns %>% ungroup() %>% select(-treatment) %>% mutate(caddy = as.factor(as.character(caddy))) %>% group_by(caddy) %>% 
  gather(key, value, -subject, -product, -caddy, -quantity) 

#discretizing the GDA value
ns$value[ns$value == ""] <- 0
ns$value[ns$value == "<1"] <- 0
ns$value <- as.numeric(ns$value)

ns <- ns %>% group_by(subject, caddy, key) %>% 
  summarise(n = mean(value)) %>% 
  spread(caddy,n)


ns$`2`[is.na(ns$`2`)]<-0
ns$`1`[is.na(ns$`1`)]<-0

ns <- ns %>% 
  mutate(diff = `2` - `1`) %>% 
  group_by(key) %>% 
  summarise(mdiff = mean(diff, na.rm = T), sediff = sd(diff, na.rm = T)/sqrt(n())) %>% 
  mutate(cil = mdiff-2*sediff, cih = mdiff + 2*sediff)

ns %>% ggplot(aes(key, mdiff))+geom_col(fill="grey70")+theme_minimal()+
  geom_errorbar(aes(ymin = cil, ymax = cih), width = 0.1, color="grey40")+
  theme(strip.text = element_text(face = "bold"), legend.position = "none")+
  xlab("NutriRepère nutrients")+ylab("Mean % points change, caddy 2 vs caddy 1")+
  ggtitle("Mean number of %points changes by NutriRepere nutrient")
ggsave("Behavioral_NR_mean_by_nutrient.png",  width = 8, height = 5, units = "in", dpi = 300)
