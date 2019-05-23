 
### manually fill the data according to changes recorded in the cahiers du labo

df$profession[df$subject == 5032372] <- "Employés"

df <- df %>% filter(subject != 5409478)

df$children[df$subject == 4983569] <- 3
df$children[df$subject == 4989478] <- 2


### TODO add this data!
setwd("~/Dropbox/Grenoble/Projects/Label4/09 - données/Analysis/Donnees manuelles/")
library(readxl)

s1 <- read_excel('4963171_caddy1.xlsx')
s2 <- read_excel('4984054_caddy1.xlsx')
s3 <- read_excel('5176550_caddy1.xlsx')
s4 <- read_excel('5215701_caddy2.xlsx')
s5 <- read_excel('5251645_caddy1.xlsx')
s6 <- read_excel('5924054_caddy1.xlsx')

gaelFSA <- read.csv(file = "2017-01-17_Score_FSA_Gael.csv", sep = ";")

manual <- rbind(s1,s2,s3,s4,s5,s6)
manual$subject<-as.numeric(manual$subject)
rm(s1,s2,s3,s4,s5,s6)
manual$bought <- 1

addedsubjects <- manual %>% select(subject) %>% distinct()
addedsubjects <- addedsubjects$subject

###finding all needed subject variables from df
subjvar <- df %>% filter(subject %in% addedsubjects) %>% select(subject, treatment, date, personal_weight, session, occupation, profession, education,
                                                                age, familysize, children, height, shopping, familytype, income, female, easy, helps,
                                                                influences, precise, reassuring, betterdiet, betterhealth, justadv, useful, helpschoice,
                                                                givesnutrinfo,givesliminfo) %>% distinct()

### product data 
setwd("~/Dropbox/Grenoble/Projects/Label4/09 - données/Données Brutes XP/")
products <- read.csv("base_sortie_tel_que_ecran.csv", sep=';') %>% select(code = code_barre, everything())
scoreFSA <- read.csv("base_entree_donnees_completes.csv", sep=';') %>% select(code = Code_Barre, scoreFSA = score)
setwd("~/Dropbox/Grenoble/Projects/Label4/09 - données/Analysis/")

manual <- left_join(manual, products, by="code")
manual <- left_join(manual, scoreFSA, by="code")

rm(products)
rm(scoreFSA)

### joining with other variables
manual <- left_join(manual, subjvar, by="subject")

rm(addedsubjects)
rm(subjvar)

##filling with NAs
manual$disp <- NA
manual$ingr <- NA
manual$nutr <- NA
manual$remo <- NA
manual$Nproducts <- NA
manual$Nitem <- NA
manual$Ndisp <- NA
manual$Ningr <- NA
manual$Nnutr <- NA
manual$Nremo <- NA

#merging 
df <- rbind(df,manual)
rm(manual)

###adding score FSA computed by GAEL -- meant to replace the one we have, that will be called FSAJulia
gaelFSA <- gaelFSA %>% select(code = Code_Barre, FSAgael = score_FSA_gael)
df <- left_join(df,gaelFSA,by="code")
