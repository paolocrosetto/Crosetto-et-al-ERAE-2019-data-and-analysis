#### this file creates a table of common behavioral indicators
#### indicators that are common to all treatments

# dependencies
library(huxtable)

## 1. number of products in caddy 1, caddy 2, difference
bi <- df %>% select(subject, treatment, caddy, Nitem) %>% filter(treatment != "NutriScore, limité") %>% distinct() %>% as_tibble()

# 3 subjects have an empty caddy 1: taking them out
bi <- bi %>% filter(subject != 5251645) %>% filter(subject != 4984054) %>% filter(subject != 4963171)
  
bi <- bi %>% group_by(subject) %>% 
       spread(caddy, Nitem) %>% 
       mutate(diff = `2`-`1` ) %>% 
       filter(!is.na(`1`)) %>% 
       filter(!is.na(`2`)) %>% 
       group_by(treatment) %>% 
       summarise("mean # products, caddy 1" = mean(`1`,na.rm = T),
                 "mean # products, caddy 2" = mean(`2`,na.rm = T),
                 "st.dev, caddy 1" = sd(`1`), 
                 "st.dev, caddy 2" = sd(`2`), 
                 "difference" = mean(diff)) %>% 
       mutate_each(funs(round(.,1)), -treatment)

# formatting TODO
numprod <- bi %>% gather(var, val, -treatment) %>% spread(treatment, val)
  

## 2. number of product changes, caddy 2 vs caddy 1

chprod <- df %>% select(subject, treatment, caddy, code, category) %>%
  group_by(subject, caddy) %>% filter(treatment != "NutriScore, limité") %>% 
  arrange(code)%>%spread(caddy, caddy, fill = 1000) %>%
  filter(`1` == 1000 | `2` == 1000)


#creating entry-exit variable --> 
# - 'entry' means not in 1, new in 2
# - 'exit'  means it was in 1, no more in 2
chprod$change <- NA
chprod$change[chprod$`1` == 1000] <- 'entry'
chprod$change[chprod$`2` == 1000] <- 'exit'

chprod <- chprod %>% arrange(subject, `1`)

## computing average number of entry and exits by treatment
chprod <- chprod %>% group_by(subject, treatment, change) %>% summarise(nitem = n()) %>% 
                     spread(change, nitem, fill = 0) %>%  
                     group_by(treatment) %>% select(-subject) %>%
                     summarise_all(mean)

## formatting
chprod <- chprod %>% rename("mean number of new products" = entry, "mean number of removed products" = exit) %>% gather(var, val, -treatment) %>% spread(treatment, val)


## 3 number of clicks on nutrition and ingredients, by treatment and caddy

### analyzing the number of times subjects clicked on nutr, ingr, displayed items
track <- df %>% select(treatment, subject, caddy, Nnutr, Ningr) %>%
  filter(treatment != "NutriScore, limité") %>% 
  distinct() %>% filter(!is.na(Nnutr)) %>% filter(!is.na(Ningr)) %>% 
  group_by(treatment, caddy) %>%
  summarize( avgNnutr = sum(Nnutr)/n(), 
             avgNingr = sum(Ningr)/n()) 

#ingredients
ningr <- track %>% select(-avgNnutr) %>% spread(caddy, avgNingr) %>% mutate(diff = `2` - `1`, percdiff = 100*(`2` - `1`)/`1`)
#formatting
ningr <- ningr %>% rename("Average number of ingredeints views, caddy 1" = `1`, "Average number of ingredeints views, caddy 2" = `2`,
                 "Difference: absolute" = diff, "Difference: %" = percdiff) %>% gather(var, val, -treatment) %>% spread(treatment, val)


#nutrition
nnutr <- track %>% select(-avgNingr) %>% spread(caddy, avgNnutr) %>% mutate(diff = `2` - `1`, percdiff = 100*(`2` - `1`)/`1`)
#formatting
nnutr <- nnutr %>% rename("Average number of nutrition table views, caddy 1" = `1`, "Average number of nutrition table views, caddy 2" = `2`,
                 "Difference: absolute" = diff, "Difference: %" = percdiff) %>% gather(var, val, -treatment) %>% spread(treatment, val)

tab <- bind_rows(numprod, chprod, ningr, nnutr)

tab %>% write_csv("behavioral_table.csv")


### statistical testing

## N items preliminary
bi <- df %>% select(subject, treatment, caddy, Nitem) %>% filter(treatment != "NutriScore, limité") %>% distinct() %>% as_tibble()
bi <- bi %>% filter(!is.na(Nitem))
bi <- bi %>% group_by(subject) %>% spread(caddy, Nitem) %>% filter(!is.na(`1`)) %>% filter(!is.na(`2`))
bi <- bi %>% gather(caddy, Nitem, -subject, - treatment)

## basket 1: N across treatments
kruskal.test(Nitem~treatment, data = bi[bi$caddy==1,]) ### significant 0.01091
kruskal.test(Nitem~treatment, data = bi[bi$caddy==2,]) ### significant 0.00494
##what about if we single out the benchmark?
kruskal.test(Nitem~treatment, data = bi[bi$caddy==1 & bi$treatment != "Neutre",]) ### not significant, 0.372
kruskal.test(Nitem~treatment, data = bi[bi$caddy==2 & bi$treatment != "Neutre",]) ### not significant, 0.214

## basket 2: N across treatments

## by tratment: N2 vs N1
library(broom)
bi %>% group_by(treatment) %>% do(tidy(wilcox.test(.$Nitem~.$caddy, paired=T)))


## number of ingredeints views
Ningr <- df %>% select(treatment, subject, caddy, Ningr) %>%
  filter(treatment != "NutriScore, limité") %>% 
  distinct() %>% filter(!is.na(Ningr)) %>% filter(subject!=5251645) %>%  filter(subject != 4984054) %>% as_tibble()

#by treatment: N2 vs N1
Ningr %>% group_by(treatment) %>% do(tidy(wilcox.test(.$Ningr~.$caddy, paired=T)))

#making 'neutre' the base category
Ningr$treatment <- relevel(Ningr$treatment, "Neutre")

## alterantively: interacted regrssion
summary(lm(Ningr~treatment*caddy, data=Ningr))

## number of nutrition views
Nnutr <- df %>% select(treatment, subject, caddy, Nnutr) %>%
  filter(treatment != "NutriScore, limité") %>% 
  distinct() %>% filter(!is.na(Nnutr)) %>% filter(subject!=5251645) %>%  filter(subject != 4984054) %>% as_tibble()

#by treatment: N2 vs N1
Nnutr %>% group_by(treatment) %>% do(tidy(wilcox.test(.$Nnutr~.$caddy, paired=T)))

#making 'neutre' the base category
Nnutr$treatment <- relevel(Nnutr$treatment, "Neutre")


## agains neutre
Nnutr %>% group_by(subject, treatment) %>% spread(caddy, Nnutr) %>% mutate(diff = `2` - `1`) -> testme
testme %>% filter(treatment == "Neutre" | treatment == "SENS") %>%
  ungroup() %>% 
  mutate(treatment = as.character(treatment)) -> testme
wilcox.test(diff~treatment, data=testme)



## number of displayed items
Ndisp <- df %>% select(treatment, subject, caddy, Ndisp, Nproducts) %>%
  filter(treatment != "NutriScore, limité") %>% 
  distinct() %>% filter(!is.na(Ndisp)) %>% filter(subject!=5251645) %>%  filter(subject != 4984054) %>% as_tibble()

# displayed but not bought, in general
Ndisp %>% 
  mutate(notbought = Ndisp - Nproducts) %>% 
  group_by(treatment, caddy) %>% 
  summarise(nbmean = mean(notbought, na.rm = T)) %>% 
  spread(treatment, nbmean) %>% 
  xtable()

#by treatment: N2 vs N1
Ndisp %>% 
  mutate(notbought = Ndisp - Nproducts) %>% 
  group_by(treatment) %>% 
  do(tidy(wilcox.test(.$notbought~.$caddy, paired=T))) 

### what is the score FSA of the items displayed but not bought vs the one of items bought?
sub_treat <- df %>% 
             select(subject, treatment) %>% 
             filter(treatment != "NutriScore, limité") %>% 
             distinct()

alldata$disp[is.na(alldata$disp)] <- 0
alldata %>% 
  as_tibble() %>% 
  filter(subject != 5924054) %>% 
  filter(subject != 5407546 & subject!= 5044054 & subject != 5091645) %>% 
  select(subject, caddy, disp, bought, scoreFSA) %>% 
  left_join(sub_treat, by = "subject")  %>% 
  filter(!is.na(treatment)) %>% 
  filter(treatment != "NSRL") %>% 
  filter(disp == 1) -> dispbought

dispbought %>% 
  group_by(treatment, caddy, disp, bought) %>% 
  summarise(meanfsa = mean(scoreFSA, na.rm = T)) %>% 
  arrange(treatment, caddy, disp, bought) -> dispboughtmeans
  
