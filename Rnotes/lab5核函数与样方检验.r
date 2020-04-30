library(spatstat)

## Kernel estimate of intensity 核密度估计强度函数
plot(density(ponderosa))
plot(density(ponderosa, sigma=20))
plot(density(ponderosa, sigma=5))

D <- density(ponderosa, sigma=10)
D
plot(D)

### 叠起来，在原图上加别的信息
data(ponderosa)
plot(density(ponderosa, sigma=7),ribbon=FALSE)
contour.im(density(ponderosa, sigma=7),add=TRUE)#做等高线

plot(density(ponderosa, sigma=7),ribbon=FALSE)
persp.im(density(ponderosa, sigma=7),theta= 90) #三维图



## mark operate

library(spatstat)
data(ants)
?ants
summary(ants)
data(longleaf)
?longleaf
summary(longleaf)

### 调用mark
m.ants<-levels(marks(ants))
m.ants
m.longleaf<-marks(longleaf)
hist(m.longleaf)


### 调用分好类的mark
plot(ants)
plot(split(ants))
Messor.ants<-split(ants)$Messor
plot(Fest(split(ants)$Messor))

### cut函数根据mark将数据库分类
cate.longleaf<-cut(longleaf, breaks=c(0,30,80), labels=c("young", "adult"))
cate.longleaf
plot(cate.longleaf)
young.longleaf<-split(cate.longleaf)$young
plot(young.longleaf)
test<-Fest(young.longleaf)
plot(test)# clustering

## Quadrat test样方检验

### count 出样方的信息
q.ants<-quadratcount(ants ,2)
q.ants
intensity(q.ants)
plot(q.ants)
plot(ants, add=TRUE)

q.antsMessor<-quadratcount(split(ants)$Messor ,2)
plot(q.antsMessor)

### Chi^2 test 出样方检验的信息

#画test的图之前先画原图，这样才能叠起来看
hom.ants<-quadrat.test(ants ,4)
hom.ants
plot(ants)
plot(hom.ants,add=TRUE)

hom.antsMessor<-quadrat.test(split(ants)$Messor ,2)
 
# 以下是不画的对比
cate.longleaf<-cut(longleaf, breaks=c(0,30,80), labels=c("young", "adult"))
homyoung.longleaf<-quadrat.test(split(cate.longleaf)$young,2)
plot(homyoung.longleaf,add=TRUE,col="green")

young.longleaf<-split(cate.longleaf)$young
homyoung.longleaf<-quadrat.test(young.longleaf ,4)
plot(young.longleaf)
plot(homyoung.longleaf,add=TRUE,col="green")

adult.longleaf<-split(cate.longleaf)$adult
homadult.longleaf<-quadrat.test(adult.longleaf ,4)
plot(adult.longleaf)
plot(homadult.longleaf,add=TRUE,col="green")

### 核密度函数估计intensity 然后再做样方检验

ant<-rescale(ants)#换成标准单位
den25.ant<-density(ant, sigma=25)
qint.ant<-quadrat.test(ant,2,lambda=den25.ant)
qint.ant





