###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Figure 3a of the paper -- the plot on the top left corner of Figure 3

## selecting relevant variables and rows
ns <- df %>% 
  select(subject, caddy, treatment, product, quantity, couleur_NS) %>% 
  filter(quantity !=0) %>% 
  filter(treatment == "NutriScore")

## creating the number of products of each category for each color
ns <- ns %>% 
  mutate(caddy = as.factor(as.character(caddy))) %>% 
  select(-treatment) %>%
  group_by(subject, caddy, couleur_NS) %>% 
  summarise(n = sum(quantity)) %>% 
  ungroup() %>% 
  spread(caddy,n, fill = 0) 

## compute difference variable and translate colors
ns <- ns %>%   mutate(diff = `2` - `1`) %>% 
  mutate(couleur_NS = fct_recode(couleur_NS, "red" = "Rouge", "orange" = "Orange", "yellow" = "Jaune", "light green" = "Vert clair", "dark green" = "Vert foncé"),
         couleur_NS = fct_relevel(couleur_NS, "red", "orange", "yellow", "light green", "dark green")) %>% 
  group_by(couleur_NS) 

## compute mean and confidence interval of change by color over subjects
ns <- ns %>% 
  summarise(mdiff = mean(diff, na.rm = T), sediff = sd(diff, na.rm = T)/sqrt(n())) %>% 
  mutate(cil = mdiff-2*sediff, cih = mdiff + 2*sediff)
   

## plotting -- Figure 3a, behavioral changes with NutriScore
fig3 <- ns %>% ggplot(aes(couleur_NS, mdiff, fill=couleur_NS))+geom_col()+
  geom_errorbar(aes(ymin = cil, ymax = cih), width = 0.1, color="grey40")+
  theme_minimal()+
  scale_fill_manual(name="", values = colors5C <- rev(c("#018241", "#86BC30", "#FFCC01", "#F18101", "#E73F12")))+
  theme(legend.position = "none")+xlab("NutriScore label color")+ylab("Mean number of changes, caddy 2 vs caddy 1")+
  ggtitle("Mean number of product changes by NutriScore label color, by subject")
fig3
ggsave("Figures/Figure 3a.png", width = 8, height = 5, units = "in", dpi = 300)

