###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Figure 3d of the paper -- the plot on the top third row of Figure 3

## TODO: change image in the file to be identical to this one!

## selecting the relevant variables and rows
ns <- df %>% select(subject, caddy, treatment, product, quantity, 
                    "saturated fatty acids" = couleur_ags_NC, 
                    sugar = couleur_sucres_NC, 
                    salt = couleur_sel_NC) %>% 
  filter(quantity !=0) %>% 
  filter(treatment == "NutriScore") %>% 
  as_tibble() 

## counting the number of products of each color for each nutrient of the Traffic Light
ns <- ns %>% 
  ungroup() %>% 
  select(-treatment) %>% 
  mutate(caddy = as.factor(as.character(caddy))) %>% 
  group_by(caddy) %>% 
  gather(key, value, -subject, -product, -caddy, -quantity) %>% 
  group_by(subject, caddy, key, value) %>% 
  summarise(n = sum(quantity))

## dealing with unlabeled products
ns <- ns %>% mutate(value = if_else(is.na(value), "no label", value))

## compute difference varibale for each nutrient and summairze to mean and confidence interval
ns <- ns %>% 
  spread(caddy,n, fill = 0) %>% 
  mutate(diff = `2` - `1`) %>% 
  group_by(key, value) %>% 
  summarise(mdiff = mean(diff, na.rm = T), sediff = sd(diff, na.rm = T)/sqrt(n())) %>% 
  mutate(cil = mdiff-2*sediff, cih = mdiff + 2*sediff) %>% 
  mutate(value = as.factor(value)) %>% 
  mutate(value = fct_recode(value, "red" = "rouge", "green" = "vert")) %>% 
  mutate(value = fct_relevel(value, "no label", "red", "orange"))


## plotting -- Figure 3d NutriCouleur
ns %>% ggplot(aes(value, mdiff, fill=value))+geom_col()+theme_minimal()+facet_grid(.~key)+
       geom_errorbar(aes(ymin = cil, ymax = cih), width = 0.1, color="grey40")+
       scale_fill_manual(name="", values = c("grey50", "#ef3340", "#f1b434", "#97d700"))+
       theme(strip.text = element_text(face = "bold"), legend.position = "none")+
       xlab("NutriCouleur color, by nutrient")+ylab("Mean number of changes, caddy 2 vs caddy 1")+
       ggtitle("Mean number of product changes by NutriCouleur label color, by subjects and nutrient")
ggsave("Figure_3d.png", width = 8, height = 5, units = "in", dpi = 300)

