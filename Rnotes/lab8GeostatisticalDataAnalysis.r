# perpration

library(lattice)
library(sp)
data(meuse)

# 1. Data Visualisation

variable.names(meuse) # List of variables in the data can be obtained

coordinates(meuse)<-c("x","y")
plot(meuse)
title("points") #画点所在的位置图

data(meuse.riv)
meuse.list<-list(Polygons(list(Polygon(meuse.riv)), "meuse.riv"))
meuse.pol<-SpatialPolygons(meuse.list)
plot(meuse)
plot(meuse.pol, add=TRUE) #画旁边的河

data(meuse.grid)
coordinates(meuse.grid)<-c("x","y")
meuse.grid<-as(meuse.grid, "SpatialPixels")
image(meuse.grid,col="lightgrey")
plot(meuse,col="red", add=TRUE)
plot(meuse.pol,col="skyblue", add=TRUE)


#1、
plot(meuse)#直接画

#2、
coordinates(meuse)<-c("x","y") #用坐标画
plot(meuse)

# 2. Exploring spatial realtionship

spplot(meuse,"copper", do.log=T, colorkey=TRUE)
bubble(meuse,"copper", do.log=T, key.space="bottom")

#In order to explore the relationship between the coper concentration and the distance to
#the river, do the following scatter plots and comment on any relationship between the two:

xyplot(copper~dist,as.data.frame(meuse))
xyplot(log(copper)~dist,as.data.frame(meuse))
xyplot(copper~sqrt(dist),as.data.frame(meuse))
xyplot(log(copper)~sqrt(dist),as.data.frame(meuse))

# 3. Fitting linear model
cu.fit<-lm(log(copper)~sqrt(dist), meuse)
summary(cu.fit)
meuse$fit.s<-predict(cu.fit,meuse)-mean(predict(cu.fit,meuse))
meuse$fit.res<-residuals(cu.fit) #残差
hist(meuse$fit.res)

#a.
plot(log(copper)~sqrt(dist),meuse)
lines(sqrt(meuse$dist), predict(cu.fit,meuse),color="blue")

#b.

#c.
plot(fit.res ~ predict(cu.fit,meuse), meuse)

#d.
hist(meuse$fit.res)
    
#e.
plot(meuse$dist.m, meuse$dist) # 距离被归一化了，这样找出原数据

predictlog<-predict(cu.fit,data.frame(dist=0.02))
exp(predictlog)