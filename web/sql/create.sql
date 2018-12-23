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
 STATUS                         VARCHAR(8),                       /* 001:������; 002:����� */
 VERSION                        VARCHAR(16),
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
 STATUS                         VARCHAR(8),                       /* 001:������; 002:����� */
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
 STATUS                         VARCHAR(8),                       /* 001:������; 002:����� */
 DESCRIPTION                    VARCHAR(3000),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T_STATEMENT_TRANSACTOR_PK PRIMARY KEY(ID)
);


INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('1', '', '����', '1.jpg', 'admin', '1', '1', CURRENT_TIMESTAMP);

/* ����ƽ��� */
CREATE TABLE T01
(
 ID                             VARCHAR(32),
 XM                             VARCHAR(128),
 XMBH                           VARCHAR(8),
 QMSDQ                          VARCHAR(32),  
 QCSDQ                          VARCHAR(32),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T01_PK PRIMARY KEY(ID)
);

/* ��ĩ����Ƶ�����¼ */
CREATE TABLE T02
(
 ID                             VARCHAR(32),
 JFKM                           VARCHAR(32),
 JFEJKM                         VARCHAR(128),
 JFJE                           VARCHAR(16),
 DFKM                           VARCHAR(32),		
 DFEJKM                         VARCHAR(128),
 DFJE                           VARCHAR(16),
 SXSM                           VARCHAR(1024),
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T03_PK PRIMARY KEY(ID)
);

/* �ڳ�����Ƶ�����¼ */
CREATE TABLE T03
(
 ID                             VARCHAR(32),
 JFKM                           VARCHAR(32),
 JFEJKM                         VARCHAR(128),
 JFJE                           VARCHAR(16),
 DFKM                           VARCHAR(32),		
 DFEJKM                         VARCHAR(128),
 DFJE                           VARCHAR(16),
 SXSM                           VARCHAR(1024),
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T03_PK PRIMARY KEY(ID)
);




















CREATE TABLE A
(
 ID                             VARCHAR(32),
 A                              VARCHAR(32),
 B                              VARCHAR(32),
 C                              VARCHAR(32),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
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
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT B_PK PRIMARY KEY(ID)
);

CREATE TABLE C
(
 ID                             VARCHAR(32),
 A                              VARCHAR(32),
 B                              VARCHAR(32),
 C                              VARCHAR(32),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT C_PK PRIMARY KEY(ID)
);

CREATE TABLE D
(
 ID                             VARCHAR(32),
 A                              VARCHAR(32),
 B                              VARCHAR(32),
 C                              VARCHAR(32),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT D_PK PRIMARY KEY(ID)
);


INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('2', '', '����', '2.jpg', 'zhangsan', '1', '1', CURRENT_TIMESTAMP);
INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('3', '', '����', '3.jpg', 'lisi', '1', '1', CURRENT_TIMESTAMP);
INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('4', '', '����', '4.jpg', 'wanger', '1', '1', CURRENT_TIMESTAMP);
INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('5', '', '����', '5.jpg', 'zhaowu', '1', '1', CURRENT_TIMESTAMP);
INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('6', '', '����', '6.jpg', 'liuliu', '1', '1', CURRENT_TIMESTAMP);



INSERT INTO T_STATEMENT(ID, TITLE, STATUS, VERSION, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('1', 'ĳĳ��˾���񱨱�', '001', '0001', 'ĳĳ��˾���񱨱�ĳĳ��˾���񱨱�', '1', CURRENT_TIMESTAMP);
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '0');
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '1');
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '2');

INSERT INTO T_SUBSTATEMENT(ID, STATEMENT_ID, MANAGER_USER_ID, TITLE, PARENT_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('1', '1', '2', '��һ�ֹ�˾', '', '001', '��һ�ֹ�˾��һ�ֹ�˾', '1', CURRENT_TIMESTAMP);
INSERT INTO T_SUBSTATEMENT(ID, STATEMENT_ID, MANAGER_USER_ID, TITLE, PARENT_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('2', '1', '3', '�ڶ��ֹ�˾', '', '001', '�ڶ��ֹ�˾�ڶ��ֹ�˾', '1', CURRENT_TIMESTAMP);
INSERT INTO T_SUBSTATEMENT(ID, STATEMENT_ID, MANAGER_USER_ID, TITLE, PARENT_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('3', '1', '4', '�����ֹ�˾', '2', '001', '�����ֹ�˾�����ֹ�˾', '1', CURRENT_TIMESTAMP);
INSERT INTO T_SUBSTATEMENT(ID, STATEMENT_ID, MANAGER_USER_ID, TITLE, PARENT_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('4', '1', '5', '���ķֹ�˾', '3', '001', '���ķֹ�˾', '1', CURRENT_TIMESTAMP);

INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('01', '1', '1', '0', '2', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('02', '1', '2', '0', '3', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('03', '1', '3', '0', '4', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('04', '1', '4', '0', '5', '001');

INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('05', '1', '1', '1', '2', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('06', '1', '2', '1', '3', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('07', '1', '3', '1', '4', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('08', '1', '4', '1', '5', '001');

INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('09', '1', '1', '2', '2', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('10', '1', '2', '2', '3', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('11', '1', '3', '2', '4', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('12', '1', '4', '2', '5', '001');

INSERT INTO A(ID, STATEMENT_ID, SUBSTATEMENT_ID) VALUES('1', '1', '1');
INSERT INTO A(ID, STATEMENT_ID, SUBSTATEMENT_ID) VALUES('2', '1', '2');
