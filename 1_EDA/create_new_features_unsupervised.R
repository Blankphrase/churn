# churn_plot=train_churn[,-c(1,6,33,34)]%>%apply(2,as.factor)
# churn_plot=cbind(train_churn[,c(1,6,33,34)],churn_plot)
# ggpairs(churn_plot,mapping = aes(color=Churn),columns=1:6,upper ="blank",
#         lower = list(combo = "box"))
# 
# ggpairs(churn_plot,mapping = aes(color=Churn),columns=c(1,7:13),upper = list(discrete="ratio", combo = "facethist"),
#          lower = list(discrete="facetbar",combo = "box"))
# 
# ggpairs(churn_plot,mapping = aes(color=Churn),columns=c(1,13:19),upper = list(discrete="ratio", combo = "facethist"),
#         lower = list(discrete="facetbar",combo = "box"))
# 
# 
# ggpairs(churn_plot,mapping = aes(color=Churn),columns=c(1,20:27),upper = list(discrete="ratio", combo = "facethist"),
#         lower = list(discrete="facetbar",combo = "box"))
# ggpairs(churn_plot,mapping = aes(color=Churn),columns=c(1,27:34),upper = list(discrete="ratio", combo = "facethist"),
#         lower = list(discrete="facetbar",combo = "box"))

# rm(churn_plot)
# the above plot shows that gender does not have such relationship with Customer churning behavior. 

# some feature engineering through unsupervised learning. 

# load the cleaned data

source('~/Dropbox/churn/2_Data_Clean/data_clean_low_cor_log_charges.R')

# add feature kmeans using kmeans unsupervised method

kmeans_cluster_num=train_churn%>%select(-Churn)%>%kmeans(centers=100,nstart = 100, iter.max = 100)%>%fitted(method="class")

train_churn$kmeans=kmeans_cluster_num
# train_churn%>%ggplot(aes(x=kmeans,y=Churn))+geom_count()
train_churn%>%ggplot(aes(x=kmeans,y=Churn,color=Churn))+geom_count()

# add feature dbscan with dbscan unsupervised method. 
library(dbscan)
# plot the distance to guide the choice of hyper-parameters. 
# train_churn%>%select(-Churn)%>%kNNdistplot(k=5)
# abline(h=1, col = "red", lty=2)
# abline(h=1.4, col = "red", lty=2)
# abline(h=1.75, col = "red", lty=2)
# abline(h=2, col = "red", lty=2)
# abline(h=2.25, col = "red", lty=2)
# abline(h=2.42, col = "red", lty=2)

dbscan_cluster=train_churn%>%select(-Churn)%>%dbscan(eps=2.45,minPts = 5)
train_churn$dbscan=dbscan_cluster$cluster
table(train_churn$dbscan)
train_churn%>%ggplot(aes(x=dbscan,y=Churn))+geom_count()
train_churn%>%ggplot(aes(x=dbscan,y=kmeans,color=Churn),alpha=0.1)+geom_count()

hdbscan_cluster=train_churn%>%select(-Churn)%>%hdbscan(minPts=5)
train_churn$hdbscan=hdbscan_cluster$cluster
table(train_churn$hdbscan)

p1=train_churn%>%ggplot(aes(x=hdbscan,y=kmeans,color=Churn),alpha=0.1)+geom_count()
p2=train_churn%>%ggplot(aes(x=hdbscan,y=dbscan,color=Churn),alpha=0.1)+geom_count()
library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), size = "first"))


# jarvis-patrick clustering
jarvis_patrick_clustering=train_churn%>%select(-Churn)%>%jpclust(k=100,kt=10)
table(jarvis_patrick_clustering$cluster)

train_churn$jpcluster=jarvis_patrick_clustering$cluster

p1=train_churn%>%ggplot(aes(x=jpcluster,y=kmeans,color=Churn),alpha=0.1)+geom_count()
p2=train_churn%>%ggplot(aes(x=jpcluster,y=dbscan,color=Churn),alpha=0.1)+geom_count()
p3=train_churn%>%ggplot(aes(x=jpcluster,y=hdbscan,color=Churn),alpha=0.1)+geom_count()

library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "first"))

# optics 
optics_dbextract=train_churn%>%select(-Churn)%>%optics(eps = 2.42,minPts = 5)%>%extractDBSCAN(eps_cl = 10)
optics_xiextract=train_churn%>%select(-Churn)%>%optics(eps = 2.42,minPts = 5)%>%extractXi(xi=0.1)
table(optics_xiextract$cluster)
table(optics_dbextract$cluster)

train_churn$optics_db=optics_dbextract$cluster
train_churn$optics_xi=optics_dbextract$cluster

#extractdbscan
p1=train_churn%>%ggplot(aes(x=optics_db,y=kmeans,color=Churn),alpha=0.1)+geom_count()
p2=train_churn%>%ggplot(aes(x=optics_db,y=dbscan,color=Churn),alpha=0.1)+geom_count()
p3=train_churn%>%ggplot(aes(x=optics_db,y=hdbscan,color=Churn),alpha=0.1)+geom_count()

library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "first"))

#extractxi
p1=train_churn%>%ggplot(aes(x=optics_xi,y=kmeans,color=Churn),alpha=0.1)+geom_count()
p2=train_churn%>%ggplot(aes(x=optics_xi,y=dbscan,color=Churn),alpha=0.1)+geom_count()
p3=train_churn%>%ggplot(aes(x=optics_xi,y=hdbscan,color=Churn),alpha=0.1)+geom_count()

library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "first"))


train_churn%>%ggplot(aes(x=optics_xi,y=optics_db,color=Churn),alpha=0.1)+geom_count()+scale_size_area(max_size=5)

# sNNclust
sNNclust_cluster=train_churn%>%select(-Churn)%>%sNNclust(k=15,eps=2.42,minPts = 5)

table(sNNclust_cluster$cluster)

train_churn$snncluster=sNNclust_cluster$cluster

p1=train_churn%>%ggplot(aes(x=snncluster,y=kmeans,color=Churn),alpha=0.1)+geom_count()
p2=train_churn%>%ggplot(aes(x=snncluster,y=dbscan,color=Churn),alpha=0.1)+geom_count()
p3=train_churn%>%ggplot(aes(x=snncluster,y=hdbscan,color=Churn),alpha=0.1)+geom_count()
p4=train_churn%>%ggplot(aes(x=snncluster,y=jpcluster,color=Churn),alpha=0.1)+geom_count()
p5=train_churn%>%ggplot(aes(x=snncluster,y=optics_xi,color=Churn),alpha=0.1)+geom_count()
p6=train_churn%>%ggplot(aes(x=snncluster,y=optics_db,color=Churn),alpha=0.1)+geom_count()

library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "first"))
grid.draw(rbind(ggplotGrob(p4), ggplotGrob(p5), ggplotGrob(p6), size = "first"))


# hclust
hclust_cluster=hclust(dist(train_churn%>%select(-Churn)))
plot(hclust_cluster)
hclust_cluster=hclust_cluster%>%cutree(k=100)
table(hclust_cluster)

train_churn$hcluster=hclust_cluster

p1=train_churn%>%ggplot(aes(x=hcluster,y=kmeans,color=Churn),alpha=0.1)+geom_count()
p2=train_churn%>%ggplot(aes(x=hcluster,y=dbscan,color=Churn),alpha=0.1)+geom_count()
p3=train_churn%>%ggplot(aes(x=hcluster,y=hdbscan,color=Churn),alpha=0.1)+geom_count()
p4=train_churn%>%ggplot(aes(x=hcluster,y=jpcluster,color=Churn),alpha=0.1)+geom_count()
p5=train_churn%>%ggplot(aes(x=hcluster,y=optics_xi,color=Churn),alpha=0.1)+geom_count()
p6=train_churn%>%ggplot(aes(x=hcluster,y=optics_db,color=Churn),alpha=0.1)+geom_count()

library(grid)
grid.newpage()
grid.draw(rbind(ggplotGrob(p1), ggplotGrob(p2), ggplotGrob(p3), size = "first"))
grid.draw(rbind(ggplotGrob(p4), ggplotGrob(p5), ggplotGrob(p6), size = "first"))
