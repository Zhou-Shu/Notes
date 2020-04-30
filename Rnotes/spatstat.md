# lib_spatstat

[toc]

## ppp class

A class '"ppp"' to represent a two-dimensional point pattern. Includes information about the window in which the pattern was observed. Optionally includes marks.

- 'x'       vector of x coordinates of data points
- 'y'       vector of y coordinates of data points 
- 'n'       number of points
- 'window'  window of observation   (an object of class 'owin')
- 'marks'   optional vector or data frame of marks 

## 生成随机点过程

0. 窗口操作

    ```r
    W1<-owin(square(c(0,0.5)))
    W2<-owin(c(0,3),c(1,5))
    x[W1]$n
    ```

1. 泊松过程

    ```r
    rpoispp(f) #f为inhomegenious 的 lambda的取值函数
    rpoispp(20) #即为homogeneous的过程 lambda为常数
    ```

2. 二项过程

    ```r
    X<-runifpoint(20,W)
    ```

## 内建函数

1. plot

    ```r
    plot(x,main="x",clipwin=w，chars="x",cols=10)
    # 图，标题，窗口，绘点样式，线条粗细
    ```

2. hist
    生成直方图，属性同上

3. Fest,Gest,Kest

    Fest: Empty space function
    Gest: Nearest neighbour distance function G
    Kest: K function

    ```r
    Fc <- Fest(cells)
    plot(Fc)# regular
    Fj <- Fest(japanesepines)
    plot(fj)# completely random
    Fw <- Fest(redwood)
    plot(Fw)# clustered

    par(mfrow=c(1,3))
    Gc <- Gest(cells)
    plot(Gc)# regular
    Gj <- Gest(japanesepines)
    plot(Gj)# completely random
    Gw <- Gest(redwood)
    plot(Gw)# clustered
    par(mfrow=c(1,1))

    par(mfrow=c(1,3))
    Kc <- Kest(cells)
    plot(Kc)# regular
    Kj <- Kest(japanesepines)
    plot(Kj)# completely random
    Kw <- Kest(redwood)
    plot(Kw)# clustered
    par(mfrow=c(1,1))
    ```


4. as.function

```r
fc=Fest(x,correction="rs")
fc=as.function(fc)
fc(0.01)
```

将一个对象转换成一个函数，本质上跟python中的lambda有点像

