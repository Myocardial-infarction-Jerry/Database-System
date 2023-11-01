-- 重建数据库
DROP DATABASE "school";
DROP USER USER1;
DROP USER USER2;
DROP USER USER3;
CREATE DATABASE "school";
\c school
\cd '/Users/qiu_nangong/Documents/Github/Database-System/Experiment-8'
\i STUDENTS.sql
\i TEACHERS.sql
\i COURSES.sql
\i CHOICES.sql


-- 查询所有选课记录的成绩并将其换算为五分制(满分为5分，合格为3分),注意SCORE取NULL值的情况。
SELECT no, sid, cid, tid, 
    CASE 
        WHEN score IS NULL THEN NULL
        ELSE ROUND(score / 20.0, 3)
    END AS converted_score
FROM CHOICES;


-- 查询选修编号为10028的课程的学生的人数，其中成绩合格的学生人数，不合格的学生人数，讨论NULL值的特殊含义。
SELECT COUNT(*) AS total_students,
       COUNT(CASE WHEN score >= 60 THEN 1 END) AS passed_students,
       COUNT(CASE WHEN score < 60 THEN 1 END) AS failed_students
FROM CHOICES
WHERE cid = '10028';


-- 通过实验检验在使用ORDER BY进行排序时，取NULL的项是否出现在结果中?如果有，在什么位置?
SELECT *
FROM choices
ORDER BY score DESC;
-- 取NULL的项出现在结果中，其位置在降序排序的表头


-- 在上面的查询的过程中如果加上保留字DISTINCT会有什么效果呢?
-- 在前面的查询中加入DISTINCT关键字将从结果中删除重复的行，确保每行基于所选列的唯一性。

-- 使用分组GROUP BY对取值为NULL的项的处理方式如下：
-- 首先，我们创建一个示例表格来演示：
-- ```postgresql
-- CREATE TABLE example (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(50),
--     score INT
-- );
-- INSERT INTO example (name, score) VALUES
--     ('Alice', 80),
--     ('Bob', NULL),
--     ('Charlie', 70),
--     ('Dave', NULL),
--     ('Eve', 90);
-- ```
-- 现在，我们将对该表格使用分组GROUP BY，并观察对NULL值的处理方式：
-- ```postgresql
-- SELECT name, AVG(score) AS average_score
-- FROM example
-- GROUP BY name;
-- ```
-- 结果如下：
-- ```
--    name   | average_score
-- ----------+---------------
--  Alice    |            80
--  Bob      |
--  Charlie  |            70
--  Dave     |
--  Eve      |            90
-- ```
-- 在分组GROUP BY的结果中，对于NULL值，它们会被作为一个独立的分组显示，并且在聚合函数中显示为空值。
-- 在上述示例中，Bob和Dave的分数为NULL，因此它们各自被作为一个独立的分组显示，并在average_score列中显示为空值。


-- 结合分组，使用集合函数求每个同学的平均分，总的选课记录，最高成绩，最低成绩，总成绩。
SELECT sid, AVG(COALESCE(score, 0)) AS average_score,
       COUNT(*) AS total_records,
       MAX(score) AS max_score,
       MIN(score) AS min_score,
       SUM(CASE WHEN score IS NULL THEN 0 ELSE score END) AS total_score
FROM choices
GROUP BY sid;


-- 查询成绩小于0的选课记录，统计总数、平均分、最大值和最小值。
SELECT COUNT(*) AS total_records,
       AVG(score) AS average_score,
       MAX(score) AS max_score,
       MIN(score) AS min_score
FROM choices
WHERE score < 0;


-- 查询所有课程记录的上课学时，并以一学期十八个星期计算每个课程的总学时，注意HOUR取NULL值的情况。
SELECT cid, COALESCE(SUM(hour), 0) AS hour, COALESCE(SUM(hour), 0) * 18 AS total_hour
FROM courses
GROUP BY cid;


-- 通过查询选修课程C++的学生的人数，其中成绩合格的学生人数，不合格的学生人数，讨论NULL值的特殊含义。
SELECT COUNT(DISTINCT sid) AS total_students,
       COUNT(DISTINCT CASE WHEN score >= 60 THEN sid END) AS passed_students,
       COUNT(DISTINCT CASE WHEN score < 60 THEN sid END) AS failed_students
FROM CHOICES
WHERE cid = 'c++';


-- 通过实验检验在使用ORDER BY进行排序时，取NULL的项是否出现在结果中?如果有，在什么位置?
SELECT sid
FROM CHOICES
ORDER BY score;
-- 出现在升序排序的表末


-- 在上面的查询的过程中如果加上保留字DISTINCT会有什么效果呢?
-- 如果在查询中加入DISTINCT关键字，它将从结果集中消除重复的行


-- 按年级对所有的学生进行分组，能得到多少个组?与现实的情况有什么不同?
SELECT COUNT(DISTINCT grade) AS group_number
FROM STUDENTS;
-- 与现实情况相比，查询结果给出了按年级分组的数量。然而，需要注意的是，查询结果可能与实际情况不完全一致。实际情况中，可能存在一些特殊情况，例如有些学生可能没有年级，或者年级的定义可能不仅仅是一个简单的数值。因此，实际的学生分组数量可能会有所不同。


-- 结合分组，使用集合函数求每个课程选修的学生的平均分，总的选课记录数，最高成绩，最低成绩，讨论考察取空值的项对集合函数的作用的影响。
SELECT cid,
       AVG(score) AS average_score,
       COUNT(*) AS total_records,
       MAX(score) AS max_score,
       MIN(score) AS min_score
FROM CHOICES
GROUP BY cid;