# Database-System Experiment-3

*21307289 刘森元*

## 1. 实验目的

熟悉SQL语句的数据查询语言，能够使用SQL语句对数据库进行单表查询。

## 2. 实验环境

Macbook Pro 2021 (Apple M1 Pro)

MacOS Ventura 13.5.2

PostgreSQL 15.4 (Homebrew)

Z-shell 5.9

## 3. 实验内容

- 查询的目标表达式为所有列、指定列或指定列的运算
- 使用DISTINCT保留字消除重复行
- 对查询结果排序和分组
- 级和分组使用集函数进行各项统计

## 4. 实验步骤

首先使用 `\i` 命令执行 sql 脚本，将数据导入到数据库中

```postgresql
Experiment-3=# \i STUDENTS.sql
Experiment-3=# \i TEACHERS.sql
Experiment-3=# \i COURSES.sql
Experiment-3=# \i CHOICES.sql
```

### 课内实验

以下完整代码见 [Experiment-3.sql](Experiment-3.sql)，在 PostgreSQL 中使用 `\i Experiment-3.sql` 执行有如下结果

![image-20230920093736011](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230920093736011.png)

#### Task-1

> 查询年级为 2001 的所有学生的名称，按编号升序排列

使用以下代码查询

```postgresql
-- 查询年级为 2001 的所有学生的名称，按照编号升序排列
COPY (
    SELECT sid, sname FROM STUDENTS
    WHERE grade = 2001
    ORDER BY sid ASC
) 
TO '/Users/Documents/Github/Database-System/Experiment-3/Task-1.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '保存到 Task-1.csv'
```

有输出结果 [Task-1.csv](Task-1.csv)

![image-20230919114950522](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230919114950522.png)

#### Task-2

> 查询学生的选课成绩合格的课程成绩，并把成绩换算为积点(60分对应积点为1,每增加1分，积点增加0.1)

使用以下代码查询

```postgresql
-- 查询学生的选课成绩合格的课程成绩，并把成绩换算为积点 (60 分对应积点为 1，每增加1分，积点增加 0.1)
COPY (
    SELECT sname, cname, score, (score - 50) * 0.1 AS credit
    FROM CHOICES
    JOIN COURSES ON CHOICES.cid = COURSES.cid
    JOIN STUDENTS ON CHOICES.sid = STUDENTS.sid
    WHERE score >= 60
    ORDER BY sname, cname
) 
TO '/Users/Documents/Github/Database-System/Experiment-3/Task-2.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '保存到 Task-2.csv'
```

有输出结果 [Task-2.csv](Task-2.csv)

![image-20230919115002678](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230919115002678.png)

#### Task-3

> 查询课时是48或64的课程的名称

使用以下代码查询

```postgresql
-- 查询课时是 48 或 64 的课程的名称
COPY (
    SELECT cname FROM COURSES
    WHERE hour IN (48, 64)
) 
TO '/Users/Documents/Github/Database-System/Experiment-3/Task-3.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '保存到 Task-3.csv'
```

有输出结果 [Task-3.csv](Task-3.csv)

![image-20230920093552305](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230920093552305.png)

#### Task-4

> 查询所有课程名称中含有data的课程编号

使用以下代码进行查询

```postgresql
-- 查询所有课程名称中含有 "data" 的课程编号
COPY (
    SELECT cid FROM COURSES
    WHERE cname LIKE '%data%'
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Task-4.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '保存到 Task-4.csv'
```

有输出结果 [Task-4.csv](Task-4.csv)

![image-20230920093928921](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230920093928921.png)

#### Task-5

> 查询所有选课记录的课程号(不重复显示)

使用以下命令进行查询

```postgresql
-- 查询所有选课记录的课程号（不重复显示）
COPY (
    SELECT DISTINCT cid FROM CHOICES
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Task-5.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '保存到 Task-5.csv'
```

有输出结果 [Task-5.csv](Task-5.csv)

![image-20230920094158152](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230920094158152.png)

#### Task-6

> 统计所有老师的平均工资

使用以下指令进行查询

```postgresql
-- 统计所有老师的平均工资
\echo '所有老师的平均工资为'
SELECT AVG(salary) FROM TEACHERS;
```

有以下结果

![image-20230920094302936](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230920094302936.png)

#### Task-7

> 查询所有学生的编号，姓名和平均成绩，按总平均成绩降序排列

使用以下代码进行查询

```postgresql
-- 查询所有学生的编号，姓名和平均成绩，按总平均成绩降序排列
COPY (
    SELECT STUDENTS.sid, STUDENTS.sname, AVG(score) AS avg_score
    FROM STUDENTS
    JOIN CHOICES ON STUDENTS.sid = CHOICES.sid
    GROUP BY STUDENTS.sid, STUDENTS.sname
    HAVING AVG(score) IS NOT NULL
    ORDER BY avg_score DESC
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Task-7.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '保存到 Task-7.csv'
```

有输出结果 [Task-7.csv](Task-7.csv)

![image-20230920100735843](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230920100735843.png)

#### Task-8

> 统计各个课程的选课人数和平均成绩

通过以下代码查询

```postgresql
-- 统计各个课程的选课人数和平均成绩
COPY (
    SELECT COURSES.cid, COURSES.cname, COUNT(sid) AS enrollment, AVG(score) AS avg_score
    FROM COURSES
    LEFT JOIN CHOICES ON COURSES.cid = CHOICES.cid
    GROUP BY COURSES.cid, COURSES.cname
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Task-8.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '保存到 Task-8.csv'
```

有输出结果 [Task-8.csv](Task-8.csv)

![image-20230920101426984](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230920101426984.png)

#### Task-9

> 查询至少选修了三门课程的学生编号

使用以下命令查询

```postgresql
-- 查询至少选修了三门课程的学生编号
COPY (
    SELECT sid 
    FROM choices 
    GROUP BY sid 
    HAVING COUNT(DISTINCT cid) >= 3
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Task-9.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '保存到 Task-9.csv'
```

有输出结果 [Task-9.csv](Task-9.csv)

![image-20230920101746708](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230920101746708.png)

### 自我实践

以下完整代码见 [Practice-3.sql](Practice-3.sql)，在 PostgreSQL 中使用 `\i Practice-3.sql` 执行有如下结果

![image-20230920102114167](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230920102114167.png)

其结果如上，详见具体文件。

*Practice-3.sql*

```postgresql
-- 查询全部课程的详细记录
COPY (
    SELECT * FROM COURSES
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Prac-1.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '将全部课程的详细记录保存到 Prac-1.csv'


-- 查询所有有选修课的学生的编号
COPY (
    SELECT DISTINCT sid FROM CHOICES
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Prac-2.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '将所有有选修课的学生的编号保存到 Prac-2.csv'


-- 查询课时 <88 (小时) 的课程的编号
COPY (
    SELECT cid FROM COURSES WHERE hour < 88
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Prac-3.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '将课时 <88 (小时) 的课程的编号保存到 Prac-3.csv'


-- 找出总分超过 400 分的学生
COPY (
    SELECT sid FROM (
        SELECT sid, SUM(score) AS total_score
        FROM CHOICES
        GROUP BY sid
    ) AS subquery
    WHERE total_score > 400
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Prac-4.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '将总分超过 400 分的学生保存到 Prac-4.csv'


-- 查询课程的总数
\echo '课程总数为'
SELECT COUNT(*) FROM COURSES;


-- 查询所有课程和选修该课程的学生总数
COPY (
    SELECT c.cid, c.cname, COUNT(DISTINCT ch.sid) AS student_count
    FROM COURSES c
    JOIN CHOICES ch ON c.cid = ch.cid
    GROUP BY c.cid, c.cname
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Prac-6.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '将所有课程和选修该课程的学生总数保存到 Prac-6.csv'


-- 查询选修成绩合格的课程超过两门的学生编号
COPY (
    SELECT sid
    FROM CHOICES
    WHERE score >= 60
    GROUP BY sid
    HAVING COUNT(DISTINCT cid) > 2
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Prac-7.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '将选修成绩合格的课程超过两门的学生编号保存到 Prac-7.csv'


-- 统计各个学生的选修课程数目和平均成绩
COPY (
    SELECT sid, COUNT(DISTINCT cid) AS course_count, AVG(score) AS average_score
    FROM CHOICES
    GROUP BY sid
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Prac-8.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '将各个学生的选修课程数目和平均成绩保存到 Prac-8.csv'
```

## 5. 实验心得

对SQL语句的数据查询语言有了更深入的了解，并且能够运用SQL语句对数据库进行单表查询操作。这些实验对我的学习和提升非常有帮助。
