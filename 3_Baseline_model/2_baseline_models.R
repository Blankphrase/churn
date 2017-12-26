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

baseModels_churn2_down=ml_list(data=train_churn,target = "Churn",params = params_grid2,summaryFunction=twoClassSummary,save_model = "down_sampling")

# example use of ml_bwplot
ml_bwplot(baseModels_churn2_down)

# example use of ml_cv_filter and ml_cor_filter
 # first select models with median ROC bigger than 0.82
 # second select models with correlation less than 0.75
 # third select models with Sens bigger than 0.6
 # fourth select models with Spec bigger than 0.8
#baseModels_churn2_down_filtered=baseModels_churn2_down%>%ml_cv_filter(metric="ROC",mini=0.82,FUN=median)%>%
 # ml_cor_filter(cor_level = 0.75)%>%ml_cv_filter(metric = "Sens",mini = 0.6,FUN=median)%>%ml_cv_filter(metric="Spec",mini=0.8,FUN=median)




#==================================================================================


# get rid of pls model since it took 4hrs already. 
params_grid3=expand.grid(sampling=c("smote","rose")
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

baseModels_churn2_smote_rose=ml_list(data=train_churn,target = "Churn",params = params_grid3,summaryFunction=twoClassSummary,save_model = "smote_and_rose_sampling")
ml_bwplot(baseModels_churn2_smote_rose)

timeRecordR()%>%filter(output_message!="None")

#=================================================================================

# get rid of pls model since it took 4hrs already. 
params_grid4=expand.grid(sampling=c("up")
                         ,metric=c("ROC")
                         ,method=c("bayesglm","glm","glmStepAIC","C5.0","C5.0Rules","C5.0Tree","rf","RRFglobal","wsrf","glmnet"
                                   ,"bagEarth" ,"bagFDA","bartMachine", "binda","blackboost","gam" 
                                   ,"nb","lda","rpart","BstLm","bstSm","bstTree","cforest"
                                   ,"earth","elm","evtree","extraTrees","fda","ctree","ctree2","deepboost"
                                   ,"gbm","hda","hdda","knn","Logitboost","logicbag"
                                   ,"naive_bayes","pda","qda","ranger","rda","sda","stepLDA","xgbLinear","xgbTree","xgbDART")
                         ,search="random"
                         ,tuneLength=10
                         ,k=10,nthread=10)

baseModels_churn2_up=ml_list(data=train_churn,target = "Churn",params = params_grid4,summaryFunction=twoClassSummary,save_model = "up_sampling")
ml_bwplot(baseModels_churn2_up)
timeRecordR()%>%filter(output_message!="None")
# # # =====================
#  params_grid5=expand.grid(sampling=c("down")
#                           ,metric=c("ROC")
#                           ,method=c("bayesglm","glm","glmnet")
#                           ,search="random"
#                           ,tuneLength=10
#                           ,k=10,nthread=10)
# 
#  baseModels_churn2_testmodels=ml_list(data=train_churn,target = "Churn",params = params_grid5,summaryFunction=twoClassSummary,save_model = "test_models")
# 
