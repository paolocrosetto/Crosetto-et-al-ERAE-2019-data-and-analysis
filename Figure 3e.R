# !diagnostics off
######################################
# behavioral analysis of NutriScore  #
######################################


## TODO: code cleaning and commenting

ns <- df %>% select(subject, caddy, treatment, product, quantity,
                    kcal = pourcent_kcal_portion_NR, fat = pourcent_lipides_portion_NR, sfa = pourcent_ags_portion_NR,
                    sugar = pourcent_sucres_portion_NR, salt = pourcent_sel_portion_NR) %>% 
  as_tibble() %>% 
  filter(quantity !=0) %>% 
  filter(treatment == "NutriRepère")

ns <- ns %>% 
  ungroup() %>% 
  select(-treatment) %>% 
  mutate(caddy = as.factor(as.character(caddy))) %>% 
  group_by(caddy) %>% 
  gather(key, value, -subject, -product, -caddy, -quantity) 

## taking care of the values -- transfomr into numeric, take care of NA and '<1'
ns <- ns %>% 
  mutate(value = case_when(
                   value == "<1" ~ 0,
                   is.na(value) ~0,
                   TRUE ~ as.numeric(value)))


ns <- ns %>% group_by(subject, caddy, key) %>% 
  summarise(n = mean(value)) %>% 
  spread(caddy,n, fill = 0)


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
ggsave("Figures/Figure_3e.png",  width = 8, height = 5, units = "in", dpi = 300)
