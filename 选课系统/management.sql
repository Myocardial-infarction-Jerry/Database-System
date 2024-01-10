/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80034 (8.0.34)
 Source Host           : localhost:3306
 Source Schema         : management

 Target Server Type    : MySQL
 Target Server Version : 80034 (8.0.34)
 File Encoding         : 65001

 Date: 21/08/2023 10:03:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for class
-- ----------------------------
DROP TABLE IF EXISTS `class`;

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `cid` int NOT NULL AUTO_INCREMENT,
  `cname` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`cid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, '高等数学');
INSERT INTO `course` VALUES (2, '数据库原理设计');
INSERT INTO `course` VALUES (3, 'Java程序设计');
INSERT INTO `course` VALUES (4, '线性代数');
INSERT INTO `course` VALUES (5, '数据结构与算法');
INSERT INTO `course` VALUES (6, '操作系统');
INSERT INTO `course` VALUES (7, '计算机网络');
INSERT INTO `course` VALUES (8, '软件工程');
INSERT INTO `course` VALUES (9, '人工智能');
INSERT INTO `course` VALUES (10, '编译原理');
INSERT INTO `course` VALUES (11, '离散数学');
INSERT INTO `course` VALUES (12, '数字逻辑');
INSERT INTO `course` VALUES (13, '计算机组成原理');

-- ----------------------------
-- Table structure for select_course
-- ----------------------------
DROP TABLE IF EXISTS `select_course`;
CREATE TABLE `select_course`  (
  `sid` bigint NOT NULL,
  `cid` int NOT NULL,
  `tid` int UNSIGNED NOT NULL,
  `usual_grade` float NULL DEFAULT NULL,
  `final_grade` float NULL DEFAULT NULL,
  PRIMARY KEY (`sid`, `cid`) USING BTREE,
  INDEX `fk_sc_course`(`cid` ASC) USING BTREE,
  CONSTRAINT `fk_sc_course` FOREIGN KEY (`cid`) REFERENCES `course` (`cid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sc_student` FOREIGN KEY (`sid`) REFERENCES `student` (`sid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sc_teacher` FOREIGN KEY (`tid`) REFERENCES `teacher` (`tid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of select_course
-- ----------------------------
INSERT INTO `select_course` VALUES (2015010312, 1, 1, 50, 84);
INSERT INTO `select_course` VALUES (2015010312, 3, 2, 70, 78);
INSERT INTO `select_course` VALUES (2015010313, 1, 3, 90, 98);
INSERT INTO `select_course` VALUES (2015010313, 2, 4, 89, 89);
INSERT INTO `select_course` VALUES (2015010313, 3, 5, 59, 75);
INSERT INTO `select_course` VALUES (2015010314, 1, 5, 85, 89);
INSERT INTO `select_course` VALUES (2015010418, 10, 5, NULL, NULL);

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `sid` bigint NOT NULL,
  `name` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `gender` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `grade` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `telephone` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`sid`) USING BTREE,
  INDEX `fk_student_class`(`grade` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (2021307289, '刘森元', '男', '2021', '13333333333');
INSERT INTO `student` VALUES (2021307355, '黄梓宏', '男', '2021', '13186794554');
INSERT INTO `student` VALUES (2015010312, '张明', '男', '2015', '13123456589');
INSERT INTO `student` VALUES (2015010313, '李华', '女', '2015', '13123456789');
INSERT INTO `student` VALUES (2015010314, '王刚', '男', '2015', '13134567890');
INSERT INTO `student` VALUES (2015010315, '陈梅', '女', '2015', '13145678901');
INSERT INTO `student` VALUES (2015010416, '赵雷', '男', '2015', '13156789012');
INSERT INTO `student` VALUES (2015010417, '刘芳', '女', '2015', '13167890123');
INSERT INTO `student` VALUES (2015010418, '周杰', '男', '2015', '13178901234');
INSERT INTO `student` VALUES (2015020119, '林娜', '女', '2015', '13189012345');
INSERT INTO `student` VALUES (2015020120, '马强', '男', '2015', '13190123456');
INSERT INTO `student` VALUES (2015030221, '张琳', '女', '2015', '13201234567');
INSERT INTO `student` VALUES (2015030222, '李伟', '男', '2015', '13212345678');

-- ----------------------------
-- Table structure for teacher
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher`  (
  `tid` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `tname` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `gender` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `salary` int NOT NULL,
  `age` int NOT NULL,
  `telephone` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`tid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- --------------------,8000,'24'--------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES (1, '姚学林','男',8000,24,'13123456589');
INSERT INTO `teacher` VALUES (2, '简小瑜','男',8000,24,'13123456589');
INSERT INTO `teacher` VALUES (3, '通俊雄','男',8000,24,'13123456589');
INSERT INTO `teacher` VALUES (4, '贾白梅','男',8000,24,'13123456589');
INSERT INTO `teacher` VALUES (5, '牛琼芳','男',8000,24,'13123456589');
INSERT INTO `teacher` VALUES (6, '欧飞雨','男',8000,41,'13123456589');
INSERT INTO `teacher` VALUES (7, '符雪艳','男',8000,34,'13123456589');
INSERT INTO `teacher` VALUES (8, '杜佳晨','男',8000,45,'13123456589');
INSERT INTO `teacher` VALUES (9, '刘宏浚','男',8000,42,'13123456589');
INSERT INTO `teacher` VALUES (10, '王向荣','男',8000,24,'13123456589');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `role` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', '1', 'admin');
INSERT INTO `users` VALUES (2, 'user', '1', 'user');
INSERT INTO `users` VALUES (3, 'teacher_admin', '1', 'teacher_admin');
INSERT INTO `users` VALUES (4, 'teacher', '1', 'teacher');
INSERT INTO `users` VALUES (5, 'courses_admin', '1', 'courses_admin');
INSERT INTO `users` VALUES (6, 'student_admin', '1', 'student_admin');

SET FOREIGN_KEY_CHECKS = 1;

