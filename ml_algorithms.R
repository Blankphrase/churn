library(magrittr)
library(dplyr)
method_vector=caret::modelLookup()%>%filter(forClass)%>%select(model)%>%unique%>%as.matrix%>%as.vector()
# build a black list of model names. 
# bartmachine sometimes crashes, and gamboost takes a lot of memory. More than rf models. 
# elm just put the entire system into a sleep mode, not responding from the console and no program running(the worst kind of error).
# awnb and awtan just did not work 
# binda BstLm bstSm bstTree did not work
# chaid could not install the library.
# CSimca","ctree","ctree2 not sure about the error but the program moves on. 
# gpls runs into a stall
# avoid black list at all cost  
# Rborist would crash the R session.
# vbmpRadial depends on rJava
black_list=c("bartMachine","gamboost","awnb","awtan","bag","binda","BstLm","bstSm"
             ,"bstTree","chaid","CSimca","ctree","ctree2","elm","extraTrees",'FH.GBML',"FRBCS.CHI","FRBCS.W","C5.0Cost"
             ,"gpls","hda","J48","JRip","kknn","logicBag","logreg","lssvmLinear","lssvmPoly","lssvmRadial","lvq","manb"
             ,"mda","Mlda","nbDiscrete","nbSearch","ownn","partDSA","polr","protoclass","qda","QdaCov","Rborist","rFerns"
             , "RFlda","rfRules","rocc","rmda","rpartScore","rpartCost","rrlda","RSimca","SLAVE","smda","snn","svmLinear3"
             ,"svmSpectrumString","vglmAdjCat","vglmContRatio","vglmCumulative","vbmpRadial","PRIM")
# do grey list only if the data size is small. 
grey_list=c("glmboost","gaussprLinear","gaussprPoly","gaussprRadial","svmLinearWeights","svmLinearWeights2","widekernelpls","tanSearch","tan","svmRadialSigma","mxnet","mxnetAdam","ordinalNet")

non_sequential_list=c("mlpKerasDecay","mlpKerasDecayCost","mlpKerasDropout")
# do lda or lda2 with center scale and pca
# loclda also needs pca 
white_list=c("gbm_h2o","gcvEarth","glm","glmnet","glmnet_h2o","glmStepAIC","kernelpls"
             ,"mlpSGD","mlpWeightDecay"
             ,"msaenet","multinom","nnet","ORFlog","ORFpls","ORFridge","parRF","pcaNNet","pda"
             ,"plr","ranger","rlda","rotationForest","sda","sdwd","simpls","sparseLDA","spls","svmLinear","svmPoly","svmRadialCost","wsrf","xgbDART","xgbLinear","xgbTree","LMT","OneR")
# method_vector=method_vector[!method_vector %in% black_list]
# method_vector=method_vector[!method_vector %in% grey_list]
# method_vector=method_vector[!method_vector %in% non_sequential_list ]
method_vector=c(white_list,non_sequential_list)
rm(black_list)
rm(white_list)
rm(grey_list)
rm(non_sequential_list)