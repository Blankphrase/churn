# load my ml function for baseline 
source("https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_list.R")
# load the clean data with deleted highly correlated columns.
source("https://raw.githubusercontent.com/edwardcooper/churn/master/2_Data_Clean/data_clean_low_cor.R")

###############################################
# get rid of pls model since it took 4hrs already. 
params_grid2=expand.grid(sampling=c("down")
                         ,metric=c("ROC")
                         ,method=c("bayesglm","glm","glmStepAIC","C5.0","C5.0Rules","C5.0Tree","rf","RRFglobal","wsrf","glmnet"
                                   ,"bagEarth" ,"bagFDA","bartMachine", "binda","blackboost","gam" 
                                   ,"nb","lda","rpart","BstLm","bstSm","bstTree","cforest"
                                   ,"earth","elm","evtree","extraTrees","fda","ctree","ctree2","deepboost"
                                   ,"gbm","gamboost","hda","hdda","knn","Logitboost","logicbag"
                                   ,"naive_bayes","pda","qda","ranger","rda","sda","stepLDA","xgbLinear","xgbTree","xgbDART")
                         ,search="random"
                         ,tuneLength=10
                         ,k=10,nthread=10)

baseModels_churn2=ml_list(data=train_churn,target = "Churn",params = params_grid2,summaryFunction=twoClassSummary)

# example use of ml_bwplot
ml_bwplot(baseModels_churn2)

# example use of ml_cv_filter
testmodels_metric_filtered=baseModels_churn2%>%ml_cv_filter(metric="ROC",mini=0.82,FUN=median)


# example use of ml_cor_filter 
low_cor_models_churn=testmodels_metric_filtered%>%ml_cor_filter(cor_level = 0.75)

# get rid of low spec models.

higer_spec_models=low_cor_models_churn%>%ml_cv_filter(metric = "ROC",mini = 0.6,FUN=median)
