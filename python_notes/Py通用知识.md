# py通用知识

## Json

```py
import json
str_json = '{"name":"python","name1":"python1"}'
dic_json = json.loads(str_json)
print(dic_json)
#str->dic which matchs json's syntax

list_json ={ 'a' : 1, 'b' : 2, 'c' : 3, 'd' : 4, 'e' : 5 } 
str_json_1 = json.dumps(list_json)
print(str_json_1)
#list or dic->str which matchs json's syntax

with open("test.json", "w") as write_file:
    json.dump(dic_json,write_file)
#   json.dump(str_json,write_file)
#   do not put a string as the first arg, the result will be like that "{\"name\":\"python\",\"name1\":\"python1\"}"
#   writing json dic to a file

with open("test.json", "r") as write_file:
    load_dict = json.load(write_file)
    print(load_dict)
# loading json file's information to process as dic
```

## @装饰器的用法

以下两者等价

```py
def tag(func):
    def wrapper(text):
        value = func(text)
        return "<p>" + value + "</p>"

    return wrapper

@tag
def my_upper(text):
    value = text.upper()
    return value
```

```py
my_upper = tag(my_upper)
```

<a href="http://www.runoob.com/w3cnote/python-func-decorators.html">详解</a>
<a href="https://foofish.net/decorator-with-paramter.html">带参数的装饰器</a>

## 虚拟环境

CMD：
python3 -m venv venv
前一参数是venv指令，后一条是所创建的虚拟环境的名字
cd microblog
venv\Scripts\activate
cd  cits3200-master
py 
启动虚拟环境

## flask

<a href="https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-i-hello-world">microblog</a>
flask db init 初始化
flask db migrate -m "users table" 插入table
flask db migrate -m "new fields in user model" 跟新table
flask db upgrade 跟新
文件上传操作：
<a href="https://zhuanlan.zhihu.com/p/24418074?refer=flask">在flask中上传文件</a>

## sql

<a href="http://wingyumin.com/2017/02/25/%E4%BD%BF%E7%94%A8flask-sqlalchemy%E7%8E%A9%E8%BD%ACMySQL/">使用flask-sqlalchemy玩转MySQL</a>

