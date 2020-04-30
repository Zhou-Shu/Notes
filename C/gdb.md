# GDB

[toc]
GDB是GNU开源组织发布的一个强大的UNIX下的程序调试工具，GDB主要可帮助工程师完成下面4个方面的功能：

启动程序，可以按照工程师自定义的要求随心所欲的运行程序。
让被调试的程序在工程师指定的断点处停住，断点可以是条件表达式。
当程序被停住时，可以检查此时程序中所发生的事，并追索上文。
动态地改变程序的执行环境。
不管是调试Linux内核空间的驱动还是调试用户空间的应用程序，掌握gdb的用法都是必须。而且，调试内核和调试应用程序时使用的gdb命令是完全相同的，下面以代码清单22.2的应用程序为例演示gdb调试器的用法。

```c
int add(int a, int b)  
{
     return a + b;
}
main()  
{
    int sum[10] = { 10 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 11 };
    int i; 13 14 int array1[10] = { 16 48, 56, 77, 33, 33, 11, 226, 544, 78, 90 17 };
    int array2[10] = 19 { 20 85, 99, 66, 0x199, 393, 11, 1, 2, 3, 4 21 };
    for (i = 0; i < 10; i++)
    {
        sum[i] = add(array1[i], array2[i]);
    }
}
```

使用命令gcc –g gdb_example.c –o gdb_example编译上述程序，得到包含调试信息的二进制文件example，执行gdb gdb_example命令进入调试状态：

```shell
[root@localhost driver_study]# gdb gdb_example
GNU gdb Red Hat Linux (5.3post-0.20021129.18rh)
Copyright 2003 Free Software Foundation, Inc.
GDB is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain conditions.
Type "show copying" to see the conditions.
There is absolutely no warranty for GDB.  Type "show warranty" for details.
This GDB was configured as "i386-redhat-linux-gnu"...
(gdb)
```

## 1、list命令

在gdb中运行list命令（缩写l）可以列出代码，list的具体形式包括：

list \<linenum> ，显示程序第linenum行周围的源程序，如：

```shell
(gdb) list 15
10 
11        int array1[10] =
12        {
13          48, 56, 77, 33, 33, 11, 226, 544, 78, 90
14        };
15        int array2[10] =
16        {
17          85, 99, 66, 0x199, 393, 11, 1, 2, 3, 4
18        };
19
```

list \<function> ，显示函数名为function的函数的源程序，如：

```c
(gdb) list main
2       {
3         return a + b;
4       }
5
6       main()
7       {
8         int sum[10];
9         int i;
10
11        int array1[10] =
```

list，显示当前行后面的源程序。
list - ，显示当前行前面的源程序。
下面演示了使用gdb中的run（缩写r）、break（缩写b）、next（缩写n）命令控制程序的运行，并使用print（缩写p）命令打印程序中的变量sum的过程：

```shell
(gdb) break add
Breakpoint 1 at 0x80482f7: file gdb_example.c, line 3.
(gdb) run  
Starting program: /driver_study/gdb_example 

Breakpoint 1, add (a=48, b=85) at gdb_example.c:3
warning: Source file is more recent than executable.

3         return a + b;
(gdb) next
4       }
(gdb) next
main () at gdb_example.c:23
23        for (i = 0; i < 10; i++)
(gdb) next
25          sum[i] = add(array1[i], array2[i]);
(gdb) print sum
$1 = {133, 0, 0, 0, 0, 0, 0, 0, 0, 0}
gdb) break add
Breakpoint 1 at 0x80482f7: file gdb_example.c, line 3.
(gdb) run  
Starting program: /driver_study/gdb_example 

Breakpoint 1, add (a=48, b=85) at gdb_example.c:3
warning: Source file is more recent than executable.

3         return a + b;
(gdb) next
4       }
(gdb) next
main () at gdb_example.c:23
23        for (i = 0; i < 10; i++)
(gdb) next
25          sum[i] = add(array1[i], array2[i]);
(gdb) print sum
$1 = {133, 0, 0, 0, 0, 0, 0, 0, 0, 0}
```

## 2、run命令

在gdb中，运行程序使用run命令。在程序运行前，我们可以设置如下4方面的工作环境：

程序运行参数
set args 可指定运行时参数，如：set args 10 20 30 40 50；show args 命令可以查看设置好的运行参数。

运行环境
path \<dir> 可设定程序的运行路径；how paths可查看程序的运行路径；set environment varname [=value]用于设置环境变量，如set env USER=baohua；

show environment [varname]则用于查看环境变量。

工作目录
cd \<dir> 相当于shell的cd命令；pwd 显示当前所在的目录。

程序的输入输出
info terminal 用于显示程序用到的终端的模式；gdb中也可以使用重定向控制程序输出，如run > outfile；

tty命令可以指定输入输出的终端设备，如：tty /dev/ttyS1。

## 3、break命令

在gdb中用break命令来设置断点，设置断点的方法包括：

break \<function>
在进入指定函数时停住，C++中可以使用class::function或function(type, type)格式来指定函数名。

break \<linenum>
在指定行号停住。

break +offset / break -offset
在当前行号的前面或后面的offset行停住，offiset为自然数。

break filename:linenum
在源文件filename的linenum行处停住。

break filename:function
在源文件filename的function函数的入口处停住。

break *address
在程序运行的内存地址处停住。

break
break命令没有参数时，表示在下一条指令处停住。

break ... if \<condition>
“...”可以是上述的break \<linenum>、break +offset / break –offset中的参数，condition表示条件，在条件成立时停住。比如在循环体中，可以设置break if i=100，表示当i为100时停住程序。

查看断点时，可使用info命令，如info breakpoints [n]、info break [n]（n表示断点号）。

## 4、单步命令

在调试过程中，next命令用于单步执行，类似VC++中的step over。next的单步不会进入函数的内部，与next对应的step（缩写s）命令则在单步执行一个函数时，会进入其内部，类似VC++中的step into。下面演示了step命令的执行情况，在23行的add()函数调用处执行step会进入其内部的“return a+b;”语句：

```shell
(gdb) break 25
Breakpoint 1 at 0x8048362: file gdb_example.c, line 25.
(gdb) run
Starting program: /driver_study/gdb_example 

Breakpoint 1, main () at gdb_example.c:25
25          sum[i] = add(array1[i], array2[i]);
(gdb) step
add (a=48, b=85) at gdb_example.c:3
3         return a + b;
```

单步执行的更复杂用法包括：

step \<count>
单步跟踪，如果有函数调用，则进入该函数（进入函数的前提是，此函数被编译有debug信息）。step后面不加count表示一条条地执行，加表示执行后面的count条指令，然后再停住。

next \<count>
单步跟踪，如果有函数调用，它不会进入该函数。同样地，next后面不加count表示一条条地执行，加表示执行后面的count条指令，然后再停住。

set step-mode
set step-mode on用于打开step-mode模式，这样，在进行单步跟踪时，程序不会因为没有debug信息而不停住，这个参数的设置可便于查看机器码。set step-mod off用于关闭step-mode模式。

finish
运行程序，直到当前函数完成返回，并打印函数返回时的堆栈地址和返回值及参数值等信息。

until （缩写u）
一直在循环体内执行单步，退不出来是一件令人烦恼的事情，until命令可以运行程序直到退出循环体。

stepi（缩写si）和nexti（缩写ni）
stepi和nexti用于单步跟踪一条机器指令，一条程序代码有可能由数条机器指令完成，stepi和nexti可以单步执行机器指令。 另外，运行“display/i $pc”命令后，单步跟踪会在打出程序代码的同时打出机器指令，即汇编代码。

## 5、continue命令

当程序被停住后，可以使用continue命令（缩写c，fg命令同continue命令）恢复程序的运行直到程序结束，或到达下一个断点，命令格式为：

```shell
continue [ignore-count]
c [ignore-count]
fg [ignore-count]
```

ignore-count表示忽略其后多少次断点。 假设我们设置了函数断点add()，并watch i，则在continue过程中，每次遇到add()函数或i发生变化，程序就会停住，如：

```shell
(gdb) continue
Continuing.
Hardware watchpoint 3: i

Old value = 2
New value = 3
0x0804838d in main () at gdb_example.c:23
23        for (i = 0; i < 10; i++)
(gdb) continue
Continuing.
Breakpoint 1, main () at gdb_example.c:25
25          sum[i] = add(array1[i], array2[i]);
(gdb) continue
Continuing.
Hardware watchpoint 3: i

Old value = 3
New value = 4
0x0804838d in main () at gdb_example.c:23
23        for (i = 0; i < 10; i++)

```

## 6、print命令

在调试程序时，当程序被停住时，可以使用print命令（缩写为p），或是同义命令inspect来查看当前程序的运行数据。print命令的格式是：

```shell
 print <expr>
 print /<f> <expr>
```

\<expr>是表达式，是被调试的程序中的表达式，\<f>是输出的格式，比如，如果要把表达式按16进制的格式输出，那么就是/x。在表达式中，有几种GDB所支持的操作符，它们可以用在任何一种语言中，“@”是一个和数组有关的操作符，“::”指定一个在文件或是函数中的变量，“{\<type>} \<addr>”表示一个指向内存地址\<addr>的类型为type的一个对象。

下面演示了查看sum[]数组的值的过程：

```c
(gdb) print sum
$2 = {133, 155, 0, 0, 0, 0, 0, 0, 0, 0}
(gdb) next

Breakpoint 1, main () at gdb_example.c:25
25          sum[i] = add(array1[i], array2[i]);
(gdb) next
23        for (i = 0; i < 10; i++)
(gdb) print sum
$3 = {133, 155, 143, 0, 0, 0, 0, 0, 0, 0}
```

当需要查看一段连续内存空间的值的时间，可以使用GDB的“@”操作符，“@”的左边是第一个内存地址，“@”的右边则是想查看内存的长度。例如如下动态申请的内存：

```c
int *array = (int *) malloc (len * sizeof (int));
*array = (int *) malloc (len * sizeof (int));
```

在GDB调试过程中这样显示出这个动态数组的值：

```shell
p *array@len
*array@len
```

print的输出格式包括：

x 按十六进制格式显示变量。
d 按十进制格式显示变量。
u 按十六进制格式显示无符号整型。
o 按八进制格式显示变量。
t 按二进制格式显示变量。
a 按十六进制格式显示变量。
c 按字符格式显示变量。
f 按浮点数格式显示变量。
我们可用display命令设置一些自动显示的变量，当程序停住时，或是单步跟踪时，这些变量会自动显示。 如果要修改变量，如x的值，可使用如下命令：

```shell
print x=4
 x=4
```

当用GDB的print查看程序运行时的数据时，每一个print都会被GDB记录下来。GDB会以\$1，\$2，\$3 …这样的方式为每一个print命令编号。我们可以使用这个编号访问以前的表达式，如\$1。

## 7、watch命令

watch一般来观察某个表达式（变量也是一种表达式）的值是否有变化了，如果有变化，马上停住程序。我们有下面的几种方法来设置观察点： watch \<expr>：为表达式（变量）expr设置一个观察点。一量表达式值有变化时，马上停住程序。rwatch \<expr>：当表达式（变量）expr被读时，停住程序。awatch \<expr>：当表达式（变量）的值被读或被写时，停住程序。info watchpoints：列出当前所设置了的所有观察点。 下面演示了观察i并在连续运行next时一旦发现i变化，i值就会显示出来的过程：

```shell
(gdb) watch i
Hardware watchpoint 3: i
(gdb) next
23        for (i = 0; i < 10; i++)
(gdb) next
Hardware watchpoint 3: i

Old value = 0
New value = 1
0x0804838d in main () at gdb_example.c:23
23        for (i = 0; i < 10; i++)
(gdb) next

Breakpoint 1, main () at gdb_example.c:25
25          sum[i] = add(array1[i], array2[i]);
(gdb) next
23        for (i = 0; i < 10; i++)
(gdb) next
Hardware watchpoint 3: i

Old value = 1
New value = 2
0x0804838d in main () at gdb_example.c:23
23        for (i = 0; i < 10; i++)
```

## 8、examine命令

我们可以使用examine命令（缩写为x）来查看内存地址中的值。examine命令的语法如下所示：

x/<n/f/u> \<addr>
/<n/f/u> \<addr>
\<addr>表示一个内存地址。“x/”后的n、f、u都是可选的参数，n 是一个正整数，表示显示内存的长度，也就是说从当前地址向后显示几个地址的内容；f 表示显示的格式，如果地址所指的是字符串，那么格式可以是s，如果地址是指令地址，那么格式可以是i；u 表示从当前地址往后请求的字节数，如果不指定的话，GDB默认是4字节。u参数可以被一些字符代替：b表示单字节，h表示双字节，w表示四字节，g表示八字节。当我们指定了字节长度后，GDB会从指定的内存地址开始，读写指定字节，并把其当作一个值取出来。n、f、u这3个参数可以一起使用，例如命令“x/3uh 0x54320”表示从内存地址0x54320开始以双字节为1个单位（h）、16进制方式（u）显示3个单位（3）的内存。 ==

譬如下面的例子：

```c
main()
{
        char *c = "hello world";
        printf("%s\n", c);
}
```

我们在

```c
char *c = "hello world";
```

下一行设置断点后：

```shell
(gdb) l
1    main()
2    {
3        char *c = "hello world";
4        printf("%s\n", c);
5    }
(gdb) b 4
Breakpoint 1 at 0x100000f17: file main.c, line 4.
(gdb) r
Starting program: /Users/songbarry/main
Reading symbols for shared libraries +. done

Breakpoint 1, main () at main.c:4
4        printf("%s\n", c);

```

可以通过多种方式看C指向的字符串：

方法1：

(gdb) p c
$1 = 0x100000f2e "hello world"
方法2：

(gdb) x/s 0x100000f2e
0x100000f2e: "hello world"
方法3：

(gdb) p (char *)0x100000f2e
$3 = 0x100000f2e "hello world"
将第一个字符改为大写：

(gdb) p *(char *)0x100000f2e='H'
$4 = 72 'H'
再看看C：

(gdb) p c
$5 = 0x100000f2e "Hello world"

## 9、set命令

修改寄存器：

```shell
(gdb) set $v0 = 0x004000000
(gdb) set $epc = 0xbfc00000
```

修改内存：

(gdb) set {unsigned int}0x8048a51=0x0
譬如对于第8节的例子：

 

 
```shell
(gdb) set {unsigned int}0x100000f2e=0x0
(gdb) x/10cb 0x100000f2e
0x100000f2e:    0 '\0'	0 '\0'	0 '\0'	0 '\0'	111 'o'	32 ' '	119 'w'	111 'o'
0x100000f36:    114 'r'	108 'l'
(gdb) p c
$10 = 0x100000f2e ""
```

## 10、jump命令

一般来说，被调试程序会按照程序代码的运行顺序依次执行，但是GDB也提供了乱序执行的功能，也就是说，GDB可以修改程序的执行顺序，从而让程序随意跳跃。这个功能可以由GDB的jump命令：jump \<linespec> 来指定下一条语句的运行点。\<linespec>可以是文件的行号，可以是file:line格式，也可以是+num这种偏移量格式，表示下一条运行语句从哪里开始。jump \<address> 这里的\<address>是代码行的内存地址。 注意，jump命令不会改变当前的程序栈中的内容，所以，如果使用jump从一个函数跳转到另一个函数，当跳转到的函数运行完返回，进行出栈操作时必然会发生错误，这可能导致意想不到的结果，所以最好只用jump在同一个函数中进行跳转。

## 11、signal命令

使用singal命令，可以产生一个信号量给被调试的程序，如中断信号“Ctrl+C”。这非常方便于程序的调试，可以在程序运行的任意位置设置断点，并在该断点用GDB产生一个信号量，这种精确地在某处产生信号的方法非常有利于程序的调试。 signal命令的语法是：signal \<signal>，UNIX的系统信号量通常从1到15，所以\<signal>取值也在这个范围。

## 12、return命令

如果在函数中设置了调试断点，在断点后还有语句没有执行完，这时候我们可以使用return命令强制函数忽略还没有执行的语句并返回。

```shell
return
return \<expression>
```

上述return命令用于取消当前函数的执行，并立即返回，如果指定了\<expression>，那么该表达式的值会被作为函数的返回值。

 

## 13、call命令

call命令用于强制调用某函数： call <expr> 表达式中可以一是函数，以此达到强制调用函数的目的，它会显示函数的返回值（如果函数返回值不是void）。 其实，前面介绍的print命令也可以完成强制调用函数的功能。

## 14、info命令

info命令可以在调试时用来查看寄存器、断点、观察点和信号等信息。要查看寄存器的值，可以使用如下命令： info registers （查看除了浮点寄存器以外的寄存器）info all-registers （查看所有寄存器，包括浮点寄存器）info registers \<regname ...> （查看所指定的寄存器） 要查看断点信息，可以使用如下命令：info break 列出当前所设置的所有观察点，使用如下命令：info watchpoints 查看有哪些信号正在被GDB检测，使用如下命令：info signals info handle 也可以使用info line命令来查看源代码在内存中的地址。info threads可以看多线程。info line后面可以跟行号、函数名、文件名:行号、文件名:函数名等多种形式，例如下面的命令会打印出所指定的源码在运行时的内存地址：

info line tst.c:func

## 15、set scheduler-locking off|on|step

off 不锁定任何线程，也就是所有线程都执行，这是默认值。
on 只有当前被调试程序会执行。
step 在单步的时候，除了next过一个函数的情况以外，只有当前线程会执行。

与多线程调试相关的命令还包括：

thread ID
切换当前调试的线程为指定ID的线程。

break thread_test.c:123 thread all
在所有线程中相应的行上设置断点

thread apply ID1 ID2 command
让一个或者多个线程执行GDB命令command。

thread apply all command
让所有被调试线程执行GDB命令command。

## 16、disassemble

disassemble命令用于反汇编，它可被用来查看当前执行时的源代码的机器码，其实际上只是把目前内存中的指令dump出来。下面的示例用于查看函数func的汇编代码：

```shell
(gdb) disassemble func
Dump of assembler code for function func:
0x8048450 <func>:       push   %ebp
0x8048451 <func+1>:     mov    %esp,%ebp
0x8048453 <func+3>:     sub    $0x18,%esp
0x8048456 <func+6>:     movl   $0x0,0xfffffffc(%ebp)
...
End of assembler dump.
```
