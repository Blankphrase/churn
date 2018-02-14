
# load my ml function for baseline 
source("https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_list.R")
# load the new cleaned data
source("https://raw.githubusercontent.com/edwardcooper/churn/master/2_Data_Clean/unsupervised_new_features.R")

# updated version of ml_tune function with different sampling methods
source('https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_sampling_list.R')
#####################
# select models from here. 

# select the algorithms. 

# source('~/Dropbox/churn/ml_algorithms.R', echo=TRUE)

####################################################
params_grid2=expand.grid(sampling=c("down","ADAS","ANS","BLSMOTE","DBSMOTE","RSLS","SLS","smote","rose","up")
                         ,metric=c("ROC")
                         ,method=c("glmnet","glm","LogitBoost","glmStepAIC","stepLDA","msaenet","plr","gcvEarth"
                                   ,"nnet","sda","spls","kernelpls","multinom","pcaNNet","pda","rlda","wsrf","rf")
                         ,preProcess=list(c("center","scale","pca"))
                         ,search="random"
                         ,tuneLength=10
                         ,k=10,nthread=10)
install_pkg_sampling(params_grid2$sampling)
install_pkg_model_names(params_grid2$method)

baseModels_churn2_down=ml_list(data=train_churn,target = "Churn",params = params_grid2,summaryFunction=twoClassSummary,save_model = "sampling_test_no_pca")

# baseModels_churn2_down%>%assign_model_names%>%ml_bwplot(metric="Sens")
# 
# baseModels_churn2_down%>%assign_model_names%>%ml_bwplot(metric="Spec")

baseModels_churn2_down%>%assign_model_names%>%ml_bwplot

timeRecordR()%>%filter(output_message != "None")%>%select(output_message,run_time)

# more detailed performance metrics.
foreach(i=seq_along(baseModels_churn2_down),.combine = rbind,.errorhandling = "pass")%do%{
  c(baseModels_churn2_down[[i]]%>%predict(newdata=dev_churn%>%select(-Churn))%>%confusionMatrix(dev_churn$Churn)%>%.$byClass
    ,baseModels_churn2_down[[i]]%>%predict(newdata=dev_churn%>%select(-Churn))%>%confusionMatrix(dev_churn$Churn)%>%.$overall)
}
