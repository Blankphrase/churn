library(tidyverse)
library(data.table)
library(mice)

churn=fread("churn.csv",stringsAsFactors = FALSE)
# impute the missing data with random forest. 
library(mice)
churn_impute1=churn%>%mice(method = "rf",m=1,seed=7)%>%complete(1)
# get rid of the customer id variable since it is not needed. 
churn_impute1[,"customerID"]=NULL
# doing one hot encoding for the categorical data. 
library(caret)
churn_impute1_dummy=dummyVars("Churn~.",data=churn_impute1)%>%predict(newdata=churn_impute1)%>%data.frame()
# add the target variable. 
churn_impute1_dummy=cbind(Churn=churn$Churn,churn_impute1_dummy)%>%as.data.frame()
# rm the non-clean data 
rm(churn)
rm(churn_impute1)

# do a train, dev, test data split as suggested by Andrew Ng. 
set.seed(7)
index1=createDataPartition(churn_impute1_dummy$Churn,p=0.7,list = FALSE)
train_churn=churn_impute1_dummy[index1,]
intermediate_churn=churn_impute1_dummy[-index1,]
# split rest of the data into dev and test set. 
set.seed(7)
index2=createDataPartition(intermediate_churn$Churn,p=0.5,list = FALSE)

test_churn=intermediate_churn[index2,]
dev_churn=intermediate_churn[-index2,]


rm(index1,index2,intermediate_churn)
# the final output of this script is the cleaned data ready to be fed into a machine learning algorithm. 

