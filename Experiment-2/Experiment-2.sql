-- 创建人员表 PERSON(Pid, Pname, Page, Pgender)
CREATE TABLE PERSON (
	Pid INT PRIMARY KEY, 
	Pname VARCHAR(255), 
	Page INT CHECK (Page > 18), 
	Pgender VARCHAR(10)
);

-- 创建房间表 ROOM(Rid, Rname, Rarea)
CREATE TABLE ROOM (
  Rid INT PRIMARY KEY, 
  Rname VARCHAR(255), 
  Rarea FLOAT
);

-- 创建P-R表 P_R(Pid, Rid, Date)
CREATE TABLE P_R (
  Pid INT, 
  Rid INT, 
  Date DATE, 
  PRIMARY KEY (Pid, Rid), 
  FOREIGN KEY (Pid) REFERENCES PERSON(Pid), 
  FOREIGN KEY (Rid) REFERENCES ROOM(Rid)
);


-- 增加属性 Ptype
ALTER TABLE PERSON
ADD Ptype CHAR(10);

-- 取消约束 PERSON_PAGE_CHECK
ALTER TABLE PERSON
DROP CONSTRAINT PERSON_PAGE_CHECK;

-- 修改表 ROOM，将属性 Rname 的数据类型改为长度为 30
ALTER TABLE ROOM
ALTER COLUMN Rname TYPE VARCHAR(30);


-- 删除属性 Rarea
ALTER TABLE ROOM
DROP COLUMN Rarea;


-- 取消表 P_R
DROP TABLE P_R;


-- 为 ROOM 创建按 Rid 降序排列的索引
CREATE INDEX idx_ROOM_Rid ON ROOM (Rid DESC);


-- 为 PERSON 表创建按 Pid 升序排列的索引
CREATE INDEX idx_PERSON_Pid ON PERSON (Pid ASC);


-- 创建表 PERSON 的按 Pname 升序排列的唯一性索引
CREATE UNIQUE INDEX idx_PERSON_Pname ON PERSON (Pname ASC);


-- 取消 PERSON 表 Pid 升序索引
DROP INDEX idx_PERSON_Pis;