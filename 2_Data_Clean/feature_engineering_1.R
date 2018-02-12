# setwd("~/Dropbox/churn/")
# load my ml function for baseline 
source("https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_list.R")
# load the new cleaned data
source("https://raw.githubusercontent.com/edwardcooper/churn/master/2_Data_Clean/unsupervised_new_features.R")

#####################
# select models from here. 

# select the algorithms. 

# some more feature engineering qith several step functions. 
method_vector=c("glmStepAIC","stepLDA","msaenet","plr","stepQDA")

install_pkg_model_names(method_vector)
###############################################
# get rid of pls model since it took 4hrs already. 
params_grid2=expand.grid(sampling=c("down")
                         ,metric=c("ROC")
                         ,method=method_vector
                         ,preProcess=list(c("center","scale","pca"))
                         ,search="random"
                         ,tuneLength=10
                         ,repeats=5
                         ,k=10,nthread=3)


baseModels_churn2_down=ml_list(data=train_churn,target = "Churn",params = params_grid2,summaryFunction=twoClassSummary,save_model = "unsupervisedFeatures_down_sampling_test")

baseModels_churn2_down=assign_model_names(baseModels_churn2_down)
# example use of ml_bwplot
ml_bwplot(baseModels_churn2_down)


foreach(i=seq_along(baseModels_churn2_down),.combine = rbind)%do%{
  c(baseModels_churn2_down[[i]]%>%predict(newdata=dev_churn%>%select(-Churn))%>%confusionMatrix(dev_churn$Churn)%>%.$byClass
    ,baseModels_churn2_down[[i]]%>%predict(newdata=dev_churn%>%select(-Churn))%>%confusionMatrix(dev_churn$Churn)%>%.$overall)
}

