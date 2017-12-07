library(tidyverse)
library(data.table)
library(mice)

churn=fread("churn.csv",stringsAsFactors = FALSE)
library(mice)
churn_impute1=churn%>%mice(method = "rf",m=1,seed=7)%>%complete(1)
churn_impute1[,"customerID"]=NULL
library(caret)
churn_impute1_dummy=dummyVars("Churn~.",data=churn_impute1)%>%predict(newdata=churn_impute1)%>%data.frame()
churn_impute1_dummy=cbind(Churn=churn$Churn,churn_impute1_dummy)%>%as.data.frame()
rm(churn)
rm(churn_impute1)