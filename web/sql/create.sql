CREATE TABLE T_USER
(
 ID                             VARCHAR(32),
 CODE                           VARCHAR(32),
 ICON                           VARCHAR(64),
 NAME                           VARCHAR(16),
 LOGINNAME                      VARCHAR(16),
 PASSWORD                       VARCHAR(16),
 ROLE                           VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T_USER_PK PRIMARY KEY(ID)
);

CREATE TABLE T_TASK
(
 ID                             VARCHAR(32),
 CODE                           VARCHAR(32),
 TITLE                          VARCHAR(32),
 TYPE                           VARCHAR(8),
 STATUS                         VARCHAR(8),                       /* 001:办理中; 002:已完成 */
 DESCRIPTION                    VARCHAR(3000),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T_TASK_PK PRIMARY KEY(ID)
);

CREATE TABLE T_TRANSACTOR
(
 ID                             VARCHAR(32),
 TASK_ID                        VARCHAR(32),
 USER_ID                        VARCHAR(32),
 STATUS                         VARCHAR(8),                       /* 011:办理中; 012:已完成 */
 CREATE_DATE                    DATETIME,
 CONSTRAINT T_TRANSACTOR_PK PRIMARY KEY(ID)
);

INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('1', '', '管理员', '', 'admin', '1', '1', CURRENT_TIMESTAMP);


CREATE TABLE A1
(
 ID                             VARCHAR(32),
 C1                             VARCHAR(32),
 C2                             VARCHAR(32),
 C3                             VARCHAR(32),
 C4                             VARCHAR(32),
 C5                             VARCHAR(32),
 TASK_ID                        VARCHAR(32),
 STATUS                         VARCHAR(8),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT A1_PK PRIMARY KEY(ID)
);
CREATE TABLE A2
(
 ID                             VARCHAR(32),
 C1                             VARCHAR(32),
 C2                             VARCHAR(32),
 C3                             VARCHAR(32),
 C4                             VARCHAR(32),
 C5                             VARCHAR(32),
 TASK_ID                        VARCHAR(32),
 STATUS                         VARCHAR(8),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT A2_PK PRIMARY KEY(ID)
);
CREATE TABLE A3
(
 ID                             VARCHAR(32),
 C1                             VARCHAR(32),
 C2                             VARCHAR(32),
 C3                             VARCHAR(32),
 C4                             VARCHAR(32),
 C5                             VARCHAR(32),
 TASK_ID                        VARCHAR(32),
 STATUS                         VARCHAR(8),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT A3_PK PRIMARY KEY(ID)
);
CREATE TABLE A4
(
 ID                             VARCHAR(32),
 C1                             VARCHAR(32),
 C2                             VARCHAR(32),
 C3                             VARCHAR(32),
 C4                             VARCHAR(32),
 C5                             VARCHAR(32),
 TASK_ID                        VARCHAR(32),
 STATUS                         VARCHAR(8),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT A4_PK PRIMARY KEY(ID)
);