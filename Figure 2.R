###
### Crosetto, Lacroix, Muller, Ruffieux


### This file produces Figure 2 of the paper

## NOTE
## the produced plot differs from the paper version in appearance
## this is to limit dependencies on external packages
## to reproduce exaclty the same plot as in the paper uncomment the final lines
## final theme depends on devtools and hrbrthemes being installed


# getting individual indicator of nutritional performance (FSA/calories for the whole basket)
ind <-  df %>% 
  ungroup() %>% 
  group_by(treatment, subject, caddy) %>% 
  summarise(indicator = (sum(FSAKcal))/sum(actual_Kcal))

# computing difference between first and second basket
ind <- ind %>% 
  spread(caddy, indicator) %>% 
  mutate(diff = (`2`-`1`)) %>% 
  select(treatment, subject, FSA1 = `1`, FSA2 = `2`, diff)

## TODO: rename neutre -- benchmark in the source data and then delete this
ndf <- ind %>% filter(treatment != "NutriScore, limité" & !is.na(diff)) %>% 
  ungroup() %>% 
  mutate(treatment = fct_recode(treatment, "Benchmark" = "Neutre")) 

## Figure 2
fig2 <- ndf %>%
  ggplot(aes(reorder(treatment,diff), diff, color=treatment)) +
  geom_boxplot(alpha = 1)+
  geom_jitter(height = 0, width = 0.3, alpha = 0.5)+
  theme_minimal()+
  geom_hline(yintercept = 0, color = 'indianred', linetype = 'dashed')+
  theme(legend.position = "none")+
  ylab("Absolute FSA score difference, basket 2 vs 1")+
  xlab("")+
  scale_color_manual(values = c("#00B050","#E0270B", "skyblue", "grey10", "#ffd042", "grey78"), name = "")
fig2
ggsave("Crosetto_et_al_ERAE2019_Figure_2.png", width = 8, height = 6, units = "in", dpi = 300)    


## with the final theme
#library(devtools)
#devtools::install_github("hrbrmstr/hrbrthemes")
#library(hrbrthemes)
#fig2 + theme_ipsum_rc()+theme(legend.position = "none")

        