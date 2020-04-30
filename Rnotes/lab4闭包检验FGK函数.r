# lab4

## previous 1
library(spatstat)
data(cells)
data(japanesepines)
data(redwood)
par(mfrow=c(1,3))
plot(cells)
plot(japanesepines)
plot(redwood)
par(mfrow=c(1,1))

## 2 Controlling the plot
Fc<-Fest(cells)
plot(Fc)
plot(Fc, km ~ r)
plot(Fc, rs ~ r)
plot(Fc, theo ~ r)
plot(Fc, km ~ theo)
plot(Fc, cbind(km, rs) ~ r)
plot(Fc, cbind(km, rs, theo) ~ r)
plot(Fc, cbind(km, rs, theo) ~ theo)
plot(Fc, . ~ theo) #与上等价

### i
plot(Fc, asin(sqrt(.)) ~ asin(sqrt(theo)))

### ii
fish <- function(x) { asin(sqrt(x)) }
plot(Fc, fish(.) ~ fish(theo))
# i is equivlent to ii
# the sampling variance of sin−1(sqrtFˆ(r) )is approximately constant as a function of r

### q1

Kc <- Kest(cells)
plot(Kc, sqrt(./pi) ~ r)
plot(Kc, sqrt(./pi) - r ~ r)

Kc <- Kest(redwood)
plot(Kc, sqrt(./pi) ~ r)
plot(Kc, sqrt(./pi) - r ~ r)
#We usually calculate L(r) = sqrt(K(r)/pi) so that a Poisson process has L(r) = r and the variance is approximately stabilised.

## 3 Simulation envelopes

plot(envelope(cells, Kest))

E <- envelope(cells, Kest,nsim=39)
E
plot(E)

E<- as. function(E)
E(0.1)

## 4 Monte Carlo tests

### q3
E <- envelope(cells, Kest,nsim=39)
plot(E)
E<- as. function(E)
E(0.1)

### q4
E <- envelope(cells, Kest,nsim=39,global=TRUE) # global envelope 
plot(E）

## q5

Kc <- Kest(cells)
plot(envelope(cells, Kest,nsim=39,global=TRUE,fix.n=TRUE), . - theo ~ r)
# Plot the global envelope of Gˆ(r) − Gpoiss(r)
# fix.n means fix seed()