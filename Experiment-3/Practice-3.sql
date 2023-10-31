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