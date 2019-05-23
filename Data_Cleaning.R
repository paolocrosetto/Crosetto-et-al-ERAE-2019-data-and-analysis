### cleaning the data ###


#### dropping subjects 


#rules: 
# 1. all subjects having submitted at least one caddy with 0 items are dropped
# 2. ???
##

##cleaning
df <- df %>% select(-ingredient)

#######################################
### Plot settings ###
#######################################
library(forcats)
## correct order of factors
df <- df %>% mutate(treatment = fct_relevel(treatment, c("NS","NSRL","NC","NR","NM","SENS","neutral"))) %>% 
  mutate(treatment = fct_recode(treatment,
  "NutriScore" = "NS",
  "NutriScore, limité" = "NSRL",
  "NutriCouleur" = "NC",
  "NutriRepère" = "NR",
  "NutriMark" = "NM",
  "SENS" = "SENS",
  "Neutre" = "neutral"))
treatcol <- c("chartreuse4","green","orange1","skyblue", "black", "darkviolet", "grey65")
treatment <- levels(df$treatment)
colors <- as.data.frame(cbind(treatment,treatcol))
rm(treatment)
colors <- colors %>% mutate(treatment = fct_relevel(treatment,
                                                    c("NutriScore","NutriScore, limité","NutriCouleur",
                                                      "NutriRepère","NutriMark","SENS","Neutre")))
df <- left_join(df,colors, by="treatment")

rm(colors)


#######################################
#### Nutritional data updating
#######################################

### score starts at -12. Does nt make sense for differences...
### how to solve this? 
### formula taken form the proposer of scoreFSA
### fsa_new = -2*fsa_old + 70

##replacing score with FSAgael
df <- df %>% rename(FSAJulia = scoreFSA, scoreFSA = FSAgael)
# df$scoreFSA <- -2*(df$scoreFSA) +70
#df$FSAJulia <- -2*(df$FSAJulia) +70

### COMPUTING LIM ###
#######################################
# 
# # lim 1/3 * [AGS100g/22]*100 + [Sucre100g/50]*100 + [Sel100g/8]*100
# # NB:it would be 3.153 if we had Sodium data; we just have NaCl, so we use 8grams
# 
df$LIM <- ((df$ags_100/22)*100 + (df$sucres_100/50)*100 + (df$sel_100/8)*100)/3
#LIM is multiplied 2.5x for sodas
df$LIM[df$category=="Sodas"] <- 2.5*df$LIM[df$category=="Sodas"]
t

# #######################################
# ### refactoring category  ###
# #######################################
# 
familylevels <- c("Snacks&Sweets", "Snacks&Sweets", "Fruits",
                  "Dairies", "Cereals&Potatoes", "Snacks&Sweets",
                  "Dairies", "Dairies", "Fruits",
                  "Dairies", "Dairies", "Fruits",
                  "Meat&Fish&Eggs", "Fruits", "Fruits",
                  "Dairies", "Vegetables", "Vegetables",
                  "Vegetables", "Meat&Fish&Eggs", "Cereals&Potatoes",
                  "Cereals&Potatoes", "Meat&Fish&Eggs", "MixedDishes",
                  "MixedDishes", "MixedDishes", "MixedDishes",
                  "Meat&Fish&Eggs", "Cereals&Potatoes", "Snacks&Sweets",
                  "Dairies", "Vegetables", "MixedDishes",
                  "Snacks&Sweets", "Snacks&Sweets", "MixedDishes",
                  "MixedDishes", "Meat&Fish&Eggs", "Snacks&Sweets")

levels(df$category)<- familylevels
rm(familylevels)

# #######################################
# ### refactoring demographic variables  ###
# #######################################
df <- df %>% mutate(income2 = fct_recode(income, NULL = "", lower = "0_1000", lower = "1000_2000",
                                         middle = "2000_3000", higher = "3000_4000", higher = "4000_5000",
                                         higher = "5000_6000", higher = "6000_7000", higher = "8000_plus",
                                         higher = "7000_8000"))



######### weight and other units


# weight is sometimes in Kg, sometimes in g; sometimes in cl, sometimes 'pièce'. Solving the issues.
# packs of coke have a multiplication notation for weight
levels(df$weight)[levels(df$weight)=="8*25"]<- "200"
levels(df$weight)[levels(df$weight)=="15*25"]<- "375"
levels(df$weight)[levels(df$weight)=="12*15"]<- "180"
levels(df$weight)[levels(df$weight)=="2*25"]<- "50"
levels(df$weight)[levels(df$weight)=="3*20"]<- "60"

## solving problems with products sold per unit
df$weight[df$product == "Concombre"] <- 200
df$weight[df$product == "Kiwi"] <- 100
df$weight[df$product == "Avocat"] <- 300

## eggs
df$weight[df$product == "6 Gros oeufs"] <- 72
df$weight[df$product == "6 Gros oeufs plein air"] <- 72
df$weight[df$product == "6 Oeufs bio fermiers"] <- 60


#converting factor to numeric
df$weight <- as.numeric(as.character(df$weight))

#unit conversion
df$weight[df$unit_weight == "kg"]<- df$weight[df$unit_weight == "kg"]*1000
df$weight[df$unit_weight == "L"]<- df$weight[df$unit_weight == "L"]*1000
df$weight[df$unit_weight == "cL"]<- df$weight[df$unit_weight == "cL"]*10
df$weight[df$unit_weight == "cl"]<- df$weight[df$unit_weight == "cl"]*10
df$weight[df$unit_weight == "ml"]<- df$weight[df$unit_weight == "ml"]

#recode unit variable
levels(df$unit_weight)[levels(df$unit_weight)=='cL']<-'ml'
levels(df$unit_weight)[levels(df$unit_weight)=='cl']<-'ml'
levels(df$unit_weight)[levels(df$unit_weight)=='kg']<-'g'
levels(df$unit_weight)[levels(df$unit_weight)=='L']<-'ml'
levels(df$unit_weight)[levels(df$unit_weight)=='ml']<-'ml'
levels(df$unit_weight)[levels(df$unit_weight)=='pièce']<-'g'
levels(df$unit_weight)[levels(df$unit_weight)=='pièces']<-'g'


### adding weighted variables
#actual weight & price
df <- df %>% mutate(actual_weight = weight*quantity,
                    actual_price = price*quantity)



#computing indicators for Kcal, Salt, Sugar, AGS
df <- df %>%           mutate(actual_Kcal  = (kcal_100/100)*actual_weight,
                              actual_Salt  = (sel_100/100)*actual_weight ,
                              actual_Sugar = (sucres_100/100)*actual_weight,
                              actual_AGS   = (ags_100/100)*actual_weight,
                              actual_Score = (scoreFSA/100)*actual_weight,
                              actual_Protein = (proteines_100/100)*actual_weight,
                              actual_Fibres = (fibres_100/100)*actual_weight,
                              actual_lipides = (lipides_100/100)*actual_weight,
                              actual_glucides = (glucides_100/100)*actual_weight)

df <- df %>% mutate(Price_100g = price_kg_l/10)

##dropping some unneeded variables
df <- df %>% select(-prix, -unit_price, -unit_price_kg_l, -bought, -Id_remise_CB_ap_algo)

#### main indicator
##compute the indicators
#FSA
df <- df %>% mutate(FSAKcal = scoreFSA * actual_Kcal)

#LIM
df <- df %>% mutate(LIMKcal = LIM * actual_Kcal)

#weight
df <- df %>% mutate(FSAgram = scoreFSA * actual_weight)


### age bug
# for some reasons "age" is listed as "age-18 on Gaelexperience. 
# the infile corrects this adding +13; so here we further add +5 in order not to have to re-run the infile script.
df$age <- df$age + 5

###getting rid of one subject that had one product in caddy 1 and 12 in caddy 2
df <- df %>% filter(subject != 5924054)

###getting rid of three subjects that have just one fo the two caddies
df <- df %>% filter(subject != 5407546 & subject!= 5044054 & subject != 5091645)
