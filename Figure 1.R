###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Figure 1 of the paper

## NOTE
## the produced plot differs from the paper version in appearance
## this is to limit dependencies on external packages
## to reproduce exaclty the same plot as in the paper uncomment the final lines
## final theme depends on devtools and hrbrthemes being installed


# getting individual indicator of nutritional performance (FSA/calories for the whole basket)
indicator <-  df %>% 
  ungroup() %>% 
  group_by(treatment, subject, caddy) %>% 
  summarise(indicator = (sum(FSAKcal))/sum(actual_Kcal))

# computing difference between first and second basket
indicator <- indicator %>% 
  spread(caddy, indicator) %>% 
  mutate(diff = (`2`-`1`)) %>% 
  select(treatment, subject, FSA1 = `1`, FSA2 = `2`, diff)


# summarizing data to be ready for plotting
summary <- indicator %>% 
  group_by(treatment) %>%
  summarise(diffsem = sd(diff, na.rm = TRUE)/sqrt(n()),
            diff = round(mean(diff, na.rm = TRUE),2)) %>% 
  mutate(cil = diff-2*diffsem, cih = diff + 2*diffsem) %>% 
  mutate(label = treatment != "Benchmark") %>% 
  group_by(label) %>% 
  mutate(avgeff = case_when(
              label == T ~  mean(diff),
              label == F ~  NA_real_))

# Figure 1 -- without advanced theming
fig1 <- summary %>%
  ggplot() + 
  geom_errorbar(aes(x = reorder(treatment, -diff), ymin = cil, ymax = cih, group= reorder(treatment,-diff)), size=0.8, width = 0.1, position = position_dodge(width = 0.07))+
  geom_point(aes(reorder(treatment, -diff), diff, fill=reorder(treatment,-diff)), position = position_dodge(width = 0.07), size=8, pch=21)+
  coord_flip()+
  theme_minimal()+
  geom_hline(yintercept = 0, color="indianred")+
  geom_hline(aes(yintercept = avgeff),  linetype = "dashed", color="grey50")+
  scale_fill_manual(values = rev(c("#00B050","grey10", "#E0270B", "#ffd042", "skyblue", "grey78")), name = "")+
  xlab("")+
  ylab("Mean and 95% c.i. - absolute FSA score difference, basket 2 vs 1")+
  theme(legend.position = "none")+
  annotate(geom = "text", x = 6.35, y = -1.55+0.05, label = "average label effect", hjust=0)+
  annotate(geom = "text", x = 6.35, y = 0.05, label = "no effect", hjust=0, color = "indianred")
fig1
ggsave("Figures/Figure_1.png", width = 9, height = 4, units = "in", dpi = 300)

## with the final theme
#library(devtools)
#devtools::install_github("hrbrmstr/hrbrthemes")
#library(hrbrthemes)
#fig1 + theme_ipsum_rc()+theme(legend.position = "none")

## cleaning up
rm(fig1, indicator, summary)
