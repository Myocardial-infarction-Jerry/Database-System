-- 清空数据库并重新导入
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
\cd '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-6'
\i STUDENTS.sql
\i TEACHERS.sql
\i COURSES.sql
\i CHOICES.sql

-- 以下操作涉及到删除，修改 CHOICES 中约束为 ON DELETE CASCADE
-- 删除旧的外键约束
ALTER TABLE CHOICES
DROP CONSTRAINT IF EXISTS fk_choices_courses;
ALTER TABLE CHOICES
DROP CONSTRAINT IF EXISTS fk_choices_students;
ALTER TABLE CHOICES
DROP CONSTRAINT IF EXISTS fk_choices_teachers;
-- 添加新的外键约束
ALTER TABLE CHOICES
ADD CONSTRAINT fk_choices_courses
FOREIGN KEY (cid) REFERENCES COURSES(cid) ON DELETE CASCADE;
ALTER TABLE CHOICES
ADD CONSTRAINT fk_choices_students
FOREIGN KEY (sid) REFERENCES STUDENTS(sid) ON DELETE CASCADE;
ALTER TABLE CHOICES
ADD CONSTRAINT fk_choices_teachers
FOREIGN KEY (tid) REFERENCES TEACHERS(tid) ON DELETE CASCADE;

-- 使用SQL语句向STUDENTS表中插入元组(编号：700045678；名字：LiMing；EMAIL：LX@cdemg.com；年级：1992)
INSERT INTO STUDENTS (sid, sname, email, grade)
VALUES (700045678, 'LiMing', 'LX@cdemg.com', 1992);


-- 对每个课程，求学生的选课人数和学生的平均成绩，并把结果存入数据库。使用SELECT INTO和 INSERT INTO两种方法实现。（提示：可先创建一个新表再插入数据）
SELECT cid, COUNT(*) AS num_students, AVG(score) AS average_score
INTO new_table
FROM CHOICES
GROUP BY cid;

INSERT INTO new_table (cid, num_students, average_score)
SELECT cid, COUNT(*) AS num_students, AVG(score) AS average_score
FROM CHOICES
GROUP BY cid;


-- 在STUDENTS表中使用SQL语句将姓名为“LiMing”的学生的年级改为“2002”
UPDATE STUDENTS
SET grade = 2002
WHERE sname = 'LiMing';


-- 在TEACHERS表中使用SQL语句将所有教师的工资多加500元
UPDATE TEACHERS
SET salary = salary + 500;


-- 将姓名为zapyv的学生的课程“C”的成绩加上5分
UPDATE CHOICES
SET score = score + 5
WHERE sid = (SELECT sid FROM STUDENTS WHERE sname = 'zapyv')
AND cid = (SELECT cid FROM COURSES WHERE cname = 'C');


-- 在STUDENTS表中使用SQL语句删除姓名为“LiMing”的学生信息
DELETE FROM STUDENTS
WHERE sname = 'LiMing';


-- 删除所有选修课程“Java”的选课记录
DELETE FROM CHOICES
WHERE cid = (SELECT cid FROM COURSES WHERE cname = 'Java');


-- 对COURSES表做删去时间<48的元组的操作，并讨论该删除操作所受到的约束
BEGIN TRANSACTION;
-- 禁用外键约束
ALTER TABLE CHOICES DROP CONSTRAINT FK_CHOICES_COURSES;
-- 删除COURSES表中时间<48的元组
DELETE FROM COURSES
WHERE hour < 48;
-- 启用外键约束
ALTER TABLE CHOICES ADD CONSTRAINT FK_CHOICES_COURSES FOREIGN KEY (cid) REFERENCES COURSES (cid);
COMMIT;
-- 该删除操作可能受到外键约束的限制，删除操作会失败。在删除之前，需要通过设置外键约束的级联删除或设置NULL来处理相关数据。


-- 向STUDENTS表插入编号是“800022222”且姓名是“WangLan”的元组
INSERT INTO STUDENTS (sid, sname)
VALUES ('800022222', 'WangLan');


-- 向TEACHERS表插入元组(“200001000”,“LXL”,“s4zrck@pew.net”,“3024”)
INSERT INTO TEACHERS (tid, tname, email, salary)
VALUES ('200001000', 'LXL', 's4zrck@pew.net', '3024');


-- 将TEACHERS表中编号为“200010493”的老师工资改为4000
UPDATE TEACHERS
SET salary = 4000
WHERE tid = '200010493';


-- 将TEACHERS表中所有工资小于2500的老师工资改为2500
UPDATE TEACHERS
SET salary = 2500
WHERE salary < 2500;


-- 将由编号为“200016731”的老师讲授的课程全部改成由姓名为“rnupx”的老师讲授
UPDATE CHOICES
SET tid = (SELECT tid FROM TEACHERS WHERE tname = 'rnupx')
WHERE tid = '200016731';


-- 更新编号“800071780”的学生年级为“2001”
UPDATE STUDENTS
SET grade = '2001'
WHERE sid = '800071780';


-- 删除没有学生选修的课程
DELETE FROM COURSES
WHERE cid NOT IN (SELECT DISTINCT cid FROM CHOICES);


-- 删除年级高于1998的学生信息
DELETE FROM STUDENTS
WHERE grade > 1998;


-- 删除没有选修课程的学生信息
DELETE FROM STUDENTS
WHERE sid NOT IN (SELECT DISTINCT sid FROM CHOICES);


-- 删除成绩不及格的选课记录
DELETE FROM CHOICES
WHERE score < 60;

