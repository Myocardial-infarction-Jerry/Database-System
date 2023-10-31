-- 查询学号850955252的学生同年级的所有学生资料
COPY(
    SELECT *
    FROM STUDENTS
    WHERE grade = (SELECT grade FROM STUDENTS WHERE sid = '850955252')
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Task-1.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询所有的有选课的学生的详细信息
COPY(
    SELECT *
    FROM STUDENTS
    WHERE sid IN (SELECT sid FROM CHOICES)
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Task-2.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询没有学生选的课程的编号
COPY(
    SELECT cid
    FROM COURSES
    WHERE cid NOT IN (SELECT DISTINCT cid FROM CHOICES)
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Task-3.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询选修了课程名为C++的学生学号和姓名
COPY(
    SELECT STUDENTS.sid, STUDENTS.sname
    FROM STUDENTS
    JOIN CHOICES ON STUDENTS.sid = CHOICES.sid
    JOIN COURSES ON CHOICES.cid = COURSES.cid
    WHERE COURSES.cname = 'c++'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Task-4.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 找出选修课程成绩最差的选课记录
COPY(
    SELECT *
    FROM CHOICES
    WHERE (cid, score) IN (
        SELECT cid, MIN(score)
        FROM CHOICES
        GROUP BY cid
    )
    ORDER BY CHOICES.cid, CHOICES.no
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Task-5.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 找出和课程UML或课程C++的课时一样的课程名称
COPY(
    SELECT cname
    FROM COURSES
    WHERE hour = (SELECT hour FROM COURSES WHERE cname = 'uml')
    OR hour = (SELECT hour FROM COURSES WHERE cname = 'c++')
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Task-6.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询所有选修编号10001的课程的学生的姓名
COPY(
    SELECT STUDENTS.sname
    FROM STUDENTS
    JOIN CHOICES ON STUDENTS.sid = CHOICES.sid
    WHERE CHOICES.cid = '10001'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Task-7.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询选修了所有课程的学生姓名
COPY(
    SELECT sname
    FROM STUDENTS
    WHERE STUDENTS.sid IN (
        SELECT CHOICES.sid
        FROM CHOICES
        GROUP BY CHOICES.sid
        HAVING COUNT(DISTINCT CHOICES.cid) = (SELECT COUNT(DISTINCT COURSES.cid) FROM COURSES)
    )
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Task-8.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询选修C++课程的成绩比姓名为znkoo的学生高的所有学生的编号和姓名
COPY (
    SELECT STUDENTS.sid, STUDENTS.sname
    FROM STUDENTS
    JOIN CHOICES ON STUDENTS.sid = CHOICES.sid
    JOIN COURSES ON CHOICES.cid = COURSES.cid
    WHERE COURSES.cname = 'c++' AND CHOICES.score > (
        SELECT score
        FROM CHOICES
        JOIN STUDENTS ON CHOICES.sid = STUDENTS.sid
        WHERE STUDENTS.sname = 'znkoo' AND CHOICES.cid = (SELECT cid FROM COURSES WHERE cname = 'c++')
    )
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Prac-1.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 找出和学生883794999或学生850955252的年级一样的学生的姓名
COPY (
    SELECT sname
    FROM STUDENTS
    WHERE grade = (SELECT grade FROM STUDENTS WHERE sid = '88379499')
    OR grade = (SELECT grade FROM STUDENTS WHERE sid = '850955252')
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Prac-2.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询没有选修Java的学生名称
COPY (
    SELECT sname
    FROM STUDENTS
    WHERE sid NOT IN (
        SELECT DISTINCT sid
        FROM CHOICES
        JOIN COURSES ON CHOICES.cid = COURSES.cid
        WHERE COURSES.cname = 'java'
    )
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Prac-3.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');

-- 找出课时最少的课程的详细信息
COPY (
    SELECT *
    FROM COURSES
    WHERE hour = (SELECT MIN(hour) FROM COURSES)
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Prac-4.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询工资最高的教师的编号和开设的课程号
COPY (
    SELECT CHOICES.tid, CHOICES.cid
    FROM CHOICES
    JOIN TEACHERS ON TEACHERS.tid = CHOICES.tid
    WHERE TEACHERS.tid IN (
        SELECT tid
        FROM TEACHERS
        WHERE salary = (SELECT MAX(salary) FROM TEACHERS)
    )
    GROUP BY CHOICES.tid, CHOICES.cid
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Prac-5.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 找出选修课程ERP成绩最高的学生编号
COPY (
    SELECT DISTINCT sid
    FROM CHOICES
    WHERE score = (
        SELECT MAX(score) 
        FROM CHOICES
        JOIN COURSES ON CHOICES.cid = COURSES.cid
        WHERE COURSES.cname = 'erp'
    )
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Prac-6.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询没有学生选修的课程的名称
COPY (
    SELECT cname
    FROM COURSES
    WHERE cid NOT IN (
        SELECT DISTINCT cid
        FROM CHOICES
    )
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Prac-7.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 找出讲授课程UML的教师讲授的所有课程名称
COPY (
    SELECT DISTINCT tid, cname
    FROM COURSES
    JOIN CHOICES ON COURSES.cid = CHOICES.cid
    WHERE CHOICES.tid IN (
        SELECT tid
        FROM CHOICES
        WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'uml')
    )
    ORDER BY tid, cname
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Prac-8.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询选修了编号200102901的教师开设的所有课程的学生编号
COPY (
    WITH X AS (
        SELECT DISTINCT cid
        FROM CHOICES
        WHERE tid = '200102901'
    )
    SELECT sid
    FROM CHOICES
    WHERE sid IN (
        SELECT sid
        FROM CHOICES
        WHERE cid IN (SELECT cid FROM X)
        GROUP BY sid
        HAVING COUNT(DISTINCT cid) = (SELECT COUNT(*) FROM X)
    )
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Prac-9.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询选修课程Database的学生集合与选修课程UML的学生集合的并集
COPY (
    SELECT DISTINCT sid
    FROM CHOICES
    JOIN COURSES ON CHOICES.cid = COURSES.cid
    WHERE cname = 'database'
    OR cname = 'uml'
    ORDER BY sid
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-5/Prac-10.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');