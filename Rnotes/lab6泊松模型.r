# 1.The model-fitting function ppm
library(spatstat)
data(nztrees)
ppm(nztrees)
help(ppm)
# 2.Model formulas
ppm(nztrees, ~1) # intensity is constant.
summary(nztrees)
ppm(nztrees, ~x) #point u=(x,y),log λ(x, y) = β0 + β1x
ppm(nztrees, ~x+y) #log λ(x, y) = β0 + β1x + β2y


# 3.Terms in a model formula

    # The terms in a model formula can also be expressions. For example:
ppm(swedishpines, ~sin(x))
ppm(swedishpines, ~sin(x)+abs(y-5))
    # However, it is only safe to do this if the expression is enclosed in a function call (like sin or
    # abs above). This is because the arithmetic operators *, /, +, - and ˆ have special meanings in a
    # model formula. So a command like
ppm(swedishpines, ~xˆ2) # weird result

ppm(swedishpines, ~I(xˆ2)) #we use that to generate log λ(x, y) = β0 + β2x^2

ppm(swedishpines, ~polynom(x,2)) # log λ(x, y) = β0 + β1x + β2x^2

# 4.Special terms and operators

ppm(swedishpines, ~x-1) #show log λ(x, y) = βx which has only one parameter β.
ppm(swedishpines, ~offset(x/2) + y) # specifies the model log λ(x, y) = 1/2x + βy which has only one free parameter β

# 5.The class ppm

    # The value returned by the function ppm is an object, of class "ppm", representing the fitted
    # point process model. When you type
data(swedishpines)
ppm(swedishpines, ˜x)
    # the return value is just printed at the console. That is, the generic function print is called, and
    # this executes the function print.ppm which is the print method for objects of class "ppm".

print.ppm #print fitted model
summary.ppm #summarise fitted model
plot.ppm #plot fitted intensity (etc)
predict.ppm #compute fitted intensity (etc)
coef.ppm #extract fitted coefficients
vcov.ppm #compute covariance of coefficient estimates
logLik.ppm #compute maximised value of log likelihood
anova.ppm #analysis of deviance

fit <- ppm(swedishpines, ~x + y)
fit
summary(fit)
coef(fit)
vcov(fit)
plot(fit)
lambda <- predict(fit, ngrid=200)
plot(lambda) # intensity function

# 6.Formal inference

# The command coef.ppm returns the estimated coefficients βi,
# and the command vcov.ppm calculates the ‘asymptotic’ variance-covariance matrix of these parameter estimates, 
# defined as the inverse of the Fisher information matrix. 
# Using this information we can construct confidence intervals for the parameters

beta <- coef(fit)
v <- vcov(fit)
se <- sqrt(diag(v))
cbind(beta-2*se,beta+2*se)

# The method anova.ppm performs Analysis of Deviance for the two models,
# which includes calculation of the likelihood ratio. 
# We can also get it to perform the likelihood ratio test 
# (of the null hypothesis that the coefficient of y is zero):
fit1 <- ppm(swedishpines, ~x + y)
fit0 <- ppm(swedishpines, ~x)
fit2<-ppm(swedishpines)
anova(fit0, fit1, test="Chi")
anova(fit2, fit0, test="Chi")
# the third argument specifies that the p-value should be calculated with 
# reference to the asymptotic χ^2 distribution of the LRTS

fit3<-step(fit1) 
plot(fit3)
# 此函数可以执行逐步模型选择。将似然比检验（或类似标准）重复应用于模型的每个项，
# 删除似然比检验接受空假设的任何项，直到它决定不应删除任何剩余项。

# 7.covariates
data(copper)
X <- copper$SouthPoints
Y <- copper$SouthLines
plot(X)
plot(Y, add=TRUE)
Z <- distmap(Y)# Z(x, y) = distance from (x, y) to nearest line in Y
plot(Z)
plot(Y, add=TRUE)
plot(ppm(X, ~d, covariates=list(d=Z)))

ppm?
