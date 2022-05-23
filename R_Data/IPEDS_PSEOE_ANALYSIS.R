

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

