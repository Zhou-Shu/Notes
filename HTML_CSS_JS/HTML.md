# HTML

## 基础结构

- html树形结构

    所有的CSS语句都是基于各个标记之间的父子关系，为了更好的理解父子关系，我们看下html文档的结构，各个标记之间呈现“树”型关系，处于最上端\<html>标记称之为“根”，它是所有标记的源头，往下层层包含。在每一个分支中，上层标记为其下层标记的“父”标记，相应的下层标记为上层标记的“子”标记。如下图\<p>标记是\<body>标记的子标记，同时它也是\<em>的父标记。
<br>
- Sibling（ 兄弟 ）关系

    同一层级的html兄弟姐妹元素节点共同享一父元素
<br>
- Ancestor and Descendant（祖先后代）关系

    那么body和em之间是什么关系呢？body是祖辈，li是后辈

## post与get

作者：大宽宽
链接：https://www.zhihu.com/question/28586791/answer/767316172
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

这个问题虽然看上去很初级，但实际上却涉及到方方面面，这也就是为啥面试里老爱问这个的原因之一。HTTP最早被用来做浏览器与服务器之间交互HTML和表单的通讯协议；后来又被被广泛的扩充到接口格式的定义上。所以在讨论GET和POST区别的时候，需要现确定下到底是浏览器使用的GET/POST还是用HTTP作为接口传输协议的场景。浏览器的GET和POST这里特指浏览器中非Ajax的HTTP请求，即从HTML和浏览器诞生就一直使用的HTTP协议中的GET/POST。浏览器用GET请求来获取一个html页面/图片/css/js等资源；用POST来提交一个form表单，并得到一个结果的网页。浏览器将GET和POST定义为：GET“读取“一个资源。比如Get到一个html文件。反复读取不应该对访问的数据有副作用。比如”GET一下，用户就下单了，返回订单已受理“，这是不可接受的。没有副作用被称为“幂等“（Idempotent)。因为GET因为是读取，就可以对GET请求的数据做缓存。这个缓存可以做到浏览器本身上（彻底避免浏览器发请求），也可以做到代理上（如nginx），或者做到server端（用Etag，至少可以减少带宽消耗）POST在页面里form 标签会定义一个表单。点击其中的submit元素会发出一个POST请求让服务器做一件事。这件事往往是有副作用的，不幂等的。不幂等也就意味着不能随意多次执行。因此也就不能缓存。比如通过POST下一个单，服务器创建了新的订单，然后返回订单成功的界面。这个页面不能被缓存。试想一下，如果POST请求被浏览器缓存了，那么下单请求就可以不向服务器发请求，而直接返回本地缓存的“下单成功界面”，却又没有真的在服务器下单。那是一件多么滑稽的事情。因为POST可能有副作用，所以浏览器实现为不能把POST请求保存为书签。想想，如果点一下书签就下一个单，是不是很恐怖？。此外如果尝试重新执行POST请求，浏览器也会弹一个框提示下这个刷新可能会有副作用，询问要不要继续。

<img src="https://pic4.zhimg.com/50/v2-cf007063e5b1416e95935ffa9bcc6470_hd.jpg" data-size="normal" data-rawwidth="1018" data-rawheight="332" data-default-watermark-src="https://pic1.zhimg.com/50/v2-d4c867df7c06ea9cf17643b48c5878ef_hd.jpg" class="origin_image zh-lightbox-thumb" width="1018" data-original="https://pic4.zhimg.com/v2-cf007063e5b1416e95935ffa9bcc6470_r.jpg"/>在chrome中尝试重新提交表单会弹框。当然，服务器的开发者完全可以把GET实现为有副作用；把POST实现为没有副作用。只不过这和浏览器的预期不符。把GET实现为有副作用是个很可怕的事情。 我依稀记得很久之前百度贴吧有一个因为使用GET请求可以修改管理员的权限而造成的安全漏洞。反过来，把没有副作用的请求用POST实现，浏览器该弹框还是会弹框，对用户体验好处改善不大。但是后边可以看到，将HTTP POST作为接口的形式使用时，就没有这种弹框了。于是把一个POST请求实现为幂等就有实际的意义。POST幂等能让很多业务的前后端交互更顺畅，以及避免一些因为前端bug，触控失误等带来的重复提交。将一个有副作用的操作实现为幂等必须得从业务上能定义出怎么就算是“重复”。如提交数据中增加一个dedupKey在一个交易会话中有效，或者利用提交的数据里可以天然当dedupKey的字段。这样万一用户强行重复提交，服务器端可以做一次防护。GET和POST携带数据的格式也有区别。当浏览器发出一个GET请求时，就意味着要么是用户自己在浏览器的地址栏输入，要不就是点击了html里a标签的href中的url。所以其实并不是GET只能用url，而是浏览器直接发出的GET只能由一个url触发。所以没办法，GET上要在url之外带一些参数就只能依靠url上附带querystring。但是HTTP协议本身并没有这个限制。浏览器的POST请求都来自表单提交。每次提交，表单的数据被浏览器用编码到HTTP请求的body里。浏览器发出的POST请求的body主要有有两种格式，一种是application/x-www-form-urlencoded用来传输简单的数据，大概就是"key1=value1&key2=value2"这样的格式。另外一种是传文件，会采用multipart/form-data格式。采用后者是因为application/x-www-form-urlencoded的编码方式对于文件这种二进制的数据非常低效。浏览器在POST一个表单时，url上也可以带参数，只要 &lt;form action="url"&gt;里的url带querystring就行。只不过表单里面的那些用&lt;input&gt; 等标签经过用户操作产生的数据都在会在body里。因此我们一般会泛泛的说“GET请求没有body，只有url，请求数据放在url的querystring中；POST请求的数据在body中“。但这种情况仅限于浏览器发请求的场景。

<a href="https://www.oschina.net/news/77354/http-get-post-different">另一个详解：get-post different</a>

3.form标签

1、\<form> 表单的属性有：

accept-charset、action、method、name、target等。其中：

（1）action：表单提交的地址，action的地址就是要提交的服务器的地址。
（2）method：以何种方式提交，常见的为get和post，区别在于一个是明文（在url中显示），一个是暗文。

2、\<form>标签使用示例：

```html
<form action="demo_form.php" method="get">

First name: <input type="text" name="fname"><br> 

Last name: <input type="text" name="lname"><br> 

<input type="submit" value="提交">

</form>
```

当点击submit按钮时，浏览器会自动将表单信息封装提交至action中的地址。所谓的提交就是访问action中地址并携带着form表单中input，textarea，select的信息