#q1
library(spatstat)
data(cells)
data(japanesepines)
data(redwood)
par(mfrow=c(1,3))
plot(cells)
plot(japanesepines)
plot(redwood)
par(mfrow=c(1,1))

#q2
Fc <- Fest(cells)
plot(Fc)# regular
Fj <- Fest(japanesepines)
plot(fj)# completely random
Fw <- Fest(redwood)
plot(Fw)# clustered

#q3
par(mfrow=c(1,3))
Gc <- Gest(cells)
plot(Gc)# regular
Gj <- Gest(japanesepines)
plot(Gj)# completely random
Gw <- Gest(redwood)
plot(Gw)# clustered
par(mfrow=c(1,1))

#q4
par(mfrow=c(1,3))
Kc <- Kest(cells)
plot(Kc)# regular
Kj <- Kest(japanesepines)
plot(Kj)# completely random
Kw <- Kest(redwood)
plot(Kw)# clustered
par(mfrow=c(1,1))

#upgrade R
install.packages("installr")
require(installr)
updateR()