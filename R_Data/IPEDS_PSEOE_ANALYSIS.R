

#NOTE: This was created to create a method of testing and evaluating datapoints in R using on the
  #IPEDS Dataset*. 

#This R Script was composed with intent of testing variables against each other*.

#*******************************************************************************.
#Step 1* Getting the Data*. 
#installing packages*.
install.packages("tidyverse")
install.packages("jsonlite")

#Reading in files***.
?read.csv()
PSEOE_INCOME_DF <- read.csv(file='pseoe_all.csv',check.names=F,stringsAsFactors = F)
IPEDS_DATA <- read.csv(file='hd2020.csv',check.names=F,stringsAsFactors = F)


#checking how R is interpreting data types*.
sapply(PSEOE_INCOME_DF,class)
sapply(IPEDS_DATA,class)


#*******************************************************************************.
#Step 2*.
#selecting the previously selected aggregate level*.
PSEOE_INCOME_DF_ADJV1 <- PSEOE_INCOME_DF[PSEOE_INCOME_DF$agg_level_pseo == 46,]


#viewing datafiles*.
glimpse(PSEOE_INCOME_DF_ADJV1)
nrow(PSEOE_INCOME_DF_ADJV1)

#dropping original files to avoid confusion*.
remove(PSEOE_INCOME_DF)


#*******************************************************************************.
#Step 3 
#dropping columns*.
PSEOE_INCOME_DF_ADJV2 = subset(PSEOE_INCOME_DF_ADJV1, select = -c(28:36))
glimpse(PSEOE_INCOME_DF_ADJV2)
remove(PSEOE_INCOME_DF_ADJV1)


#removing nulls on columns*.
#removing nulls on 1 year earnings since this is what is being used in this particular analysis*.
summary(PSEOE_INCOME_DF_ADJV2) #Total of 24428 NA values on the Y1 variables*.
nrow(PSEOE_INCOME_DF_ADJV2) #this is contrasted with a total of 55618 rows*.
PSEOE_INCOME_DF_ADJV3 <- na.omit(PSEOE_INCOME_DF_ADJV2,c("y1_p25_earnings"))
nrow(PSEOE_INCOME_DF_ADJV3) #this leaves about 10086 rows left*.
remove(PSEOE_INCOME_DF_ADJV2)

#*******************************************************************************.
#step 4 
#adjusting data for merger*.

summary(IPEDS_DATA)
summary(PSEOE_INCOME_DF_ADJV3)
glimpse(PSEOE_INCOME_DF_ADJV3)

IPEDS_DATAV2 <- IPEDS_DATA %>%
  rename(institution = OPEID)
remove(IPEDS_DATA)
summary(IPEDS_DATAV2)

IPEDS_DATAV2 <- transform(IPEDS_DATAV2,
                                   institution = as.numeric(institution))


PSEOE_INCOME_DF_ADJV3 <- transform(PSEOE_INCOME_DF_ADJV3,
                          institution = as.numeric(institution))


jointdataset <-
  merge(PSEOE_INCOME_DF_ADJV3,IPEDS_DATAV2, by = "institution", all.x=TRUE)

summary(jointdataset)




#*******************************************************************************.
#Step 5
#Creating visuals*.

#summary data visualizations*.
plt <- ggplot(jointdataset,aes(x=STABBR)) #import dataset into ggplot2
plt + geom_bar() #plot a bar plot
plt + geom_bar() + xlab("State") + ylab("Frequency") #plot bar plot with labels




#creating visual of how averages compare by state*. 
By_state <- jointdataset %>% group_by(STABBR) %>% summarize(AVG_Y1_Earnings=mean(y1_p50_earnings), .groups = 'keep') #create summary table
By_state
plt <- ggplot(By_state,aes(x=STABBR,y=AVG_Y1_Earnings)) #import dataset into ggplot2
plt + geom_col() #plot a bar plot
plt + geom_col() + xlab("State") + ylab("AVG 1YR Earnings") #plot bar plot with labels



#*******************************************************************************.
#Step 6
#Doing additional visual tests of normality*.

ggplot(jointdataset,aes(x=y1_p50_earnings)) + geom_density() #visualize distribution using density plot
ggplot(jointdataset,aes(x=SECTOR)) + geom_density() #visualize distribution using density plot
ggplot(jointdataset,aes(x=LOCALE)) + geom_density() #visualize distribution using density plot


#*******************************************************************************.
#Step 7.a
#Recoding data values for greater analysis*.

unique(jointdataset$LOCALE)
#NOTE all LOCALE are on a progression scale moving from urban to ruval*.

jointdataset <- transform(jointdataset,
                          LOCALE = as.character(LOCALE))
glimpse((jointdataset))

#converting values to continuous variable depending on urban to rural*.
#higher values indicate greate levels of rurality; lower values indicates urban*.
jointdataset$LOCALE <- recode(jointdataset$LOCALE, "11"="1", "12"="2", "13"="3",
                              "21"="4", "22"="5", "23"="6",
                              "31"="7", "32"="8", "33"="9",
                              "41"="10", "42"="11", "43"="12")

jointdataset <- transform(jointdataset,
                          LOCALE = as.numeric(LOCALE))
glimpse((jointdataset))
ggplot(jointdataset,aes(x=LOCALE)) + geom_density() #visualize distribution using density plot
lm(y1_p50_earnings ~ LOCALE,jointdataset) #create linear model


#Step 7.b
unique(jointdataset$HLOFFER)
#NOTE all LOCALE are on a progression scale moving from urban to ruval*.

jointdataset <- transform(jointdataset,
                          HLOFFER = as.character(HLOFFER))
glimpse((jointdataset))


#converting institution highest level degree offered*.
jointdataset$HLOFFER <- recode(jointdataset$HLOFFER, "1"="1", "2"="2", "3"="3",
                              "4"="4", "5"="5", "6"="6",
                              "7"="7", "8"="8", "9"="9")

jointdataset <- transform(jointdataset,
                          HLOFFER = as.numeric(HLOFFER))
glimpse((jointdataset))
ggplot(jointdataset,aes(x=HLOFFER)) + geom_density() #visualize distribution using density plot
lm(y1_p50_earnings ~ HLOFFER,jointdataset) #create linear model


#*******************************************************************************.
#step 9
#testing additional variables*.
#The below variables function as dummy variables* (1 vs 2 values

#this variable tests if uni offers ug level degrees*.
unique(jointdataset$UGOFFER)
#this variable tests if the uni offers GR level degrees*.
unique(jointdataset$GROFFER)
#this variable tests if uni is private or public*.
unique(jointdataset$CONTROL)
#this variable tests if uni is tribal designation*.

#unique(jointdataset$TRIBAL) - this was not included as there is no variation on data point*.

#this variable tests highest degree offered*
#NOTE: this variable was removed as being potentially already captured by other more defined dummy variables UGOFFER; GROFFER*.
#unique(jointdataset$HLOFFER)

#tests if uni  is part of a multi-institution or multi-campus organization*.
unique(jointdataset$F1SYSTYP)

#this variable tests the size of the university's class*. 
unique(jointdataset$C18SZSET)
#this variable is an alternative test of the uni size*.
unique(jointdataset$INSTSIZE)


#*******************************************************************************.
#Step 10
#recoding some variables as dummy variables*.

#recoding status of offering UG level degrees as '1' for yes*. 
Offers_UG_DEGREE <- ifelse(jointdataset$UGOFFER == 1,1,0)
#recoding status of offering GR level degrees as '1' for yes*. 
Offers_GR_DEGREE <- ifelse(jointdataset$GROFFER == 1,1,0)
#this variable tests if uni is private vs public as '1' for public*.
IS_PUBLILC_INST <- ifelse(jointdataset$CONTROL == 1,1,0)

#recoding multi institutional campus institution as '1' for year*.
  #first recoding '-2' (Not applicable) as null values in the column*.
F1SYSTYPV2 <- jointdataset %>% 
  mutate(F1SYSTYP = na_if(F1SYSTYP,-2))

unique(F1SYSTYPV2$F1SYSTYP)

IS_MULTI_CAMPUS <- ifelse(F1SYSTYPV2$F1SYSTYP == 1,1,0)

#removing temp dataframe from environment*.
remove(F1SYSTYPV2)

#*******************************************************************************.
#step 11
#converting items in ordinal variables within dataset*.

#recoding C18SZSET INFORMATION*.
#first recoding '-2' (Not applicable) as null values in the column*.

C18SZSETV2 <- jointdataset %>% 
  mutate(C18SZSET = na_if(C18SZSET,-2))
#testing outcome*
unique(C18SZSETV2$C18SZSET)
#removing all other columns*
C18SZSETV2 =C18SZSETV2[["C18SZSET"]]


#recoding INSTSIZE INFORMATION*.
#first recoding '-2' (Not applicable) as null values in the column*.

INSTSIZEV2 <- jointdataset %>% 
  mutate(INSTSIZE = na_if(INSTSIZE,-2))
#testing outcome*.
unique(INSTSIZEV2$INSTSIZE)
#removing all other columns*
INSTSIZEV2 =INSTSIZEV2[["INSTSIZE"]]


#*******************************************************************************.
#step 12
#creating data frame for regression analysis*. 

jointdataset_REG <- data.frame(LOCALE = jointdataset$LOCALE,
                               Offers_UG_DEGREE = Offers_UG_DEGREE,
                               Offers_GR_DEGREE = Offers_GR_DEGREE,
                               IS_PUBLILC_INST = IS_PUBLILC_INST,
                               IS_MULTI_CAMPUS = IS_MULTI_CAMPUS,
                               INST_SIZE = INSTSIZEV2,
                               INST_SET_CLASS = C18SZSETV2,
                               y1_p50_earnings=jointdataset$y1_p50_earnings)
                               
                               

glimpse(jointdataset_REG)



#*******************************************************************************.
#Step 11
#testing early version of broader regression analysis*.
lm(y1_p50_earnings ~ LOCALE + Offers_UG_DEGREE + Offers_GR_DEGREE + IS_PUBLILC_INST +INST_SET_CLASS +IS_MULTI_CAMPUS + INST_SIZE,data=jointdataset_REG) #generate multiple linear regression model

summary(lm(y1_p50_earnings ~ LOCALE + Offers_UG_DEGREE + Offers_GR_DEGREE + IS_PUBLILC_INST +INST_SET_CLASS +IS_MULTI_CAMPUS + INST_SIZE,data=jointdataset_REG)) #creating summary stats 








