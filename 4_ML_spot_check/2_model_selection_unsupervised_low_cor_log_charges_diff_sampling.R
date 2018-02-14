# load my ml function for baseline 
source("https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_list.R")
# load the new cleaned data
source("https://raw.githubusercontent.com/edwardcooper/churn/master/2_Data_Clean/unsupervised_new_features.R")

# updated version of ml_tune function with different sampling methods
source('https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_sampling_list.R')
#####################

# use absolute path instead of relative path. 
model_list_load=function(path){
  current_path=getwd()
  setwd(path)
   path_command=paste("cd ",path,";ls")
   file_names=system(path_command,intern = TRUE)
   message(paste("Loading "),length(file_names)," models.")
  library(foreach)
  model_list=foreach(i=seq_along(file_names))%do%{
  model=readRDS(file=file_names[i])
   message(paste("Finished loading model:",file_names[i],"\n",i,"/",length(file_names)))
    return(model)
   }
  
  setwd(current_path)
   return(model_list)
  
 }


base_models_down_sampling=model_list_load("~/Dropbox/churn/down_sampling")
base_models_up_sampling=model_list_load("~/Dropbox/churn/up_sampling")

base_models_low_cor_log_charges=model_list_load("~/Dropbox/churn/low_cor_log_charges")

base_models_sampling_test=model_list_load("~/Dropbox/churn/sampling_test")

base_models_sampling_test_no_pca=model_list_load("~/Dropbox/churn/sampling_test_no_pca")

base_models_smote_and_rose_sampling=model_list_load("~/Dropbox/churn/smote_and_rose_sampling")


base_models_unsupervisedFeatures_down_sampling=model_list_load("~/Dropbox/churn/unsupervisedFeatures_down_sampling")

base_models_unsupervisedFeatures_down_sampling_pca=model_list_load("~/Dropbox/churn/unsupervisedFeatures_down_sampling_pca")

base_models_unsupervisedFeatures_down_sampling_test=model_list_load("~/Dropbox/churn/unsupervisedFeatures_down_sampling_test")

base_models_churn=c(base_models_up_sampling,
              base_models_low_cor_log_charges,base_models_sampling_test,base_models_sampling_test_no_pca,
              base_models_smote_and_rose_sampling,base_models_unsupervisedFeatures_down_sampling
              ,base_models_unsupervisedFeatures_down_sampling_pca)

base_models_churn=base_models_churn%>%assign_model_names%>%ml_bwplot

metrics_median_selected_models_churn=base_models_churn%>%ml_cv_filter(metric="ROC",mini=0.8,FUN=median)
metrics_median_selected_models_churn=metrics_median_selected_models_churn%>%ml_cv_filter(metric="Sens",mini=0.7,FUN=median)
metrics_median_selected_models_churn=metrics_median_selected_models_churn%>%ml_cv_filter(metric="Spec",mini = 0.78,FUN=median)
metrics_median_selected_models_churn=metrics_median_selected_models_churn%>%ml_cv_filter(metric="Spec",mini = 0.76,FUN=min)
metrics_median_selected_models_churn=metrics_median_selected_models_churn%>%ml_cv_filter(metric="Sens",mini = 0.67,FUN=min)
metrics_median_selected_models_churn=metrics_median_selected_models_churn%>%ml_cv_filter(metric="ROC",mini = 0.82,FUN=min)


metrics_median_selected_models_churn%>%assign_model_names%>%ml_bwplot


# then, we are left with about 30 models with decent performance. 
cor_and_metrics_selected_models_churn=metrics_median_selected_models_churn%>%ml_cor_filter(cor_level = 0.9)


saveRDS(metrics_median_selected_models_churn,"~/Dropbox/churn/metrics_median_selected_models_churn.rds")
