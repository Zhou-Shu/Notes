library(lattice)
library(sp)
data(meuse)
coordinates(meuse) <- c("x", "y")
data(meuse.grid)
coordinates(meuse.grid) <- c("x", "y")

cad.lm<-lm(log(cadmium)~sqrt(dist), meuse)

meuse.grid$pred<-predict(cad.lm,meuse.grid)

library(gstat)
cad.vario<-variogram(cadmium~1, meuse)

v <- variogram(log(cadmium) ~ 1, meuse)
vsph.fit <- fit.variogram(v, vgm(1, "Sph", 800, 1))
vexp.fit <- fit.variogram(v, vgm(1, "Exp", 800, 1))
vgau.fit <- fit.variogram(v, vgm(1, "Gau", 800, 1))
plot(v, vsph.fit, pch = 19)
plot(v, vexp.fit, pch = 19)
plot(v, vgau.fit, pch = 19)

v <- variogram(log(cadmium) ~ 1, meuse)
vsph.fit <- fit.variogram(v, vgm(1, "Sph", 800, 1))
beta.hat <- mean(log(meuse$cadmium))
cad.sk1 <- krige(log(cadmium)~1, meuse, meuse.grid, vsph.fit, beta = beta.hat)

cad.mod<-gstat(formula=log(lead)~1, data=meuse, model=vsph.fit, beta = beta.hat)
cad.sk2<-predict(cad.mod,meuse.grid)
spplot(cad.sk1, c("var1.pred"))
spplot(cad.sk2, c("var1.pred"))

