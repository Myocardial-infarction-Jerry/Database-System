-- 清空数据库并重新导入
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
\cd '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-7'
\i STUDENTS.sql
\i TEACHERS.sql
\i COURSES.sql
\i CHOICES.sql


-- 创建一个行列子集视图（视图名为CS），给出选课成绩合格的学生的编号，所选课程号和该课程成绩
CREATE VIEW CS AS
SELECT sid, cid, score
FROM CHOICES
WHERE score >= 60;


-- 创建基于多个基表的视图(视图名为SCT)，这个视图由学生姓名和其所选修的课程名及讲授该课 程的教师姓名构成
CREATE VIEW SCT AS
SELECT STUDENTS.sname, COURSES.cname, TEACHERS.tname
FROM CHOICES
JOIN STUDENTS ON CHOICES.sid = STUDENTS.sid
JOIN COURSES ON CHOICES.cid = COURSES.cid
JOIN TEACHERS ON CHOICES.tid = TEACHERS.tid;


-- 创建带表达式的视图，由学生姓名、所选课程名和所有课程成绩都比原来多5分这几个属性组成
CREATE VIEW SCG AS 
SELECT STUDENTS.sname, COURSES.cname, CHOICES.score + 5 AS new_score 
FROM CHOICES 
JOIN STUDENTS ON CHOICES.sid = STUDENTS.sid 
JOIN COURSES ON CHOICES.cid = COURSES.cid;


-- 创建分组视图，将学生的学号及其平均成绩定义为一个视图
CREATE VIEW AverageScore AS 
SELECT sid, AVG(score) AS average_score
FROM CHOICES 
GROUP BY sid; 


-- 创建一个基于视图的视图，基于(1)中建立的视图，定义一个包括学生编号，学生所选课程数目和平均成绩的视图
CREATE VIEW StudentSummary AS 
SELECT CS.sid, COUNT(CS.cid) AS course_count, AverageScore.average_score 
FROM CS 
JOIN AverageScore ON CS.sid = AverageScore.sid
GROUP BY CS.sid, AverageScore.average_score;


-- 查询所有选修课程Software Engineering的学生姓名
COPY(
    SELECT sname
    FROM SCT
    WHERE cname = 'software engineering'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-7/Task-6.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 插入元组(600000000,823069829,10010,59)到视图CS中。若是在视图的定义中存在WITH CHECK OPTION子句对插入操作有什么影响?
INSERT INTO CS (sid, cid, score) 
VALUES ('600000000', '10010', 59); 


-- 取消视图SCT和视图CS
DROP VIEW SCT CASCADE;
DROP VIEW CS CASCADE;


-- 定义选课信息和课程名称的视图VIEWC
CREATE VIEW VIEWC AS
SELECT CHOICES.sid, CHOICES.tid, CHOICES.cid, CHOICES.score, COURSES.cname
FROM CHOICES
JOIN COURSES ON CHOICES.cid = COURSES.cid;


-- 定义学生姓名与选课信息的视图VIEWS
CREATE VIEW VIEWS AS
SELECT CHOICES.sid, CHOICES.tid, CHOICES.cid, CHOICES.score, STUDENTS.sname
FROM CHOICES
JOIN STUDENTS ON STUDENTS.sid = CHOICES.sid;


-- 定义年级低于1998的学生的视图S1(SID,SNAME,GRADE)
CREATE VIEW S1 AS
SELECT sid, sname, grade
FROM STUDENTS
WHERE grade < 1998;


-- 查询学生为“uxjof”的学生的选课信息
COPY
(
    SELECT * FROM VIEWS
    WHERE sname = 'uxjof'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-7/Prac-4.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 查询选修课程“UML”的学生的编号和成绩
COPY
(
    SELECT * FROM VIEWC
    WHERE cname = 'uml'
)
TO '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-7/Prac-5.csv'
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');


-- 向视图S1插入记录(“60000001,Lily,2001”)
INSERT INTO S1 (sid, sname, grade)
VALUES ('60000001', 'Lily', 2001);


-- 定义包括更新和插入约束的视图S1，尝试向视图插入记录(“60000001,Lily,1997")，删除所有年级为1999的学生记录，讨论更新和插入约束带来的影响
DROP VIEW S1;

CREATE VIEW S1 AS
SELECT sid, sname, grade
FROM STUDENTS
WITH CHECK OPTION;

INSERT INTO S1 (sid, sname, grade)
VALUES ('60000001', 'Lily', 1997);

DELETE FROM S1
WHERE grade = 1999;


-- 在视图VIEWS中将姓名为“uxjof”的学生的选课成绩都加上5分
UPDATE VIEWS 
SET score = score + 5 
WHERE sname = 'uxjof';


-- 取消以上建立的所有视图
DROP VIEW VIEWC CASCADE;
DROP VIEW VIEWS CASCADE;
DROP VIEW S1 CASCADE;

