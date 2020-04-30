# R

## 向量表示

c(1:10) #将多个变量黏合变成向量
c(3:10,2) # 3-10黏合上2
c(23:10) #递减增加
y<-seq(2,19, by=3) #从2到19 步距为3
y
length(y)


## for循环

for(i in 100:200){y=y+i};


## 生成随机数

set.seed(100) #设伪随机数种子

rnorm(100,5,2) #a random sample of size 100 from the normal distribution with mean 5 and standard deviation 2
rbinom(200,15,1/2) #a random sample of size 200 from the binomial distribution with n = 15 and probability of success 1/2
rgeom(100,1/2) #a random sample of size 100 from the geometric distribution with parameter 1/2
//注：上为失败次数。首次成功则需加一。
replicate(100,rexp(5,2))#重复试验可使用 replicate 函数

#矩阵表示

m<-matrix(c(1:6),nrow=2,ncol=3,byrow=TRUE) #1-6 2行3列 通过行的顺序排序。

m[2,] #做切片

m[-2,]#删除一行

m[,-2]#删除一列

rowSums(m) #个数；总和（colSums同）


diag(n) #creates an n × n identity matrix .
solve(A) #computes the inverse of the matrix A.
t(A) #computes the transpose of the matrix A.
eigen(A) # computes the eigenvalues and eigenvectors of the square matrix A.
cbind(A,1) #adds a column of 1’s at the end. If you want the column of 1’s at the beginning, use cbind(1,A). rbind(A,1) and rbind(1,A) can be used for rows.
m
cbind(m[,-3],1) #去掉最后一列，加上一列1

# expm 库

library(expm)
M1<-matrix(1:16, byrow=T, nrow=4)
M1
M2<-matrix(17:32,nrow=4, byrow=T)
M2

M1%*%M2 #M1 * M2

M1+M2 #M1 + M2

M1%^%3 #M1 三次方

expm(.3*M1) #求矩阵的以e为底的指数函数

# 统计数据 

x<-c(1:10)
summary(x) # mean(), median(), max(), min(), sd(), var()
fivenum(x) # 五个中位数
stem(x) #茎状图
hist(x) # 直方图
plot(x,type="l") #绘直线

# 读文件

HousePrice <- read.table("houses.data", header=TRUE) #reads the content of the file houses.data

#  创建空向量与数组

x=vector()　　#创建的为空向量（可以为数值或者字符串）

> x[1]=1
> x[2]=1
> x
[1] 1 1

x<-numeirc(0)     #长度可变的存储数字的向量

x=character()　　#创建出来的为字符串向量

> x[1]=1

> x[2]=3

> x

[1] "1"  "3"

x<-NULL; x[1]<-2;………… #每次给x赋值长度自动延长 生成的也为向量

vector(mode="numeric",length=0)定义一个空向量，往里面添加元素即可

x=matrix(nrow = 2,ncol=3) 　　#创建空矩阵