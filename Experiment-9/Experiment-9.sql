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