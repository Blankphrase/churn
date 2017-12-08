# let us try soem baseline models like random forest, xgbTree, xgbLinear, xgbDart. 

# load the clean data
source("https://raw.githubusercontent.com/edwardcooper/churn/master/2_Data_Clean/data_clean_1.R")

# load my wrapper on caret package. 
source("https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_list.R")

##  ml_list function to train hundreds of ml models.

level1_methods_names_part1=c("bayesglm","glm","glmnet","glmStepAIC","gam","xgbTree","xgbDART","C5.0","C5.0Rules","C5.0Tree","rf","RRFglobal","wsrf")

params_grid=expand.grid(sampling=c("up","down","smote","rose")
                        ,metric=c("ROC")
                        ,method=level1_methods_names_part1
                        ,search="random"
                        ,tuneLength=10
                        ,k=10,nthread=4)

baseModels_churn=ml_list(data=train_churn,target = "Churn",params = params_grid,summaryFunction=twoClassSummary)