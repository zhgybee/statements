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

CREATE TABLE T_SHEET
(
 ID                             VARCHAR(32),
 CODE                           VARCHAR(256),
 VERSION                        VARCHAR(8),
 NAME                           VARCHAR(256),
 ITEMS                          VARCHAR(3000),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T_SHEET_PK PRIMARY KEY(ID)
);

CREATE TABLE T_STATEMENT
(
 ID                             VARCHAR(32),
 CODE                           VARCHAR(32),
 TITLE                          VARCHAR(32),
 STARTDATE                      DATETIME,
 ENDDATE                        DATETIME,
 LEGALPERSON                    VARCHAR(32),
 ACCOUNTANT                     VARCHAR(32),
 ACCOUNTANTOFFICER              VARCHAR(32),
 STATUS                         VARCHAR(8),                       /* 001:办理中; 002:已完成 */
 DESCRIPTION                    VARCHAR(3000),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T_STATEMENT_PK PRIMARY KEY(ID)
);

CREATE TABLE T_STATEMENT_SHEET
(
 STATEMENT_ID                   VARCHAR(32),
 SHEET_ID                       VARCHAR(32),
 CONSTRAINT T_STATEMENT_SHEET_PK PRIMARY KEY(STATEMENT_ID, SHEET_ID)
);

CREATE TABLE T_SUBSTATEMENT
(
 ID                             VARCHAR(32),
 STATEMENT_ID                   VARCHAR(32),
 PARENT_ID                      VARCHAR(32),
 MANAGER_USER_ID                VARCHAR(32),
 TITLE                          VARCHAR(256),                       
 STATUS                         VARCHAR(8),                       /* 001:办理中; 002:已完成 */
 DESCRIPTION                    VARCHAR(3000),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T_SUBSTATEMENT_PK PRIMARY KEY(ID)
);

CREATE TABLE T_STATEMENT_TRANSACTOR
(
 ID                             VARCHAR(32),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 SHEET_ID                       VARCHAR(32),
 TRANSACTOR_USER_ID             VARCHAR(32),                   
 STATUS                         VARCHAR(8),                       /* 001:办理中; 002:已完成 */
 DESCRIPTION                    VARCHAR(3000),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T_STATEMENT_TRANSACTOR_PK PRIMARY KEY(ID)
);


INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('1', '', '张真', '1.jpg', 'admin', '1', '1', CURRENT_TIMESTAMP);


CREATE TABLE A
(
 ID                             VARCHAR(32),
 A                              VARCHAR(32),
 B                              VARCHAR(32),
 C                              VARCHAR(32),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 TRANSACTOR_ID                  VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT A_PK PRIMARY KEY(ID)
);

CREATE TABLE B
(
 ID                             VARCHAR(32),
 A                              VARCHAR(32),
 B                              VARCHAR(32),
 C                              VARCHAR(32),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 TRANSACTOR_ID                  VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT B_PK PRIMARY KEY(ID)
);


INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('2', '', '张三', '2.jpg', 'zhangsan', '1', '1', CURRENT_TIMESTAMP);
INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('3', '', '李四', '3.jpg', 'lisi', '1', '1', CURRENT_TIMESTAMP);
INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('4', '', '王二', '4.jpg', 'wanger', '1', '1', CURRENT_TIMESTAMP);
INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('5', '', '赵五', '5.jpg', 'zhaowu', '1', '1', CURRENT_TIMESTAMP);
INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('6', '', '刘六', '6.jpg', 'liuliu', '1', '1', CURRENT_TIMESTAMP);

INSERT INTO T_SHEET(ID, CODE, VERSION, NAME) VALUES('1', 'A1', '1.0.1' ,'资产负债表');
INSERT INTO T_SHEET(ID, CODE, VERSION, NAME) VALUES('2', 'B1', '1.0.1' ,'资产损益表');

INSERT INTO T_STATEMENT(ID, TITLE, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('1', '某某公司财务报表', '001', '某某公司财务报表某某公司财务报表', '1', CURRENT_TIMESTAMP);
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '1');
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '2');

INSERT INTO T_SUBSTATEMENT(ID, STATEMENT_ID, MANAGER_USER_ID, TITLE, PARENT_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('1', '1', '2', '第一分公司', '', '001', '第一分公司第一分公司', '1', CURRENT_TIMESTAMP);
INSERT INTO T_SUBSTATEMENT(ID, STATEMENT_ID, MANAGER_USER_ID, TITLE, PARENT_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('2', '1', '3', '第二分公司', '', '001', '第二分公司第二分公司', '1', CURRENT_TIMESTAMP);
INSERT INTO T_SUBSTATEMENT(ID, STATEMENT_ID, MANAGER_USER_ID, TITLE, PARENT_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('3', '1', '4', '第三分公司', '2', '001', '第三分公司第三分公司', '1', CURRENT_TIMESTAMP);
INSERT INTO T_SUBSTATEMENT(ID, STATEMENT_ID, MANAGER_USER_ID, TITLE, PARENT_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('4', '1', '5', '第四分公司', '3', '001', '第四分公司', '1', CURRENT_TIMESTAMP);

INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('1', '1', '1', '1', '2', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('2', '1', '2', '1', '3', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('3', '1', '3', '1', '4', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('4', '1', '4', '1', '5', '001');

INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('5', '1', '1', '2', '2', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('6', '1', '2', '2', '3', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('7', '1', '3', '2', '4', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('8', '1', '4', '2', '5', '001');

INSERT INTO A(ID, STATEMENT_ID, SUBSTATEMENT_ID) VALUES('1', '1', '1');
INSERT INTO A(ID, STATEMENT_ID, SUBSTATEMENT_ID) VALUES('2', '1', '2');