

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
#this variable tests highest degree offered*.
unique(jointdataset$HLOFFER)
#this variable tests the size of the university's class*. 
unique(jointdataset$C18SZSET)
#this variable is an alternative test of the uni size*.
unique(jointdataset$INSTSIZE)




#*******************************************************************************.
#Step 10
#testing early version of broader regression analysis*.
lm(y1_p50_earnings ~ LOCALE + UGOFFER + GROFFER + CONTROL +C18SZSET,data=jointdataset) #generate multiple linear regression model

summary(lm(y1_p50_earnings ~ LOCALE + UGOFFER + GROFFER + CONTROL + C18SZSET + INSTSIZE,data=jointdataset)) #creating summary stats 


#NOTE: HLOFFER currently doesn't work correctly in the regression analysis*. 








