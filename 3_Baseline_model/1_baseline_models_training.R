# let us try soem baseline models like random forest, xgbTree, xgbLinear, xgbDart. 

# load the clean data
source("https://raw.githubusercontent.com/edwardcooper/churn/master/2_Data_Clean/data_clean_1.R")

# load my wrapper on caret package. 
source("https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_list.R")

##  ml_list function to train hundreds of ml models.

level1_methods_names_part1=c("bayesglm","glm","glmStepAIC","xgbTree","xgbDART","C5.0","C5.0Rules","C5.0Tree","rf","RRFglobal","wsrf")

params_grid=expand.grid(sampling=c("up","down","smote","rose")
                        ,metric=c("ROC")
                        ,method=level1_methods_names_part1
                        ,search="random"
                        ,tuneLength=10
                        ,k=10,nthread=10)

baseModels_churn=ml_list(data=train_churn,target = "Churn",params = params_grid,summaryFunction=twoClassSummary)



# # time for xgb models
# timeRecordR()%>%filter(output_message!="None")%>%filter(grepl("xgb",output_message) )%>%summarise(tot_time=sum(run_time))/3600
# # total time for all models.
# timeRecordR()%>%filter(output_message!="None")%>%summarise(tot_time=sum(run_time))/3600


