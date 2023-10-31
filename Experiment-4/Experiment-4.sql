-- 查询编号为800009026的学生所选的全部课程的课程名和成绩
COPY (
    SELECT COURSES.cname, CHOICES.score 
    FROM CHOICES 
    JOIN COURSES ON CHOICES.cid = COURSES.cid 
    WHERE CHOICES.sid = '800009026'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Task-1.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询所有选了"database"的课程的学生的学号
COPY (
    SELECT CHOICES.sid 
    FROM CHOICES 
    JOIN COURSES ON CHOICES.cid = COURSES.cid 
    WHERE COURSES.cname = 'database'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Task-2.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 求出选择了同一个课程的学生对
COPY (
    SELECT c1.sid, c2.sid 
    FROM CHOICES c1 
    JOIN CHOICES c2 ON c1.cid = c2.cid 
    WHERE c1.sid <> c2.sid
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Task-3.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 求出至少被两名学生选修的课程编号
COPY (
    SELECT CHOICES.cid 
    FROM CHOICES 
    GROUP BY CHOICES.cid 
    HAVING COUNT(DISTINCT CHOICES.sid) >= 2
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Task-4.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询选修了编号为800009026的学生所选的某个课程的学生编号
COPY (
    SELECT DISTINCT CHOICES.sid 
    FROM CHOICES 
    WHERE CHOICES.cid IN (
        SELECT CHOICES.cid 
        FROM CHOICES 
        WHERE CHOICES.sid = '800009026'
    )
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Task-5.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询学生的基本信息及选修课程编号和成绩
COPY (
    SELECT STUDENTS.sid, STUDENTS.sname, STUDENTS.email, STUDENTS.grade, CHOICES.cid, CHOICES.score 
    FROM STUDENTS 
    JOIN CHOICES ON STUDENTS.sid = CHOICES.sid
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Task-6.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询学号为850955252的学生的姓名和选修的课程名称及成绩
COPY (
    SELECT STUDENTS.sname, COURSES.cname, CHOICES.score 
    FROM STUDENTS 
    JOIN CHOICES ON STUDENTS.sid = CHOICES.sid 
    JOIN COURSES ON CHOICES.cid = COURSES.cid 
    WHERE STUDENTS.sid = '850955252'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Task-7.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 利用集合运算，查询选修课程C++或课程java的学生的学号
COPY (
    SELECT CHOICES.sid 
    FROM CHOICES 
    JOIN COURSES ON CHOICES.cid = COURSES.cid 
    WHERE COURSES.cname = 'c++' OR COURSES.cname = 'java'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Task-8.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 实现集合交运算，查询既选修课程C++又选修课程java的学生的学号
COPY (
    SELECT CHOICES.sid 
    FROM CHOICES 
    JOIN COURSES ON CHOICES.cid = COURSES.cid 
    WHERE COURSES.cname = 'c++' 
    INTERSECT 
    SELECT CHOICES.sid 
    FROM CHOICES 
    JOIN COURSES ON CHOICES.cid = COURSES.cid 
    WHERE COURSES.cname = 'java'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Task-9.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 实现集合减运算，查询选修课程C++而没有选修课程java的学生的学号
COPY (
    SELECT CHOICES.sid 
    FROM CHOICES 
    JOIN COURSES ON CHOICES.cid = COURSES.cid 
    WHERE COURSES.cname = 'c++' 
    EXCEPT 
    SELECT CHOICES.sid 
    FROM CHOICES 
    JOIN COURSES ON CHOICES.cid = COURSES.cid 
    WHERE COURSES.cname = 'java'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Task-10.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询选修java的所有学生的编号及姓名 
COPY (
    SELECT STUDENTS.sid, STUDENTS.sname
    FROM STUDENTS
    JOIN CHOICES ON STUDENTS.sid = CHOICES.sid
    JOIN COURSES ON CHOICES.cid = COURSES.cid
    WHERE COURSES.cname = 'java'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Prac-1.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 使用等值连接查询姓名为sssht的学生所选的课程的编号和成绩
COPY (
    SELECT COURSES.cid, CHOICES.score
    FROM CHOICES
    JOIN COURSES ON CHOICES.cid = COURSES.cid
    JOIN STUDENTS ON CHOICES.sid = STUDENTS.sid
    WHERE STUDENTS.sname = 'sssht'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Prac-2.1.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 使用谓词IN查询姓名为sssht的学生所选的课程的编号和成绩
COPY (
    SELECT cid, score
    FROM CHOICES
    WHERE sid IN (SELECT sid FROM STUDENTS WHERE sname = 'sssht')
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Prac-2.2.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询其他课时比课程C++多的课程的名称
COPY (
    SELECT cname
    FROM COURSES
    WHERE hour > (SELECT hour FROM COURSES WHERE cname = 'c++')
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Prac-3.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 实现集合交运算，查询既选修课程database又选修课程uml的学生的编号
COPY (
    SELECT sid
    FROM CHOICES
    WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'database')
    INTERSECT
    SELECT sid
    FROM CHOICES
    WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'uml')
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Prac-4.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 实现集合减运算，查询选修课程database而没有选修课程uml的学生的编号
COPY (
    SELECT sid
    FROM CHOICES
    WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'database')
    EXCEPT
    SELECT sid
    FROM CHOICES
    WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'uml')
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-4/Prac-5.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');