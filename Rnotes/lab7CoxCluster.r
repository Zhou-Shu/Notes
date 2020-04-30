# 1. Cox and Cluster modelms in kppm

library(spatstat)
data(redwood)
kppm(redwood, ~1, "MatClust")
#The function kppm is used in spatstat to fit Cox process or Cluster processes. 

fitM<- kppm(redwood, ~1, "MatClust")
fitM
plot(envelope(fitM,fun=Kest,global=TRUE,nsim=19))
#Kest to test the model at 5% level of significance

# 2. Gibbs models in ppm
data(swedishpines)
ppm(swedishpines, ~1, Strauss(9))
ppm()
