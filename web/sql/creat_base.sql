/*
Navicat SQLite Data Transfer

Source Server         : db
Source Server Version : 30808
Source Host           : :0

Target Server Type    : SQLite
Target Server Version : 30808
File Encoding         : 65001

Date: 2018-09-13 14:25:16
*/

PRAGMA foreign_keys = OFF;

-- ----------------------------
-- Table structure for B_0_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_0_1";
CREATE TABLE B_0_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    VARCHAR(20),
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_0_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_0_2";
CREATE TABLE B_0_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

M                       	    VARCHAR(20),
N                       	    VARCHAR(20),
O                       	    DOUBLE,
P                       	    DOUBLE,
Q                       	    DOUBLE,
T                       	    VARCHAR(100),
U                       	    VARCHAR(100),
V                       	    DOUBLE,
W                       	    VARCHAR(100),
X                       	    VARCHAR(100),
Y                       	    DOUBLE,
Z                       	    VARCHAR(200),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_0_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_0_3";
CREATE TABLE B_0_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

AC                       	    VARCHAR(20),
AD                       	    VARCHAR(20),
AE                       	    DOUBLE,
AF                       	    DOUBLE,
AG                       	    DOUBLE,
AJ                       	    VARCHAR(100),
AK                       	    VARCHAR(100),
AL                       	    DOUBLE,
AM                       	    VARCHAR(100),
AN                       	    VARCHAR(100),
AO                       	    DOUBLE,
AP                       	    VARCHAR(200),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_1_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_1_1";
CREATE TABLE B_8_1_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A     	                  	VARCHAR(20),
B                        		DOUBLE,
C                       	    VARCHAR(10),
D                          	DOUBLE,
E                          	DOUBLE,
F                           	DOUBLE,
G                           	VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_1_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_1_2";
CREATE TABLE B_8_1_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A     	                  	VARCHAR(20),
B                        		DOUBLE,
C                       	    VARCHAR(10),
D                          	DOUBLE,
E                          	DOUBLE,
F                           	DOUBLE,
G                           	VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_1_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_1_3";
CREATE TABLE B_8_1_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A     	                  	VARCHAR(20),
B                        		DOUBLE,
C                       	    VARCHAR(10),
D                          	DOUBLE,
E                          	DOUBLE,
F                           	DOUBLE,
G                           	VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_1_4
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_1_4";
CREATE TABLE B_8_1_4
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

I     	                  		DOUBLE,
J                        		DOUBLE,
K_TITLE                         VARCHAR(100),
K                       	    DOUBLE,
L                          		DOUBLE,
M_TITLE                         VARCHAR(100),
M                          		DOUBLE,
N                           	DOUBLE,
O_TITLE                         VARCHAR(100),
O                           	DOUBLE,
P                           	DOUBLE,
Q_TITLE                         VARCHAR(100),
Q                           	DOUBLE,
R                           	DOUBLE,
S_TITLE                         VARCHAR(100),
S                           	DOUBLE,
T                           	DOUBLE,
U_TITLE                         VARCHAR(100),
U                           	DOUBLE,
V                           	DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_1_5
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_1_5";
CREATE TABLE B_8_1_5
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

I     	                  		DOUBLE,
J                        		DOUBLE,
K_TITLE                         VARCHAR(100),
K                       	    DOUBLE,
L                          		DOUBLE,
M_TITLE                         VARCHAR(100),
M                          		DOUBLE,
N                           	DOUBLE,
O_TITLE                         VARCHAR(100),
O                           	DOUBLE,
P                           	DOUBLE,
Q_TITLE                         VARCHAR(100),
Q                           	DOUBLE,
R                           	DOUBLE,
S_TITLE                         VARCHAR(100),
S                           	DOUBLE,
T                           	DOUBLE,
U_TITLE                         VARCHAR(100),
U                           	DOUBLE,
V                           	DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_1_Q
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_1_Q";
CREATE TABLE B_8_1_Q
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,
L                       	    DOUBLE,
M                       	    DOUBLE,
N                       	    DOUBLE,
O                       	    DOUBLE,
P                       	    DOUBLE,
Q                       	    DOUBLE,
R                       	    DOUBLE,
S                       	    DOUBLE,
T                       	    DOUBLE,
U                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_10
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_10";
CREATE TABLE B_8_10
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_11
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_11";
CREATE TABLE B_8_11
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_12
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_12";
CREATE TABLE B_8_12
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_13_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_13_1";
CREATE TABLE B_8_13_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_13_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_13_2";
CREATE TABLE B_8_13_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,
L                       	    DOUBLE,
M                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_13_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_13_3";
CREATE TABLE B_8_13_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_14
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_14";
CREATE TABLE B_8_14
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),

B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,
L                       	    DOUBLE,
M                       	    DOUBLE,
N                       	    DOUBLE,
O                       	    DOUBLE,
P                       	    DOUBLE,
Q                       	    DOUBLE,
R                       	    DOUBLE,
S                       	    DOUBLE,
T                       	    DOUBLE,
U                       	    DOUBLE,
V                       	    DOUBLE,
W                       	    DOUBLE,
X                       	    DOUBLE,
Y                       	    DOUBLE,

Z                       	    DOUBLE,

AA                       	    DOUBLE,
AB                       	    DOUBLE,
AC                       	    DOUBLE,
AD                       	    DOUBLE,
AE                       	    DOUBLE,
AF                       	    DOUBLE,
AG                       	    DOUBLE,
AH                       	    DOUBLE,
AI                       	    DOUBLE,
AJ                       	    DOUBLE,
AK                       	    DOUBLE,
AL                       	    DOUBLE,
AM                       	    DOUBLE,
AN                       	    DOUBLE,
AO                       	    DOUBLE,
AP                       	    DOUBLE,
AQ                       	    DOUBLE,
AR                       	    DOUBLE,
AS1                       	    DOUBLE,
AT                       	    DOUBLE,
AU                       	    DOUBLE,
AV                       	    DOUBLE,
AW                       	    DOUBLE,

AX                       	    DOUBLE,

AY                       	    DOUBLE,
AZ                       	    DOUBLE,

BA                       	    DOUBLE,
BB                       	    DOUBLE,
BC                       	    DOUBLE,
BD                       	    DOUBLE,
BE                       	    DOUBLE,
BF                       	    DOUBLE,
BG                       	    DOUBLE,
BH                       	    DOUBLE,
BI                       	    DOUBLE,
BJ                       	    DOUBLE,
BK                       	    DOUBLE,
BL                       	    DOUBLE,
BM                       	    DOUBLE,
BN                       	    DOUBLE,
BO                       	    DOUBLE,
BP                       	    DOUBLE,
BQ                       	    DOUBLE,
BR                       	    DOUBLE,
BS                       	    DOUBLE,
BT                       	    DOUBLE,
BU                       	    DOUBLE,
BV                       	    DOUBLE,

BW                       	    DOUBLE,

BX                       	    DOUBLE,
BY                       	    DOUBLE,

BZ                       	    DOUBLE,
CA                       	    DOUBLE,

CB                       	    DOUBLE,
CC                       	    DOUBLE,
CD                       	    DOUBLE,
CE                       	    DOUBLE,

CF                       	    DOUBLE,
CG                       	    DOUBLE,
CH                       	    DOUBLE,
CI                       	    DOUBLE,

CJ                       	    DOUBLE,
CK                       	    DOUBLE,
CL                       	    DOUBLE,
CM                       	    DOUBLE,

CN                       	    DOUBLE,
CO                       	    DOUBLE,
CP                       	    DOUBLE,
CQ                       	    DOUBLE,

CR                       	    DOUBLE,
CS                       	    DOUBLE,
CT                       	    DOUBLE,
CU                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_15_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_15_1";
CREATE TABLE B_8_15_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,
L                       	    DOUBLE,
M                       	    DOUBLE,
N                       	    DOUBLE,
O                       	    DOUBLE,
P                       	    DOUBLE,
Q                       	    DOUBLE,
R                       	    DOUBLE,
S                       	    DOUBLE,
T                       	    DOUBLE,
U                       	    DOUBLE,
V                       	    DOUBLE,
W                       	    DOUBLE,
X                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_15_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_15_2";
CREATE TABLE B_8_15_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_16
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_16";
CREATE TABLE B_8_16
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_17
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_17";
CREATE TABLE B_8_17
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_18
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_18";
CREATE TABLE B_8_18
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    VARCHAR(100),

C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,
L                       	    DOUBLE,
M                       	    DOUBLE,
N                       	    DOUBLE,
O                       	    DOUBLE,
P                       	    DOUBLE,
Q                       	    DOUBLE,
R                       	    DOUBLE,
S                       	    DOUBLE,
T                       	    DOUBLE,
U                       	    DOUBLE,

V                       	    DOUBLE,

W                       	    DOUBLE,

X                       	    DOUBLE,
Y                       	    DOUBLE,
Z                       	    DOUBLE,
AA                       	    DOUBLE,
AB                       	    DOUBLE,
AC                       	    DOUBLE,
AD                       	    DOUBLE,
AE                       	    DOUBLE,
AF                       	    DOUBLE,
AG                       	    DOUBLE,
AH                       	    DOUBLE,
AI                       	    DOUBLE,
AJ                       	    DOUBLE,
AK                       	    DOUBLE,
AL                       	    DOUBLE,
AM                       	    DOUBLE,
AN                       	    DOUBLE,
AO                       	    DOUBLE,

AP                       	    DOUBLE,

AQ                       	    DOUBLE,

AR                       	    DOUBLE,
AS1                       	    DOUBLE,

AT                       	    DOUBLE,
AU                       	    DOUBLE,
AV                       	    DOUBLE,
AW                       	    DOUBLE,
AX                       	    DOUBLE,
AY                       	    DOUBLE,
AZ                       	    DOUBLE,
BA                       	    DOUBLE,
BB                       	    DOUBLE,
BC                       	    DOUBLE,
BD                       	    DOUBLE,
BE                       	    DOUBLE,
BF                       	    DOUBLE,
BG                       	    DOUBLE,
BH                       	    DOUBLE,
BI                       	    DOUBLE,
BJ                       	    DOUBLE,
BK                       	    DOUBLE,
BL                       	    DOUBLE,

BM                       	    DOUBLE,

BN                       	    DOUBLE,

BO                       	    DOUBLE,
BP                       	    DOUBLE,

BQ                       	    DOUBLE,
BR                       	    DOUBLE,

BS                       	    varchar(100),

BT                       	    DOUBLE,
BU                       	    DOUBLE,
BV                       	    DOUBLE,
BW                       	    DOUBLE,

BX                       	    DOUBLE,
BY                       	    DOUBLE,
BZ                       	    DOUBLE,
CA                       	    DOUBLE,

CB                       	    DOUBLE,
CC                       	    DOUBLE,
CD                       	    DOUBLE,
CE                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_19_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_19_1";
CREATE TABLE B_8_19_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,
L                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_19_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_19_2";
CREATE TABLE B_8_19_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,
L                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_2";
CREATE TABLE B_8_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_20
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_20";
CREATE TABLE B_8_20
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    VARCHAR(100),
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,
L                       	    DOUBLE,
M                       	    DOUBLE,
N                       	    DOUBLE,
O                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_21
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_21";
CREATE TABLE B_8_21
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,
L                       	    VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_22
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_22";
CREATE TABLE B_8_22
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_3";
CREATE TABLE B_8_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       		DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_30
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_30";
CREATE TABLE B_8_30
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_4
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_4";
CREATE TABLE B_8_4
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_41_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_41_1";
CREATE TABLE B_8_41_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    DOUBLE,
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_41_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_41_2";
CREATE TABLE B_8_41_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    DOUBLE,
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_41_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_41_3";
CREATE TABLE B_8_41_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    DOUBLE,
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_42
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_42";
CREATE TABLE B_8_42
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_43
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_43";
CREATE TABLE B_8_43
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_44_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_44_1";
CREATE TABLE B_8_44_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_44_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_44_2";
CREATE TABLE B_8_44_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_44_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_44_3";
CREATE TABLE B_8_44_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_45_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_45_1";
CREATE TABLE B_8_45_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_45_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_45_2";
CREATE TABLE B_8_45_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_45_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_45_3";
CREATE TABLE B_8_45_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_46_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_46_1";
CREATE TABLE B_8_46_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_46_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_46_2";
CREATE TABLE B_8_46_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_46_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_46_3";
CREATE TABLE B_8_46_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_47
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_47";
CREATE TABLE B_8_47
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_48
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_48";
CREATE TABLE B_8_48
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_49
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_49";
CREATE TABLE B_8_49
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_5
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_5";
CREATE TABLE B_8_5
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_50
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_50";
CREATE TABLE B_8_50
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),
E                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_51
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_51";
CREATE TABLE B_8_51
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    VARCHAR(100),
F                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_52
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_52";
CREATE TABLE B_8_52
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_6_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_6_1";
CREATE TABLE B_8_6_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    VARCHAR(100),
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_6_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_6_2";
CREATE TABLE B_8_6_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_6_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_6_3";
CREATE TABLE B_8_6_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_7_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_7_1";
CREATE TABLE B_8_7_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    VARCHAR(100),
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_7_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_7_2";
CREATE TABLE B_8_7_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_7_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_7_3";
CREATE TABLE B_8_7_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_71_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_71_1";
CREATE TABLE B_8_71_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_71_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_71_2";
CREATE TABLE B_8_71_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_71_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_71_3";
CREATE TABLE B_8_71_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_72
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_72";
CREATE TABLE B_8_72
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_73
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_73";
CREATE TABLE B_8_73
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    DOUBLE,
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_74
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_74";
CREATE TABLE B_8_74
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_75
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_75";
CREATE TABLE B_8_75
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_76
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_76";
CREATE TABLE B_8_76
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_77
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_77";
CREATE TABLE B_8_77
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_78
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_78";
CREATE TABLE B_8_78
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_79_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_79_1";
CREATE TABLE B_8_79_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),
E                       	    VARCHAR(100),
F                       	    VARCHAR(100),
G                       	    VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_79_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_79_2";
CREATE TABLE B_8_79_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),
E                       	    VARCHAR(100),
F                       	    VARCHAR(100),
G                       	    VARCHAR(100),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_8_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_8_1";
CREATE TABLE B_8_8_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    VARCHAR(100),
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_8_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_8_2";
CREATE TABLE B_8_8_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_8_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_8_3";
CREATE TABLE B_8_8_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    VARCHAR(100),


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_80
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_80";
CREATE TABLE B_8_80
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

B14                       	    DOUBLE,
C14                       	    DOUBLE,

B15                       	    DOUBLE,
C15                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_9_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_9_1";
CREATE TABLE B_8_9_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_9_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_9_2";
CREATE TABLE B_8_9_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       		VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,


 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_8_90
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_8_90";
CREATE TABLE B_8_90
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_JB
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_JB";
CREATE TABLE B_JB
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,
 SJDW                           VARCHAR(100),
 QCR                           DATETIME
 QMR                          DATETIME,
 DBR                           VARCHAR(32),
 ZGFZR                           VARCHAR(32),
 FZR                           VARCHAR(32),
 BZR                           VARCHAR(32),
 BZRQ                           DATETIME,
 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_JB_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_JB_1";
CREATE TABLE B_JB_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    VARCHAR(20),
C                       	    VARCHAR(20),
D                       	    DOUBLE,
E                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_JB_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_JB_2";
CREATE TABLE B_JB_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    VARCHAR(20),
C                       	    VARCHAR(20),
D                       	    DOUBLE,
E                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_JB_3
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_JB_3";
CREATE TABLE B_JB_3
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,
L                       	    DOUBLE,
M                       	    DOUBLE,
N                       	    DOUBLE,
O                       	    DOUBLE,
P                       	    DOUBLE,
Q                       	    DOUBLE,
R                       	    DOUBLE,
S                       	    DOUBLE,
T                       	    DOUBLE,
U                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_JB_4
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_JB_4";
CREATE TABLE B_JB_4
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    DOUBLE,
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,
G                       	    DOUBLE,
H                       	    DOUBLE,
I                       	    DOUBLE,
J                       	    DOUBLE,
K                       	    DOUBLE,
L                       	    DOUBLE,
M                       	    DOUBLE,
N                       	    DOUBLE,
O                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_JB_5
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_JB_5";
CREATE TABLE B_JB_5
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    VARCHAR(20),
C                       	    VARCHAR(20),
D                       	    DOUBLE,
E                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_JB_6_1
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_JB_6_1";
CREATE TABLE B_JB_6_1
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    VARCHAR(100),
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for B_JB_6_2
-- ----------------------------
DROP TABLE IF EXISTS "main"."B_JB_6_2";
CREATE TABLE B_JB_6_2
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    VARCHAR(100),
C                       	    DOUBLE,
D                       	    DOUBLE,

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

-- ----------------------------
-- Table structure for CFS_TB
-- ----------------------------
DROP TABLE IF EXISTS "main"."CFS_TB";
CREATE TABLE CFS_TB
(
 
 ID                             VARCHAR(32),
 TASK_ID						VARCHAR(32),
 STATUS							VARCHAR(8),
 CREATE_USER_ID					VARCHAR(32),
 CREATE_DATE					DATETIME,

A                       	    VARCHAR(100),
B                       	    VARCHAR(10),
C                       	    DOUBLE,
D                       	    DOUBLE,
E                       	    DOUBLE,
F                       	    VARCHAR(10),

 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);
