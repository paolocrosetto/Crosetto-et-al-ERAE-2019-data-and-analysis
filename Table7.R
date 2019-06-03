###
### Crosetto, Lacroix, Muller, Ruffieux
### ERAE 2019
### Nutritional and economic impact of 5 alternative front-of-pack nutritional labels: experimental evidence
###

### This file produces Table 7 of the paper

## NOTE
## the produced table differs from the paper version in appearance
## this is because the final table was tweaked by hand to make it more compact and readable

## Table 8 is composed of 4 subtables: number of products, product changes, ingredient and nutrition views.
## each part is created indipendently and then the parts are pasted together before writing to file
## tests were run separately and added manually to the table


#### Part 1: creating the table (without statistical tests)

## 1. number of products in each shopping basket and difference
bi <- df %>% 
  select(subject, treatment, caddy, Nitem) %>% 
  distinct()

# 3 subjects have an empty basket 1 -- removing them
bi <- bi %>% 
  filter(subject != 5251645) %>% 
  filter(subject != 4984054) %>% 
  filter(subject != 4963171)
  
# computing difference variable and means
bi <- bi %>% group_by(subject) %>% 
       spread(caddy, Nitem) %>% 
       mutate(diff = `2`-`1` ) %>% 
       filter(!is.na(`1`)) %>% 
       filter(!is.na(`2`)) %>% 
       group_by(treatment) %>% 
       summarise("mean # products, caddy 1" = mean(`1`,na.rm = T),
                 "mean # products, caddy 2" = mean(`2`,na.rm = T),
                 "difference" = mean(diff)) %>% 
       mutate_each(funs(round(.,1)), -treatment)

# formatting as a wide table to later paste all the indicators together
numprod <- bi %>% gather(var, val, -treatment) %>% spread(treatment, val)
  
# cleanup
rm(bi)


## 2. number of product changes, caddy 2 vs caddy 1

# identifying entries and exits by reshaping the dataset
chprod <- df %>% 
  select(subject, treatment, caddy, code) %>%
  group_by(subject, caddy) %>% 
  arrange(code)%>%
  spread(caddy, caddy, fill = 1000) %>%
  filter(`1` == 1000 | `2` == 1000)


#creating entry-exit variable --> 
# - 'entry' means not in 1, new in 2
# - 'exit'  means it was in 1, no more in 2
chprod <- chprod %>% 
  mutate(change = case_when(`1` == 1000 ~ "entry",
                            `2` == 1000 ~ "exit"))


## computing average number of entry and exits by treatment
chprod <- chprod %>% 
  group_by(subject, treatment, change) %>% 
  summarise(nitem = n()) %>% 
  spread(change, nitem, fill = 0) %>%  
  group_by(treatment) %>% 
  select(-subject) %>%
  summarise_all(mean) %>% 
  mutate_each(funs(round(.,2)), -treatment)

## formatting as a wide table to later paste all the indicators together
chprod <- chprod %>% 
  rename("mean entry" = entry, "mean exit" = exit) %>% 
  gather(var, val, -treatment) %>% 
  spread(treatment, val)


## 3 number of clicks on nutrition and ingredients, by treatment and caddy

# analyzing the number of times subjects clicked on nutr, ingr, displayed items
track <- df %>% 
  select(treatment, subject, caddy, Nnutr, Ningr) %>%
  distinct() %>% 
  filter(!is.na(Nnutr)) %>% 
  filter(!is.na(Ningr)) %>% 
  group_by(treatment, caddy) %>%
  summarize( avgNnutr = sum(Nnutr)/n(), 
             avgNingr = sum(Ningr)/n()) 

# ingredient views table: indicators
ningr <- track %>% 
  select(-avgNnutr) %>% 
  spread(caddy, avgNingr) %>% 
  mutate(percdiff = 100*(`2` - `1`)/`1`) %>% 
  ungroup() %>% 
  mutate_if(.predicate = is.numeric, funs(round(.,2)))

# ingredients view table: formatting
ningr <- ningr %>% 
  rename("Average number of ingredeints views, Basket 1" = `1`, 
         "Average number of ingredeints views, Basket 2" = `2`,
         "% difference" = percdiff) %>% 
  gather(var, val, -treatment) %>% 
  spread(treatment, val)


# nutrition view table: indicator
nnutr <- track %>% 
  select(-avgNingr) %>% 
  spread(caddy, avgNnutr) %>% 
  mutate(percdiff = 100*(`2` - `1`)/`1`)  %>% 
  ungroup() %>% 
  mutate_if(.predicate = is.numeric, funs(round(.,2)))

# nutrition views table: formatting
nnutr <- nnutr %>% 
  rename("Average number of nutrition table views, Basket 1" = `1`, 
         "Average number of nutrition table views, Besket 2" = `2`,
         "% difference" = percdiff) %>% 
  gather(var, val, -treatment) %>% 
  spread(treatment, val)

## Binding together the four tables and exporting

bind_rows(numprod, chprod, ningr, nnutr) %>% 
  write_csv("Tables/Table7.csv")

# Cleanup
rm(ningr, nnutr, numprod, chprod, track)



#### Part 2: Statistical tests


## Number of products

# creating the dataset
nprod <- df %>% 
  select(subject, treatment, caddy, Nitem) %>% 
  distinct() %>% 
  filter(!is.na(Nitem)) %>% 
  group_by(subject) %>% 
  spread(caddy, Nitem) %>% 
  filter(!is.na(`1`)) %>% filter(!is.na(`2`)) %>% 
  gather(caddy, Nitem, -subject, - treatment)


# for each treatment, test if there is significant difference across caddies
nprod <- nprod %>% 
  group_by(treatment) %>% 
  do(tidy(wilcox.test(.$Nitem~.$caddy, paired=T))) %>% 
  select(treatment, p.value) %>% 
  mutate(test = "WSRT nprod") 
  


## number of ingredeints views

# dataset
ningr <- df %>% 
  select(treatment, subject, caddy, Ningr) %>%
  distinct() %>% 
  filter(!is.na(Ningr)) %>% 
  filter(subject!=5251645) %>%  filter(subject != 4984054)

# for each treatment, test if there is significant difference across caddies
ningr <- ningr %>% 
  group_by(treatment) %>% 
  do(tidy(wilcox.test(.$Ningr~.$caddy, paired=T))) %>% 
  select(treatment, p.value) %>% 
  mutate(test = "WSRT nviews")


## number of nutrition views
nnutr <- df %>% 
  select(treatment, subject, caddy, Nnutr) %>%
  distinct() %>% 
  filter(!is.na(Nnutr)) %>% 
  filter(subject!=5251645) %>%  filter(subject != 4984054) 

# for each treatment, test if there is significant difference across caddies
nnutr <- nnutr %>% group_by(treatment) %>%
  do(tidy(wilcox.test(.$Nnutr~.$caddy, paired=T)))%>% 
  select(treatment, p.value) %>% 
  mutate(test = "WSRT nnutr")


## putting it all together
rbind(nprod, nnutr, ningr) %>% 
  write_csv("Tables/Table7_tests.csv")

## cleanup
rm(nprod, nnutr, ningr)