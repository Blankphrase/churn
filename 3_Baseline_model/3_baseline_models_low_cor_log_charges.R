# load my ml function for baseline 
source("https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_list.R")
# load the clean data with deleted highly correlated columns.
source("https://raw.githubusercontent.com/edwardcooper/churn/master/2_Data_Clean/data_clean_low_cor_log_charges.R")


#####################
# select models from here. 

# select the algorithms. 

source('~/Dropbox/churn/ml_algorithms.R', echo=TRUE)

install_pkg_model_names(method_vector)
###############################################
# get rid of pls model since it took 4hrs already. 
params_grid2=expand.grid(sampling=c("down","smote","rose","up")
                         ,metric=c("ROC")
                         ,method=method_vector
                         ,preProcess=list(c("center","scale"))
                         ,search="random"
                         ,tuneLength=10
                         ,k=10,nthread=10)

# do not do svmPoly for smote,rose,or up sampling. 
params_grid2=params_grid2%>%filter(!(method=="svmPoly" & sampling %in% c("smote","rose","up")) )

baseModels_churn2_down=ml_list(data=train_churn,target = "Churn",params = params_grid2,summaryFunction=twoClassSummary,save_model = "low_cor_log_charges")

# example use of ml_bwplot
ml_bwplot(baseModels_churn2_down)

timeRecordR()%>%filter(output_message!="None")









