# Database-System Experiment-2

*21307289 刘森元*

## 1. 实验目的

熟悉 SQL 的数据定义语言，能够熟练地使用 SQL 语句来创建和更改基本表，创建和取消索引。

## 2. 实验环境

Macbook Pro 2021 (Apple M1 Pro)

macOS Monterey 12.5

PostgreSQL 15.4 (Homebrew)

Z-shell 5.8.1

## 3. 实验内容

- 使用 `CREATE` 语句创建基本表
- 更改基本表的定义，增加列，删除列，修改列的数据类型
- 创建表的升降序索引
- 取消表、表的索引或表的约束

## 4. 实验步骤

***P.S. 由于 PostgreSQL 的语法规则规定，不能在变量名中包含 '#' 字符，故以下部分均使用 'id' 替换 '#'。***

### Task-1

> 使用 SQL 语句创建关系数据库表：
>
> - 人员表 `PERSON(Pid, Pname, Page, Pgender)`
> - 房间表 `ROOM(Rid, Rname, Rarea)`
> - 表 `P-R(Pid, Rid, Date)`
>
> 其中
>
> - `Pid`  是表 `PERSON` 的主键，具有唯一性约束
> - `Page` 具有约束：大于 `18`
> - `Rid` 是表 `ROOM` 的主键，具有唯一性约束
> - 表 `P-R` 中的 `Pid, Rid` 是外键
>

使用以下代码创建数据库

```postgresql
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
```

使用 `\d` 命令查询，有

![image-20230913090506726](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230913090506726.png)

可见上述代码成功创建了符合要求的表

### Task-2

> 更改表 `PERSON`，增加属性 `Ptype`（类型是 `CHAR`，长度为 `10`），取消 `Page > 18` 的约束。把表 `ROOM` 中的属性 `Rname` 的数据类型改成长度为 `30`
>

使用以下代码取消约束

```postgresql
-- 增加属性 Ptype
ALTER TABLE PERSON
ADD Ptype CHAR(10);

-- 取消约束 PERSON_PAGE_CHECK
ALTER TABLE PERSON
DROP CONSTRAINT PERSON_PAGE_CHECK;

-- 修改表 ROOM，将属性 Rname 的数据类型改为长度为 30
ALTER TABLE ROOM
ALTER COLUMN Rname TYPE VARCHAR(30);
```

使用 `\d` 命令查询，有

![image-20230913093001944](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230913093001944.png)

可见上述代码成功按照要求修改

### Task-3

> 删除表 `ROOM` 的一个属性 `Rarea`
>

使用以下代码删除属性

```postgresql
-- 删除属性 Rarea
ALTER TABLE ROOM
DROP COLUMN Rarea;
```

使用 `\d` 命令查询，有

![image-20230913093300387](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230913093300387.png)

可见成功删除了 `Rarea`

### Task-4

> 取消表 `P-R`
>

使用以下代码取消表 `P_R`

```postgresql
-- 取消表 P_R
DROP TABLE P_R;
```

使用 `\d` 命令查询，有

![image-20230913093350293](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230913093350293.png)

可见成功取消了表 `P_R`

### Task-5

> 为 `ROOM` 表创建按 `Rid` 降序排列的索引
>

使用以下代码创建索引

```postgresql
-- 为 ROOM 创建按 Rid 降序排列的索引
CREATE INDEX idx_ROOM_Rid ON ROOM (Rid DESC);
```

使用 `\d` 命令查询，有

![image-20230913093712153](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230913093712153.png)

可见成功创建了降序索引 `idx_Room_Rid`

### Task-6

> 为 `PERSON` 表创建按 `Pid` 升序排列的索引
>

使用以下代码创建索引

```postgresql
-- 为 PERSON 表创建按 Pid 升序排列的索引
CREATE INDEX idx_PERSON_Pid ON PERSON (Pid ASC);
```

使用 `\d` 命令查询，有

![image-20230913094022842](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230913094022842.png)

可见成功创建了升序索引 `idx_PERSON_Pid`

### Task-7

> 创建表 `PERSON` 的按 `Pname` 升序排列的唯一性索引
>

使用以下代码创建索引

```postgresql
-- 创建表 PERSON 的按 Pname 升序排列的唯一性索引
CREATE UNIQUE INDEX idx_PERSON_Pname ON PERSON (Pname ASC);
```

使用 `\d` 命令查询，有

![image-20230913094653366](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230913094653366.png)

可见成功创建了唯一性索引 `idx_PERSON_Pname`

### Task-8

> 取消 `PERSON` 表 `Pid` 升序索引
>

使用以下代码取消索引

```postgresql
-- 取消 PERSON 表 Pid 升序索引
DROP INDEX idx_PERSON_Pis;
```

使用 `\d` 命令查询，有

![image-20230913094833745](/Users/qiu_nangong/Library/Application Support/typora-user-images/image-20230913094833745.png)

可见成功取消了升序索引 `idx_PERSON_Pid`

### 代码总览

```postgresql
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
```

## 5. 实验心得

这个实验使我们熟悉了在PostgreSQL中创建表、修改表和删除表的过程。我们还学习了如何添加和删除列，以及如何创建和取消约束和索引。这些操作对于数据库的设计和维护非常重要，以确保数据的完整性和性能。
