library(spatstat)
data(cells)
data(japanesepines)
data(redwood)
par(mfrow=c(2,2))
plot(cells)
plot(japanesepines)
plot(redwood)
par(mfrow=c(1,1))
W1<-owin(square(c(0,0.5)))
plot(W1)
W2<-owin(c(0,3),c(1,5))
plot(W2)
plot(cells[W1])
cells[W1]$n

#q6
counter<-numeric(100)
w<-owin(c(0,2),c(0,2))
n_w<-owin(c(0,2),c(0,1))
for(i in 1:100)
{
  x<-runifpoint(100,w)
  counter[i]<-x[n_w]$n
}
hist(counter,main="bin")
mean(counter)
var(counter)

#q7
library(spatstat)
data(cells)
data(japanesepines)
data(redwood)
pairdist()
