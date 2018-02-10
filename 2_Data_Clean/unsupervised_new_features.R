# new features with unsupervised learning methods

# load cleaned data
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
# get rid of highly correlated data. 
high_cor_index=(churn_impute1_dummy%>%select(-Churn)%>%cor%>%findCorrelation(cutoff = 0.9,exact=TRUE))+1
churn_impute1_dummy=churn_impute1_dummy[,-high_cor_index]

rm(high_cor_index)
# do a log10 transformation to reduce the scale of variablees like MonthlyCharges and TotalCharges. 
churn_impute1_dummy$tenure=log1p(churn_impute1_dummy$tenure)
churn_impute1_dummy$TotalCharges=log10(churn_impute1_dummy$TotalCharges)
churn_impute1_dummy$MonthlyCharges=log10(churn_impute1_dummy$MonthlyCharges)

summary(churn_impute1_dummy%>%preProcess(c("center","scale"))%>%predict(churn_impute1_dummy))
churn_impute1_dummy$genderFemale=NULL
# rm the non-clean data 
rm(churn)
rm(churn_impute1)

##############################################################################
# kmeans

churn_impute1_dummy$kmeans=churn_impute1_dummy%>%select(-Churn)%>%kmeans(centers=100,nstart = 100, iter.max = 100)%>%fitted(method="class")

## dbscan family
library(dbscan)

# dbscan
churn_impute1_dummy$dbscan=churn_impute1_dummy%>%select(-Churn)%>%dbscan(eps=2.45,minPts = 5)%>%.$cluster

# hdbscan
churn_impute1_dummy$hdbscan=churn_impute1_dummy%>%select(-Churn)%>%hdbscan(minPts = 5)%>%.$cluster

# jpclust
churn_impute1_dummy$jpcluster=churn_impute1_dummy%>%select(-Churn)%>%jpclust(k=100,kt=10)%>%.$cluster

# optics with two extract 

churn_impute1_dummy$optics_db=churn_impute1_dummy%>%select(-Churn)%>%optics(eps = 2.42,minPts = 5)%>%extractDBSCAN(eps_cl = 10)%>%.$cluster
churn_impute1_dummy$optics_xi=churn_impute1_dummy%>%select(-Churn)%>%optics(eps = 2.42,minPts = 5)%>%extractXi(xi=0.1)%>%.$cluster

# snnclust
churn_impute1_dummy$snncluster=churn_impute1_dummy%>%select(-Churn)%>%sNNclust(k=15,eps=2.42,minPts = 5)%>%.$cluster


# hclust
churn_impute1_dummy$hcluster=hclust(dist(churn_impute1_dummy%>%select(-Churn)))%>%cutree(k=100)
glimpse(churn_impute1_dummy)

# change all int into dbl
int_to_dbl=function(data){
  for(i in seq_along(colnames(data))){
    if(class(data[1,i])=="integer"){
      data[,i]=as.double(data[,i])
    }
  }
  return(data)
}

churn_impute1_dummy=int_to_dbl(churn_impute1_dummy)
glimpse(churn_impute1_dummy)
