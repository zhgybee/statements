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
 STATUS                         VARCHAR(8),                       /* 001:办理中; 002:已完成 */
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

CREATE TABLE T_STATEMENT_SHARER
(
 ID                             VARCHAR(32),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 USER_ID                        VARCHAR(32),                   
 CONSTRAINT T_STATEMENT_SHARER_PK PRIMARY KEY(ID)
);

CREATE TABLE T_HEADER
(
 ID                             VARCHAR(32),
 TABLE_ID                       VARCHAR(32),
 TAGCODE                        VARCHAR(8),
 TEXT                           VARCHAR(3000),
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 MODE                           VARCHAR(1),  
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T_STATEMENT_TRANSACTOR_PK PRIMARY KEY(ID)
);

CREATE TABLE T_STATEMENT_LOG
(
 ID                             VARCHAR(32),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 EDIT_USER_ID                   VARCHAR(32),
 EDIT_DATE                      DATETIME,
 MODE                           VARCHAR(1),  
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T_STATEMENT_LOG_PK PRIMARY KEY(ID)
);

INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('1', '', '张真', '1.jpg', 'admin', '1', '1', CURRENT_TIMESTAMP);

/* 试算平衡表 */
CREATE TABLE T01
(
 ID                             VARCHAR(32),
 XM                             VARCHAR(128),
 XMBH                           VARCHAR(8),
 QMSDQ                          VARCHAR(32),  
 QCSDQ                          VARCHAR(32),  
 MODE                           VARCHAR(1),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T01_PK PRIMARY KEY(ID)
);

/* 期末数审计调整分录 */
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
 MODE                           VARCHAR(1),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T02_PK PRIMARY KEY(ID)
);

/* 期初数审计调整分录 */
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
 MODE                           VARCHAR(1),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T03_PK PRIMARY KEY(ID)
);


/* 合并利润表 */
CREATE TABLE T04
(
 ID                             VARCHAR(32),
 BM                             VARCHAR(8),
 FZ1                            VARCHAR(128),
 BQFSE1                         VARCHAR(16),
 SQFSE1                         VARCHAR(16),	
 FZ2                            VARCHAR(128),
 BQFSE2                         VARCHAR(16),
 SQFSE2                         VARCHAR(16),	
 MODE                           VARCHAR(1),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T04_PK PRIMARY KEY(ID)
);

/* 现金流量试算平衡表 */
CREATE TABLE T05
(
 ID                             VARCHAR(32),
 BM                             VARCHAR(8),
 BQSDQ                          VARCHAR(16),
 BQTZS                          VARCHAR(16),
 BQSDH                          VARCHAR(16),	
 SQSDQ                          VARCHAR(16),
 SQTZS                          VARCHAR(16),
 SQSDH                          VARCHAR(16),
 MODE                           VARCHAR(1),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T04_PK PRIMARY KEY(ID)
);



/* 所有者权益变动表 */
CREATE TABLE T06
(
 ID                             VARCHAR(32),
 BM                             VARCHAR(8),
 B01                            VARCHAR(16),
 B02                            VARCHAR(16),
 B03                            VARCHAR(16),
 B04                            VARCHAR(16),
 B05                            VARCHAR(16),
 B06                            VARCHAR(16),
 B07                            VARCHAR(16),
 B08                            VARCHAR(16),
 B09                            VARCHAR(16),
 B10                            VARCHAR(16),
 B11                            VARCHAR(16),
 B12                            VARCHAR(16),
 B13                            VARCHAR(16),
 B14                            VARCHAR(16),
 S01                            VARCHAR(16),
 S02                            VARCHAR(16),
 S03                            VARCHAR(16),
 S04                            VARCHAR(16),
 S05                            VARCHAR(16),
 S06                            VARCHAR(16),
 S07                            VARCHAR(16),
 S08                            VARCHAR(16),
 S09                            VARCHAR(16),
 S10                            VARCHAR(16),
 S11                            VARCHAR(16),
 S12                            VARCHAR(16),
 S13                            VARCHAR(16),
 S14                            VARCHAR(16),
 MODE                           VARCHAR(1),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT T04_PK PRIMARY KEY(ID)
);


CREATE VIEW V01 AS 
select T01.*, QMJF.JFJE as 'QMJFJE', QMDF.DFJE as 'QMDFJE', QCJF.JFJE as 'QCJFJE', QCDF.DFJE as 'QCDFJE' from T01 
left join (select STATEMENT_ID, SUBSTATEMENT_ID, MODE , JFKM, sum(JFJE) as 'JFJE' from T02 group by STATEMENT_ID, SUBSTATEMENT_ID, MODE , JFKM) QMJF on 
T01.XMBH = QMJF.JFKM and T01.STATEMENT_ID = QMJF.STATEMENT_ID and T01.SUBSTATEMENT_ID = QMJF.SUBSTATEMENT_ID and T01.MODE  = QMJF.MODE 

left join (select STATEMENT_ID, SUBSTATEMENT_ID, MODE , DFKM, sum(DFJE) as 'DFJE' from T02 group by STATEMENT_ID, SUBSTATEMENT_ID, MODE , DFKM) QMDF on 
T01.XMBH = QMDF.DFKM and T01.STATEMENT_ID = QMDF.STATEMENT_ID and T01.SUBSTATEMENT_ID = QMDF.SUBSTATEMENT_ID and T01.MODE  = QMDF.MODE 

left join (select STATEMENT_ID, SUBSTATEMENT_ID, MODE , JFKM, sum(JFJE) as 'JFJE' from T03 group by STATEMENT_ID, SUBSTATEMENT_ID, MODE , JFKM) QCJF on 
T01.XMBH = QCJF.JFKM and T01.STATEMENT_ID = QCJF.STATEMENT_ID and T01.SUBSTATEMENT_ID = QCJF.SUBSTATEMENT_ID and T01.MODE  = QCJF.MODE 

left join (select STATEMENT_ID, SUBSTATEMENT_ID, MODE , DFKM, sum(DFJE) as 'DFJE' from T03 group by STATEMENT_ID, SUBSTATEMENT_ID, MODE , DFKM) QCDF on 
T01.XMBH = QCDF.DFKM and T01.STATEMENT_ID = QCDF.STATEMENT_ID and T01.SUBSTATEMENT_ID = QCDF.SUBSTATEMENT_ID and T01.MODE  = QCDF.MODE 





















CREATE TABLE A
(
 ID                             VARCHAR(32),
 A                              VARCHAR(32),
 B                              VARCHAR(32),
 C                              VARCHAR(32),  
 STATUS                         VARCHAR(8),
 STATEMENT_ID                   VARCHAR(32),
 SUBSTATEMENT_ID                VARCHAR(32),
 MODE                           VARCHAR(1),  
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
 MODE                           VARCHAR(1),  
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
 MODE                           VARCHAR(1),  
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
 MODE                           VARCHAR(1),  
 SUBSTATEMENT_ID                VARCHAR(32),
 CREATE_USER_ID                 VARCHAR(32),
 CREATE_DATE                    DATETIME,
 CONSTRAINT D_PK PRIMARY KEY(ID)
);


INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('2', '', '张三', '2.jpg', 'zhangsan', '1', '1', CURRENT_TIMESTAMP);
INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('3', '', '李四', '3.jpg', 'lisi', '1', '1', CURRENT_TIMESTAMP);
INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('4', '', '王二', '4.jpg', 'wanger', '1', '1', CURRENT_TIMESTAMP);
INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('5', '', '赵五', '5.jpg', 'zhaowu', '1', '1', CURRENT_TIMESTAMP);
INSERT INTO T_USER(ID, CODE, NAME, ICON, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES('6', '', '刘六', '6.jpg', 'liuliu', '1', '1', CURRENT_TIMESTAMP);



INSERT INTO T_STATEMENT(ID, TITLE, STATUS, VERSION, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('1', '某某公司财务报表', '001', '0001', '某某公司财务报表某某公司财务报表', '1', CURRENT_TIMESTAMP);
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '0');
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '1');
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '2');
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '3');
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '4');
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '5');
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '6');
INSERT INTO T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES('1', '7');

INSERT INTO T_SUBSTATEMENT(ID, STATEMENT_ID, MANAGER_USER_ID, TITLE, PARENT_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('1', '1', '2', '第一分公司', '', '001', '第一分公司第一分公司', '1', CURRENT_TIMESTAMP);
INSERT INTO T_SUBSTATEMENT(ID, STATEMENT_ID, MANAGER_USER_ID, TITLE, PARENT_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('2', '1', '3', '第二分公司', '', '001', '第二分公司第二分公司', '1', CURRENT_TIMESTAMP);
INSERT INTO T_SUBSTATEMENT(ID, STATEMENT_ID, MANAGER_USER_ID, TITLE, PARENT_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('3', '1', '4', '第三分公司', '2', '001', '第三分公司第三分公司', '1', CURRENT_TIMESTAMP);
INSERT INTO T_SUBSTATEMENT(ID, STATEMENT_ID, MANAGER_USER_ID, TITLE, PARENT_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES('4', '1', '5', '第四分公司', '3', '001', '第四分公司', '1', CURRENT_TIMESTAMP);

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

INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('13', '1', '1', '3', '2', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('14', '1', '2', '3', '3', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('15', '1', '3', '3', '4', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('16', '1', '4', '3', '5', '001');

INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('17', '1', '1', '4', '2', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('18', '1', '2', '4', '3', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('19', '1', '3', '4', '4', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('20', '1', '4', '4', '5', '001');

INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('21', '1', '1', '5', '2', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('22', '1', '2', '5', '3', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('23', '1', '3', '5', '4', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('24', '1', '4', '5', '5', '001');

INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('25', '1', '1', '6', '2', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('26', '1', '2', '6', '3', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('27', '1', '3', '6', '4', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('28', '1', '4', '6', '5', '001');

INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('29', '1', '1', '7', '2', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('30', '1', '2', '7', '3', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('31', '1', '3', '7', '4', '001');
INSERT INTO T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS) VALUES('32', '1', '4', '7', '5', '001');

INSERT INTO A(ID, A, STATEMENT_ID, SUBSTATEMENT_ID, MODE) VALUES('1', '1', '1', '1', 0);
INSERT INTO A(ID, A, STATEMENT_ID, SUBSTATEMENT_ID, MODE) VALUES('2', '2', '1', '2', 0);
