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
 STARTDATE                      DATETIME,
 ENDDATE                        DATETIME,
 LEGALPERSON                    VARCHAR(32),
 ACCOUNTANT                     VARCHAR(32),
 ACCOUNTANTOFFICER              VARCHAR(32),
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
 TITLE                          VARCHAR(256),                       
 STATUS                         VARCHAR(8),                       /* 011:办理中; 012:已完成 */
 DESCRIPTION                    VARCHAR(3000),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T_TRANSACTOR_PK PRIMARY KEY(ID)
);

INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('1', '', '管理员', '', 'admin', '1', '1', CURRENT_TIMESTAMP);

