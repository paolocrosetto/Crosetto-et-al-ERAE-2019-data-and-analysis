###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Figure 3c of the paper -- the plot about NutriMark on the second row of Figure 3

## TODO: clean code to make it consistent with the rest

## selecting relevant variables and rows
ns <- df %>% select(subject, caddy, treatment, product, quantity, star_NM) %>% 
  filter(quantity !=0) %>% 
  filter(treatment == "NutriMark")

## organize data acording to the number of stars
ns <- ns %>% mutate(caddy = as.factor(as.character(caddy))) %>% 
  select(-treatment) %>%
  group_by(subject, caddy, star_NM) %>% 
  summarise(n = sum(quantity)) %>% 
  ungroup() %>% 
  spread(caddy,n, fill = 0) %>% 
  mutate(star_NM = star_NM/10)%>% 
  mutate(star_NM = as.character(star_NM)) 

## fixing the 'no label' products
ns$star_NM[is.na(ns$star_NM)] <- "No label"

## creating difference variable and summarising
ns <- ns %>%   mutate(diff = `2` - `1`) %>% 
  group_by(star_NM) %>% 
  summarise(mdiff = mean(diff, na.rm = T), sediff = sd(diff, na.rm = T)/sqrt(n())) %>% 
  mutate(cil = mdiff-2*sediff, cih = mdiff + 2*sediff)

## format of the factor variable
ns <- ns %>% mutate(star_NM = as.factor(star_NM), star_NM = fct_relevel(star_NM, "No label"))
   

## plotting -- Figure 3c NutriMark
ns %>% filter(star_NM != "No label") %>% ggplot(aes(star_NM, mdiff, fill=star_NM))+geom_col()+
  geom_errorbar(aes(ymin = cil, ymax = cih), width = 0.1, color="grey40")+
  theme_minimal()+
   scale_fill_manual(name="", values=c(rep("black",11)))+
  theme(legend.position = "none")+xlab("NutriMark number of stars")+ylab("Mean number of changes, caddy 2 vs caddy 1")+
  ggtitle("Absolute number of product changes by NutriMark stars, by subject")
ggsave("Figures/Figure_3c.png", width = 8, height = 5, units = "in", dpi = 300)

