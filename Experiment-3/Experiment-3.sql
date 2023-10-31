-- 查询年级为 2001 的所有学生的名称，按照编号升序排列
COPY (
    SELECT sid, sname FROM STUDENTS
    WHERE grade = 2001
    ORDER BY sid ASC
) 
TO '/Users/Documents/Github/Database-System/Experiment-3/Task-1.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '保存到 Task-1.csv'


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


-- 查询课时是 48 或 64 的课程的名称
COPY (
    SELECT cname FROM COURSES
    WHERE hour IN (48, 64)
) 
TO '/Users/Documents/Github/Database-System/Experiment-3/Task-3.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '保存到 Task-3.csv'


-- 查询所有课程名称中含有 "data" 的课程编号
COPY (
    SELECT cid FROM COURSES
    WHERE cname LIKE '%data%'
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Task-4.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '保存到 Task-4.csv'


-- 查询所有选课记录的课程号（不重复显示）
COPY (
    SELECT DISTINCT cid FROM CHOICES
)
TO '/Users/Documents/Github/Database-System/Experiment-3/Task-5.csv' 
WITH (FORMAT 'csv', HEADER TRUE, DELIMITER ',');
\echo '保存到 Task-5.csv'


-- 统计所有老师的平均工资
\echo '所有老师的平均工资为'
SELECT AVG(salary) FROM TEACHERS;


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