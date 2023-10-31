# Database-System Experiment-4

*21307289 刘森元*

## 1. 实验目的

熟悉SQL语句的数据查询语言，能够使用SQL语句对数据库进行连接查询和集合查询。

## 2. 实验环境

Macbook Pro 2021 (Apple M1 Pro)

MacOS Ventura 13.5.2

PostgreSQL 15.4 (Homebrew)

Z-shell 5.9

## 3. 实验内容

- 笛卡儿连接和等值连接
- 自然连接
- 外连接
- 复合条件连接
- 多表连接
- 使用保留字UNION进行集合或运算
- 采用逻辑运算符AND或OR来实现集合交和减运算

## 4. 实验步骤

首先使用 `\i` 命令执行 sql 脚本，将数据导入到数据库中

```postgresql
Experiment-3=# \i STUDENTS.sql
Experiment-3=# \i TEACHERS.sql
Experiment-3=# \i COURSES.sql
Experiment-3=# \i CHOICES.sql
```

以下完整代码见 [Experiment-4.sql](Experiment-4.sql)，输出结果均使用 `COPY` 导出至 `.csv` 文件

### 课内实验

#### Task-1

> 查询编号为800009026的学生所选的全部课程的课程名和成绩

使用 `JOIN` 连接 CHOICES 和 COURSES 进行查询

```postgresql
SELECT COURSES.cname, CHOICES.score 
FROM CHOICES 
JOIN COURSES ON CHOICES.cid = COURSES.cid 
WHERE CHOICES.sid = '800009026'
```

有结果

![image-20230925113837735](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925113837735.png)

#### Task-2

> 查询所有选了"database"的课程的学生的学号

使用 `JOIN` 连接 CHOICES 和 COURSES 进行查询

```postgresql
SELECT CHOICES.sid 
FROM CHOICES 
JOIN COURSES ON CHOICES.cid = COURSES.cid 
WHERE COURSES.cname = 'database'
```

有结果

![image-20230925113954029](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925113954029.png)

#### Task-3

> 求出选择了同一个课程的学生对

使用 `JOIN` 对 CHOICES 进行自连接进行查询

```postgresql
SELECT c1.sid, c2.sid 
FROM CHOICES c1 
JOIN CHOICES c2 ON c1.cid = c2.cid 
WHERE c1.sid <> c2.sid
```

由于连接后输出结果巨大，此处仅展示部分结果，如要查看请在本机上运行 [Experiment-4.sql](Experiment-4.sql) 以获取 [Task-3.csv](Task-3.csv)

![image-20230925114217730](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925114217730.png)

#### Task-4

> 求出至少被两名学生选修的课程编号

使用 `GROUP` 进行分组查询，`HAVING` 进行筛选

```postgresql
SELECT CHOICES.cid 
FROM CHOICES 
GROUP BY CHOICES.cid 
HAVING COUNT(DISTINCT CHOICES.sid) >= 2
```

有结果

![image-20230925114637599](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925114637599.png)

#### Task-5

> 查询选修了编号为800009026的学生所选的某个课程的学生编号

```postgresql
SELECT DISTINCT CHOICES.sid 
FROM CHOICES 
WHERE CHOICES.cid IN (
		SELECT CHOICES.cid 
		FROM CHOICES 
		WHERE CHOICES.sid = '800009026'
)
```

有结果

![image-20230925114751034](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925114751034.png)

#### Task-6

> 查询学生的基本信息及选修课程编号和成绩

```postgresql
SELECT STUDENTS.sid, STUDENTS.sname, STUDENTS.email, STUDENTS.grade, CHOICES.cid, CHOICES.score 
FROM STUDENTS 
JOIN CHOICES ON STUDENTS.sid = CHOICES.sid
```

![image-20230925115013950](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925115013950.png)

#### Task-7

> 查询学号为850955252的学生的姓名和选修的课程名称及成绩

```postgresql
SELECT STUDENTS.sname, COURSES.cname, CHOICES.score 
FROM STUDENTS 
JOIN CHOICES ON STUDENTS.sid = CHOICES.sid 
JOIN COURSES ON CHOICES.cid = COURSES.cid 
WHERE STUDENTS.sid = '850955252'
```

![image-20230925115053517](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925115053517.png)

#### Task-8

> 利用集合运算，查询选修课程C++或课程java的学生的学号

```postgresql
SELECT CHOICES.sid 
FROM CHOICES 
JOIN COURSES ON CHOICES.cid = COURSES.cid 
WHERE COURSES.cname = 'c++' OR COURSES.cname = 'java'
```

![image-20230925115128932](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925115128932.png)

#### Task-9

> 实现集合交运算，查询既选修课程C++又选修课程java的学生的学号

```postgresql
SELECT CHOICES.sid 
FROM CHOICES 
JOIN COURSES ON CHOICES.cid = COURSES.cid 
WHERE COURSES.cname = 'c++' 
INTERSECT 
SELECT CHOICES.sid 
FROM CHOICES 
JOIN COURSES ON CHOICES.cid = COURSES.cid 
WHERE COURSES.cname = 'java'
```

![image-20230925141915338](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925141915338.png)

#### Task-10

> 实现集合减运算，查询选修课程C++而没有选修课程java的学生的学号

```postgresql
SELECT CHOICES.sid 
FROM CHOICES 
JOIN COURSES ON CHOICES.cid = COURSES.cid 
WHERE COURSES.cname = 'c++' 
EXCEPT 
SELECT CHOICES.sid 
FROM CHOICES 
JOIN COURSES ON CHOICES.cid = COURSES.cid 
WHERE COURSES.cname = 'java'
```

![image-20230925141956083](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925141956083.png)

### 自我实践

#### Prac-1

> 查询选修java的所有学生的编号及姓名

```postgresql
SELECT STUDENTS.sid, STUDENTS.sname
FROM STUDENTS
JOIN CHOICES ON STUDENTS.sid = CHOICES.sid
JOIN COURSES ON CHOICES.cid = COURSES.cid
WHERE COURSES.cname = 'java'
```

![image-20230925142435990](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925142435990.png)

#### Prac-2.1

> 使用等值连接查询姓名为sssht的学生所选的课程的编号和成绩

```postgresql
SELECT COURSES.cid, CHOICES.score
FROM CHOICES
JOIN COURSES ON CHOICES.cid = COURSES.cid
JOIN STUDENTS ON CHOICES.sid = STUDENTS.sid
WHERE STUDENTS.sname = 'sssht'
```

![image-20230925142512970](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925142512970.png)

#### Prac-2.2

> 使用谓词IN查询姓名为sssht的学生所选的课程的编号和成绩

```postgresql
SELECT cid, score
FROM CHOICES
WHERE sid IN (SELECT sid FROM STUDENTS WHERE sname = 'sssht')
```

![image-20230925142558820](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925142558820.png)

#### Prac-3

> 查询其他课时比课程C++多的课程的名称

```postgresql
SELECT cname
FROM COURSES
WHERE hour > (SELECT hour FROM COURSES WHERE cname = 'c++')
```

![image-20230925142657640](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925142657640.png)

#### Prac-4

> 实现集合交运算，查询既选修课程database又选修课程uml的学生的编号

```postgresql
SELECT sid
FROM CHOICES
WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'database')
INTERSECT
SELECT sid
FROM CHOICES
WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'uml')
```

![image-20230925142737793](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925142737793.png)

#### Prac-5

> 实现集合减运算，查询选修课程database而没有选修课程uml的学生的编号

```postgresql
SELECT sid
FROM CHOICES
WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'database')
EXCEPT
SELECT sid
FROM CHOICES
WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'uml')
```

![image-20230925142812316](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230925142812316.png)

## 5. 实验心得

在完成上述实验后，我对数据库查询语言有了更深入的了解。

- 了解了不同类型的连接操作，如内连接和外连接
- 如何使用聚合函数和子查询进行高级查询
- 如何使用等值连接和谓词IN来查询特定条件下的数据
- 如何使用GROUP BY和HAVING子句进行分组和过滤数据
- 通过使用集合运算符，执行交集、并集和差集操作，从而获取符合特定条件的数据。
- 如何使用子查询和嵌套查询来解决更复杂的查询问题。通过将多个查询语句组合在一起，获取更准确和详细的数据结果。

总的来说，这个实验对我来说是一次很有价值的学习经历。通过实际操作，我不仅理解了SQL查询语言的基本概念和语法，还学会了如何根据具体需求设计和执行复杂的查询操作。这将对我在日后的数据库开发和数据分析工作中非常有帮助。
