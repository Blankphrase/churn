source("https://raw.githubusercontent.com/edwardcooper/mlmodel_select/master/ml_list.R")
# load the clean data
source("https://raw.githubusercontent.com/edwardcooper/churn/master/2_Data_Clean/data_clean_1.R")

params_grid2=expand.grid(sampling=c("up","down","smote","rose")
                        ,metric=c("ROC","Accuracy","Kappa","Sens","Spec")
                        ,method=c("glmnet","bagEarth" ,"bagFDA", "bam" , "bartMachine", "binda", "blackboost" 
                                  ,"nb","lda","pls","rpart","BstLm","bstSm","bstTree","cforest","earth","elm","evtree","extraTrees","fda","ctree","ctree2","deepboost"
                                  ,"gbm","gamboost","hda","hdda","knn","Logitboost","logicbag","naive_bayes","pda","qda","ranger","rda","sda","stepLDA")
                        ,search="random"
                        ,tuneLength=10
                        ,k=10,nthread=10)

basemodels_churn2=ml_list(data=train_churn,target = "Churn",params = params_grid2,summaryFunction=twoClassSummary)

# example use of ml_bwplot
ml_bwplot(basemodels_churn2)

# example use of ml_cv_filter
testmodels_metric_filtered=basemodels_churn2%>%ml_cv_filter(metric="ROC",mini=0.84,FUN=median)%>%ml_cv_filter(metric="ROC",max=0.017,FUN=sd)


# example use of ml_cor_filter 
low_cor_models_churn=basemodels_churn2%>%ml_cor_filter(cor_level = 0.9)
