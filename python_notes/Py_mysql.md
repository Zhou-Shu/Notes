# Python-mySQL

<!-- TOC -->

- [Python-mySQL](#python-mysql)
    - [How to use mysql in flask](#how-to-use-mysql-in-flask)
    - [Normal way to use sql in python](#normal-way-to-use-sql-in-python)
    - [Some Common in mySQL](#some-common-in-mysql)
        - [In window10, mySQL cannot be connected](#in-window10-mysql-cannot-be-connected)
        - [cryptography error](#cryptography-error)
        - [Visual C++ 14.0 is required](#visual-c-140-is-required)

<!-- /TOC -->

## How to use mysql in flask

```CMD

py
>>py -m pip install mysql-python
#this package is really hard to install, I have spent about three hour on it, and it still not work.
highly recommended that use the alternative packages like pymsql and mysqlclient. Another way is find it .whl file and use the wheel to install it by hand.
>>py -m pip install flask-sqlalchemy


py
>>> from hello import db,Role,User
>>> db.create_all()
# create all table

py
>>> from hello import db,Role,User
>>> db.drop_all()
# delete all table

py
>>> from hello import db,Role,User
>>> db.session.add(Role(name='Admin'))
>>> db.session.commit()
>>> db.session.add(Role(name='Moderator'))
>>> db.session.add(Role(name='User'))
>>> db.session.commit()
#insert one tuple

py
>>> from hello import db,Role,User
>>> db.session.add_all([User(username='john',role_id=1),User(username='susan',role_id=3),User(username='david',role_id=3)])
>>> db.session.commit()
#insert tuples

py
>>> from hello import db,Role,User
>>> admin = Role.query.filter_by(name='Admin').first()# find the first tuple which matched conditions
>>> admin.name='Administrator'
>>> db.session.commit()
# upgrade tuples

py
>>> from hello import db,Role,User
>>> mod = Role.query.filter_by(name='Moderator').first()
>>> db.session.delete(mod)
>>> db.session.commit()
# delete a tuple

py
>>> from hello import db,Role,User
>>> Role.query.all()
[<Role u'Administrator'>, <Role u'User'>]
>>> User.query.all()
[<User u'john',Role id 1L>, <User u'susan',Role id 3L>, <User u'david',Role id 3L>]
# query tables
# the result is dependent on the function def __repr__ (self) which was defined in the table class in python

py
>>> from hello import db,Role,User
>>> Role.query.filter_by(name='Administrator').first()
<Role u'Administrator'>
>>> User.query.filter_by(role_id=3).all()
[<User u'susan',Role id 3L>, <User u'david',Role id 3L>]
>>> User.query.filter_by(role_id=3).first()
<User u'susan',Role id 3L>
>>> User.query.filter_by(role_id=3,username='susan').first()
<User u'susan',Role id 3L>
>>> User.query.filter_by(role_id=3,username='susan').all()
# using condition find tuples('where' in sql)

py
>>> from hello import db,Role,User
>>> User.query.filter_by(role_id=3,username='susan').count()
1L
>>> User.query.filter_by(role_id=3).count()
2L
>>> User.query.count()
3L
# count in SQL

py
>>> from hello import db,Role,User
>>> from sqlalchemy.sql import func
>>> User.query.with_entities(func.sum(User.id)).all()
[(Decimal('6'),)]
>>> User.query.with_entities(func.sum(User.role_id)).all()
[(Decimal('7'),)]
#sum in SQL

py
>>> from hello import db,Role,User
>>> from sqlalchemy.sql import func
>>> User.query.with_entities(func.avg(User.role_id)).all()
[(Decimal('2.3333'),)]
>>> User.query.with_entities(func.avg(User.id)).all()
[(Decimal('2.0000'),)]
# get average

py
>>> from hello import db,Role,User
# asc
>>> User.query.order_by(User.role_id).all()
[<User u'john',Role id 1L>, <User u'susan',Role id 3L>, <User u'david',Role id 3L>]
# desc
>>> User.query.order_by(User.role_id.desc()).all()
[<User u'susan',Role id 3L>, <User u'david',Role id 3L>, <User u'john',Role id 1L>]
# order by in sql

py
>>> from hello import db,Role,User
>>> User.query.group_by(User.role_id).all()
[<User u'john',Role id 1L>, <User u'susan',Role id 3L>]
#group by in sql

py
>>> from hello import db,Role,User
>>> User.query.all()
[<User u'john',Role id 1L>, <User u'susan',Role id 3L>, <User u'david',Role id 3L>]
# limit 1
>>> User.query.limit(1).all()
[<User u'john',Role id 1L>]
# limit 2,1
>>> User.query.limit(1).offset(2).all()
[<User u'david',Role id 3L>]
>>> User.query.filter_by(role_id=3).all()
[<User u'susan',Role id 3L>, <User u'david',Role id 3L>]
# limit 1
>>> User.query.filter_by(role_id=3).limit(1).all()
[<User u'susan',Role id 3L>]
# limit 1,1
>>> User.query.filter_by(role_id=3).limit(1).offset(1).all()
[<User u'david',Role id 3L>]
#limit in sql

python
>>> from hello import db,Role,User
>>> User.query.all()
[<User u'john',Role id 1L>, <User u'susan',Role id 3L>, <User u'david',Role id 3L>]
>>> str(User.query)
'SELECT users.id AS users_id, users.username AS users_username, users.role_id AS users_role_id \nFROM users'
>>> User.query.limit(1).all()
[<User u'john',Role id 1L>]
>>> str(User.query.limit(1))
'SELECT users.id AS users_id, users.username AS users_username, users.role_id AS users_role_id \nFROM users \n LIMIT %s'
>>> User.query.limit(1).offset(2).all()
[<User u'david',Role id 3L>]
>>> str(User.query.limit(1).offset(2))
'SELECT users.id AS users_id, users.username AS users_username, users.role_id AS users_role_id \nFROM users \n LIMIT %s, %s'
# turn Flask-SQLAlchemy to sql line

```

reference: 《Flask web开发》

## Normal way to use sql in python

```py
import MySQLdb

# connect db
db = MySQLdb.connect(host='localhost',user='username in sql',passwd='password',db='db name',port=3306 )

#get cursor
cursor = db.cursor()

# execute sql's commonds
cursor.execute("SELECT VERSION()")

#submit the change
db.commit()

#rollback the change
db.rollback()

# get the information from sql
sql = "SELECT * FROM EMPLOYEE WHERE INCOME > %s" % (1000)
try:
   cursor.execute(sql)
   # get all the tuple, if this clause is cursor.fetchone then get one tuple.
   results = cursor.fetchall()
   for row in results:
      fname = row[0]
      lname = row[1]
      age = row[2]
      sex = row[3]
      income = row[4]
      print "fname=%s,lname=%s,age=%s,sex=%s,income=%s" % (fname, lname, age, sex, income )
except:
   print "Error: unable to fecth data"

#close db
db.close()
```

## Some Common in mySQL

### In window10, mySQL cannot be connected

The way I used is that open "Control panel", find "admintools", find "services "(%windir%\system32\services.msc), find MySQL services, click Start/Restart. Then you can connect it.(Not always work, but it indeed is the easiest way compare others)

### cryptography error

It might happen when we connect the mysql's database that "RuntimeError: cryptography is required for sha256_password or caching_sha2_passwordthe system", which is because that after version 8.0 of MySQL, caching_sha2_password was used as the default authentication plug-in. I've tried a lot of way to deal with it, most of them are too complict. There is a easy way may can help(but not always work), which is importing the package "cryptography".

```cmd
py
>> py -m pip install cryptography
```

or <a href="https://dev.mysql.com/doc/refman/5.7/en/sha256-pluggable-authentication.html">complex way</a>

### Visual C++ 14.0 is required

When we use pip to install some packages in python might meet this kind of problem, which is quite difficult to deal with, because Visual C++ is huge and difficult to install. As long as we press the cancel during the process of installation, there no way to make it work again.(At lease I did not find a Executable way.) So if you want install Visual C++ 14.0, Do not pause it!!!!! )

there is a alternative way:
<a href="https://www.lfd.uci.edu/~gohlke/pythonlibs/">Unofficial Windows Binaries for Python Extension Packages</a>
We can use wheel to install the packages we want.
