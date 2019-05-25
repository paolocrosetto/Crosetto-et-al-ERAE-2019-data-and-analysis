###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Figure 3d of the paper -- the plot on the top third row of Figure 3

## TODO: fix colors, update and comment code

ns <- df %>% select(subject, caddy, treatment, product, quantity, "saturated fatty acids" = couleur_ags_NC, sugar = couleur_sucres_NC, salt = couleur_sel_NC) %>% 
  filter(quantity !=0) %>% 
  filter(treatment == "NutriScore") %>% as_tibble() 


ns <- ns %>% ungroup() %>% select(-treatment) %>% mutate(caddy = as.factor(as.character(caddy))) %>% group_by(caddy) %>% 
  gather(key, value, -subject, -product, -caddy, -quantity) %>% group_by(subject, caddy, key, value) %>% 
  summarise(n = sum(quantity))


ns$value[ns$value == ""] <- "No label"


ns <- ns %>% spread(caddy,n)

ns$`2`[is.na(ns$`2`)]<-0
ns$`1`[is.na(ns$`1`)]<-0

ns <- ns %>%  mutate(diff = `2` - `1`) %>% 
  group_by(key, value) %>% 
  summarise(mdiff = mean(diff, na.rm = T), sediff = sd(diff, na.rm = T)/sqrt(n())) %>% 
  mutate(cil = mdiff-2*sediff, cih = mdiff + 2*sediff) %>% 
  mutate(value = as.factor(value)) %>% 
  mutate(value = fct_recode(value, "red" = "rouge", "green" = "vert", "no label" = "No label")) %>% 
  mutate(value = fct_relevel(value, "no label", "red", "orange"))

ns %>% ggplot(aes(value, mdiff, fill=value))+geom_col()+theme_minimal()+facet_grid(.~key)+
       geom_errorbar(aes(ymin = cil, ymax = cih), width = 0.1, color="grey40")+
       scale_fill_manual(name="", values = c("grey50", "#ef3340", "#f1b434", "#97d700"))+
       theme(strip.text = element_text(face = "bold"), legend.position = "none")+
       xlab("NutriCouleur color, by nutrient")+ylab("Mean number of changes, caddy 2 vs caddy 1")+
       ggtitle("Mean number of product changes by NutriCouleur label color, by subjects and nutrient")
ggsave("Behavioral_NC_individual.png", width = 8, height = 5, units = "in", dpi = 300)

