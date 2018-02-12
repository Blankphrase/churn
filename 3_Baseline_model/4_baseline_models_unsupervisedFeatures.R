
# load my ml function for baseline 
source("https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_list.R")
# load the new cleaned data
source("https://raw.githubusercontent.com/edwardcooper/churn/master/2_Data_Clean/unsupervised_new_features.R")

#####################
# select models from here. 

# select the algorithms. 

source('~/Dropbox/churn/ml_algorithms.R', echo=TRUE)


install_pkg_model_names(method_vector)
###############################################
# get rid of pls model since it took 4hrs already. 
params_grid2=expand.grid(sampling=c("down")
                         ,metric=c("ROC")
                         ,method=method_vector
                         ,preProcess=list(c("center","scale","pca"))
                         ,search="random"
                         ,tuneLength=10
                         ,k=10,nthread=10)


baseModels_churn2_down=ml_list(data=train_churn,target = "Churn",params = params_grid2,summaryFunction=twoClassSummary,save_model = "unsupervisedFeatures_down_sampling_pca")
baseModels_churn2_down=assign_model_names(baseModels_churn2_down)
# example use of ml_bwplot
ml_bwplot(baseModels_churn2_down)



#==================================================================================

method_vector2=method_vector[!method_vector %in% "svmPoly"]
# get rid of pls model since it took 4hrs already. 
params_grid3=expand.grid(sampling=c("smote","rose")
                         ,metric=c("ROC")
                         ,method=method_vector2
                         ,preProcess=list(c("center","scale"))
                         ,search="random"
                         ,tuneLength=10
                         ,k=10,nthread=10)

baseModels_churn2_smote_rose=ml_list(data=train_churn,target = "Churn",params = params_grid3,summaryFunction=twoClassSummary,save_model = "unsupervisedFeatures_smote_and_rose_sampling")
ml_bwplot(baseModels_churn2_smote_rose)

timeRecordR()%>%filter(output_message!="None")

#=================================================================================

# get rid of pls model since it took 4hrs already. 
params_grid4=expand.grid(sampling=c("up")
                         ,metric=c("ROC")
                         ,method=method_vector2
                         ,preProcess=list(c("center","scale"))
                         ,search="random"
                         ,tuneLength=10
                         ,k=10,nthread=10)

baseModels_churn2_up=ml_list(data=train_churn,target = "Churn",params = params_grid4,summaryFunction=twoClassSummary,save_model = "unsupervisedFeatures_up_sampling")
ml_bwplot(baseModels_churn2_up)
timeRecordR()%>%filter(output_message!="None")
