# do ensemble modeling for the churn dataset.

# there are two ways to do ensemble modeling:
# 1) you could either add the prediction to the original dataset as new features 
# 2) you could use the predictions as new dataset without original dataset, which is called stack modeling. 


# Here I am going to try to do stack modeling first. 

# load my ml function for baseline 
source("https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_list.R")
# load the new cleaned data
source("https://raw.githubusercontent.com/edwardcooper/churn/master/2_Data_Clean/unsupervised_new_features.R")

# updated version of ml_tune function with different sampling methods
source('https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_sampling_list.R')

# use recursive methods,varImp and etc to do feature selection

metrics_median_selected_models_churn <- readRDS("~/Dropbox/churn/metrics_median_selected_models_churn.rds")

metrics_median_selected_models_churn
