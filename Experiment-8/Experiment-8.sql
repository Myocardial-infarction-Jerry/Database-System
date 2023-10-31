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

-- 创建用户
CREATE USER USER1 PASSWORD '111';
CREATE USER USER2 PASSWORD '222';
CREATE USER USER3 PASSWORD '333';

-- 授予所有用户对表COURSES的查询权限
GRANT SELECT ON COURSES TO USER1, USER2, USER3; 
 
-- 授予USER1对表STUDENTS的插入和更新权限，但不授予删除权限，并且授予USER1传播这两个权限的权利 
GRANT INSERT, UPDATE ON STUDENTS TO USER1 WITH GRANT OPTION;
 
-- 允许USER2在表CHOICES中插入元组，更新的SCORE列，可以选取除了SID以外的所有列 
GRANT INSERT, UPDATE (score) ON CHOICES TO USER2; 
GRANT SELECT (no, tid, cid, score) ON CHOICES TO USER2;

-- USER1授予USER2对表STUDENTS插入和更新的权限，并且授予USER2传播插入操作的权利 
\c - user1
GRANT INSERT, UPDATE ON STUDENTS TO USER2; 
GRANT INSERT ON STUDENTS TO USER2 WITH GRANT OPTION; 
 
-- 收回对USER1对表COURSES查询权限的授权
\c - qiu_nangong
REVOKE SELECT ON COURSES FROM USER1; 
 
-- 由上面2.和4.的授权，再由USER2对USER3授予表STUDENTS插入和更新的权限，并且授予USER3传播插入操作的权利 
\c - user2
GRANT INSERT, UPDATE ON STUDENTS TO USER3; 
GRANT INSERT ON STUDENTS TO USER3 WITH GRANT OPTION; 

-- 授予所有用户对表STUDENTS的查询权限 
GRANT SELECT ON STUDENTS TO USER1, USER2, USER3;
 
-- 授予所有用户对表COURSES的查询和更新权限 
GRANT SELECT, UPDATE ON COURSES TO USER1, USER2, USER3; 
 
-- 授予USER1对表TEACHERS的查询、更新工资的权限，并且允许USER1可以传播这些权限 
GRANT SELECT, UPDATE (salary) ON TEACHERS TO USER1 WITH GRANT OPTION; 
 
-- 授予USER2对表CHOICES的查询、更新成绩的权限 
GRANT SELECT, UPDATE (score) ON CHOICES TO USER2; 
 
-- 授予USER2对表TEACHERS的除了工资之外的所有信息的查询 
GRANT SELECT (tid, tname, email) ON TEACHERS TO USER2;
 
-- 由USER1授予USER2对表TEACHERS的查询权限和传播的此项权限的权利 
\c - user1
GRANT SELECT ON TEACHERS TO USER2 WITH GRANT OPTION;
 
-- 由USER2授予USER3对表TEACHERS的查询权限和传播的此项权限的权利。再由USER3授予USER2上述权限 
\c - user2
GRANT SELECT ON TEACHERS TO USER3 WITH GRANT OPTION; 
\c - user3
GRANT SELECT ON TEACHERS TO USER2 WITH GRANT OPTION; 
 
-- 取消USER1对表STUDENTS的查询权限，考虑由USER2的身份对表STUDENTS进行查询，操作能否成功？为什么？ 
\c - qiu_nangong
REVOKE SELECT ON STUDENTS FROM USER1; 
\c - user2
SELECT COUNT(*) FROM STUDENTS;
 
-- 取消USER1和USER2对表COURSES的权限 
\c - qiu_nangong
REVOKE SELECT, UPDATE ON COURSES FROM USER1, USER2; 