# makefile

[TOC]

## 基本规则

1. make在当前目录下寻找“Makefile”或“makefile”文件

2. 若找到，查找文件中的第一个目标文件.o

3. 若目标文件不存在，根据依赖关系查找.s文件

4. 若.s文件不存在，根据依赖关系查找.i文件

5. 若.i文件不存在，根据依赖关系查找.c文件，此时.c文件一定存在，于是生成一个.o文件，再去执行

``` makefile

<target>: <prerequisites>
[Tab]<commands>

```

TARGET：规则生成的目标文件，通常是需要生成的程序名（例如前面出现的程序名test）或者过程文件（类似.o文件）。

PREREQUISITES：规则的依赖项，比如前面的Makefile文件中我们生成test程序所依赖的就是test.cpp。

COMMAND：规则所需执行的命令行，通常是编译命令。这里需要注意的是每一行命令都需要以[TAB]字符开头。

\#：以\#开始的行为注释

``` makefile
test:test.cpp
    g++-o test test.cpp
```

1. 如果目标test文件不存在，根据规则创建它。

2. 目标test文件存在，并且test文件的依赖项中存在任何一个比目标文件更新（比如修改了一个函数，文件被更新了），根据规则重新生成它。

3. 目标test文件存在，并且它比所有的依赖项都更新，那么什么都不做。

## 使用Makefile编译多个文件

``` c
test:test.cppw1.o w2.o w3.o
    g++ -o test test.cpp w1.o w2.o w3.o
w1.o:w1.cpp
    g++ -c -o w1.o w1.cpp
w2.o:w2.cpp
    g++ -c -o w2.o w2.cpp
w3.o:w3.cpp
    g++ -c -o w3.o w3.cpp

```

这里需要注意的是，我们写的第一个规则的目标，将会成为“终极目标”，也就是我们最终希望生成的程序，这里是“test”文件。根据我们的“终极目标”，make会进行自动推导，例如“终极目标”依赖于的.o文件，make就会寻找生成这些.o文件的规则，然后执行相应的命令去生成这些文件，这样一层一层递归地进行下去，直到最终生成了“终极目标”

## 使用伪目标来清除过程文件

```c
 clean:
    -rm–f test *.o
```

清除过程文件
rm是Linux下删除文件或目录的命令，前面加上“-”符号意思是忽略执行rm产生的错误。“-f”参数是指强制删除，忽略不存在的文件。

### 使用变量简化Makefile

还记得我们在Linux下如果要查看当前目录下所有的cpp文件的时候，使用的命令吗？

```shell
        ls*.cpp
```

通过这个命令，我们就可以将所有的cpp文件名称显示在界面上。而在Makefile中我们同样可以使用类似的规则来做简化，进一步减少后续开发过程中对Makefile文件的修改。

修改后的Makefile文件如下：

```makefile
TARGET= test
CPP_FILES = $(shell ls *.cpp)
BASE = $(basename $(CPP_FILES))
OBJS = $(addsuffix .o, $(addprefix obj/,$(BASE)))

$(TARGET):$(OBJS)

    -rm -f $@
     g++ -o $(TARGET)$(OBJS)

obj/%.o:%.cpp

    @if test ! -d"obj"; then\
    mkdir -pobj;\
    fi;
    g++ -c -o $@ $<

 clean:

    -rm -f test
    -rm -f obj/*.o

```

        是不是瞬间有种摸不着头脑的感觉？别急，这是因为我们用到了一些新的语法和命令，其实，本质上和我们之前所写的Makefile文件是一个意思，下面我们就逐条来进行分析。

（1）TARGET = test

        定义一个变量，保存目标文件名，这里我们需要生成的程序名就叫test。

（2）CPP_FILES = $(shell ls *.cpp)

        定义一个变量，内容为所有的以.cpp为后缀的文件的文件名，以空格隔开。这里&(shell 命令)的格式，说明这里将会用shell命令执行后输出的内容进行替换，就和在命令行下输入ls *.cpp得到的结果一样。

（3）BASE = \$(basename \$(CPP_FILES))

        定义一个变量，内容为所有的以.cpp为后缀的文件的文件名去除掉后缀部分。$(CPP_FILES)是引用CPP_FIFES这个变量的内容，相信学过如何写shell命令的同学肯定不会陌生。basename 是一个函数，其作用就是去除掉文件名的后缀部分，例如“test.cpp”，经过这一步后就变成了“test”。

（4）OBJS = \$(addsuffix .o, \$(addprefix obj/,$(BASE)))

        定义一个变量，内容为所有的以.cpp为后缀的文件去除调后缀部分后加上“.o”。

        和basename一样，addsuffix和addprefix同样也是调用函数。addprefix的作用是给每个文件名加上前缀，这里是加上“obj/”，而addsuffix的作用是给每个文件名加上后缀，这里是在文件名后加上“.o”。例如“test”，经过变换后变成了“obj/test.o”。

        为什么要在文件名前加上“obj/”？

        这个不是必须的，只是我自己觉得将所有的.o文件放在一个obj目录下统一管理会让目录结构显得更加清晰，包括以后的.d文件会统一放在dep目录下一样。当然，你也可以选择不这样做，而是全部放在当前目录下。

（5）\$(TARGET): \$(OBJS)

``` makefile
$(TARGET):$(OBJS)
    -rm -f $@
    g++ -o $(TARGET) $(OBJS)
```

        这个描述规则和我们之前写过的很像，只不过，使用了变量进行替换。其中需要注意的是$@这个奇怪的符号，它的含义是这个规则的目标文件的名称，在这里就相当于是$(TARGET)。把这里的变量替换成我们之前项目中的实际值，就相当于：

```makefile
test:test.ow1.o w2.o w3.o
    -rm–f test
    g++-o test test.o w1.o w2.o w3.o
```

        如果按照这种写法，当我们新增了一个w4.cpp文件的时候，就需要对Makefile进行修改，而如果我们使用了变量进行替换，那么我们就什么都不用做，直接再执行一遍gmake命令即可。

（6）obj/%.o:%.cpp

```makefile
obj/%.o:%.cpp
    @if test ! -d"obj"; then\
    mkdir -p obj;\
    fi;
    g++ -c -o $@ $<
```

        这是依次生成所有cpp文件所对应的.o文件的规则。

        %.o和%.c表示以.o和.c结尾的文件名。因为我们准备把所有的.o文件放在obj目录下，所以这里在“%.o”前面加上前缀“obj/”。

        下面命令行的前三行，具体的作用是检查当前目录下是否有名为“obj”的目录，如果没有，则使用mkdir命令创建这个目录。如果不了解的同学不如先去看一下shell编程的相关知识吧。

        最后一句中的$@前面已经解释过了，是代表规则的目标文件名称，而$<与之对应的，则是代表规则的依赖项中第一个依赖文件的名称。

        例如obj/test.o:test.cpp

        那么\$@的值为“test.o”，\$<的值为“test.cpp”

（7）clean:

```makefile
clean:
    -rm -f test
    -rm -f obj/*.o
```

        这个就没什么好说的啦，这里只是修改了一下.o文件的路径。
