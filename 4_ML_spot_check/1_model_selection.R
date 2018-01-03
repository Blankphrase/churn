smote_and_rose_sampling <- readRDS("~/Dropbox/churn/smote_and_rose_sampling.rds")
down_sampling <- readRDS("~/Dropbox/churn/down_sampling.rds")
up_sampling <- readRDS("~/Dropbox/churn/up_sampling.rds")

ml_models=c(smote_and_rose_sampling,down_sampling,up_sampling)
ml_models=assign_model_names(ml_models)
ml_models_roc_filtered=ml_models%>%ml_cv_filter(metric="ROC",mini=0.8,FUN=median)%>%ml_bwplot(metric = "Sens")%>%ml_cv_filter(metric="Sens",mini=0.7,FUN=median)%>%
  ml_cv_filter(metric="Spec",mini = 0.78)%>%ml_bwplot(metric=c("Spec","Sens"))



ml_models_roc_filtered=ml_models_roc_filtered%>%assign_model_names()
ml_models_roc_filtered%>%ml_bwplot(metric="ROC")


