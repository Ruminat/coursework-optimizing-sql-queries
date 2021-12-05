set verify off

drop user student cascade;
create user student identified by oracle default tablespace USERS temporary tablespace TEMP;  

grant create session, connect, resource, create view, unlimited tablespace to student;  

connect student/oracle@xepdb1;

REM        БАЗА ДАННЫХ STUDENT

DROP TABLE STUDENT cascade constraints;  
DROP TABLE LECTURER cascade constraints; 
DROP TABLE COURSE cascade constraints;  
DROP TABLE GRADES cascade constraints; 
DROP TABLE CURRICULUM cascade constraints; 
DROP TABLE STUDY_GROUP  cascade constraints; 
DROP TABLE SPECIALITY  cascade constraints; 
DROP SEQUENCE asc_num_1;

CREATE TABLE STUDENT 
         (STUD_NUM NUMBER(5) NOT NULL, 
          LAST_NAME  VARCHAR2(30) NOT NULL,
          FIRST_NAME VARCHAR2(30) NOT NULL,
          PATRONYMIC VARCHAR2(30) NOT NULL,
          SCHOLARSHIP  NUMBER(7,2) DEFAULT 0 NOT NULL,
          GROUP_NUM VARCHAR2(30) ,
          PRIMARY KEY(STUD_NUM)); 

CREATE  TABLE    COURSE 
                                     (COURSE_NUM NUMBER(5, 0)  PRIMARY KEY  NOT NULL ENABLE, 
                                      TITLE   VARCHAR2(60),
                                      LECT_NUM  NUMBER(5, 0), 
                                      HOURS NUMBER(2, 0)   DEFAULT 0   NOT NULL ENABLE) ;

CREATE TABLE LECTURER
   (LECT_NUM    NUMBER(5) NOT NULL,
    LAST_NAME VARCHAR2(40)  NOT NULL,
    FIRST_NAME VARCHAR2(20) NOT NULL,
    PATRONYMIC  VARCHAR2(30) NOT NULL,
    HIRE_DATE  DATE default (sysdate),
    PHONE_NUM VARCHAR2(30) NOT NULL,
    POSITION  VARCHAR2(40) NOT NULL,
    DEPARTMENT  VARCHAR2(20) NOT NULL, 
    MANAGER  NUMBER(5),
    SALARY  NUMBER(7, 2) NOT NULL,
    CHECK(DEPARTMENT Like 'DEPARTMENT%'),  
     FOREIGN KEY(MANAGER) 
     REFERENCES LECTURER(LECT_NUM),
     PRIMARY KEY(LECT_NUM)); 


CREATE TABLE  GRADES 
        (NUM NUMBER(5) NOT NULL,
         GRADE  NUMBER(2) NOT NULL, 
         EXAM_DATE  DATE NOT NULL, 
         STUD_NUM NUMBER(5) NOT NULL, 
         COURSE_NUM NUMBER(5) NOT NULL, 
          PRIMARY KEY(NUM),
          CHECK(GRADE  between 1 and 5),
          FOREIGN KEY(STUD_NUM) 
          REFERENCES STUDENT(STUD_NUM), 
          FOREIGN KEY(COURSE_NUM) 
          REFERENCES  COURSE(COURSE_NUM)); 

CREATE  TABLE   STUDY_GROUP 
                                     (GROUP_NUM VARCHAR2(30)   PRIMARY KEY , 
                                      SPEC_NUM NUMBER(5, 0))  ;

CREATE   TABLE  CURRICULUM
                                    (SPEC_NUM     NUMBER(5, 0), 
                                     COURSE_NUM  NUMBER(5, 0)   CONSTRAINT   FK_DISC
                                     REFERENCES   COURSE (COURSE_NUM) ,
                                     CONSTRAINT PK_UCHEB 
                                     PRIMARY KEY (SPEC_NUM, COURSE_NUM)) ;

CREATE  TABLE SPECIALITY 
                            (SPEC_NUM NUMBER(5,  0)  PRIMARY KEY ,
                             SPEC_TITLE VARCHAR2(256)) ;


ALTER   TABLE   STUDENT   
                        ADD CONSTRAINT  FK_GROUP  
                        FOREIGN   KEY (GROUP_NUM) 
                         REFERENCES    STUDY_GROUP (GROUP_NUM) ENABLE NOVALIDATE ;

ALTER TABLE    CURRICULUM 
                                  ADD CONSTRAINT FK_SPEC 
                                 FOREIGN KEY (SPEC_NUM) REFERENCES SPECIALITY 
                                  (SPEC_NUM) ENABLE NOVALIDATE ;


ALTER TABLE   COURSE
                                 ADD CONSTRAINT FK_DISCIP  FOREIGN  KEY (LECT_NUM) 
                                  REFERENCES LECTURER   (LECT_NUM) ENABLE NOVALIDATE ;

ALTER TABLE   STUDY_GROUP 
                                 ADD CONSTRAINT FK_SPECIAL FOREIGN  KEY (SPEC_NUM) 
                                  REFERENCES SPECIALITY   (SPEC_NUM) ENABLE NOVALIDATE ;

CREATE SEQUENCE ASC_NUM_1
                INCREMENT BY 1 START WITH 1001 
                MAXVALUE 1.0E28 MINVALUE 1001 
                NOCYCLE CACHE 20 ORDER;
   
CREATE OR REPLACE TRIGGER TR_SEQ_1 
            BEFORE INSERT ON  GRADES FOR EACH ROW 
            BEGIN
                        SELECT ASC_NUM_1.nextval   INTO :new.NUM  FROM dual; 
           END; 
/

INSERT INTO  SPECIALITY VALUES(1, 'СИСТЕМЫ АВТОМАТИЧЕСКОГО УПРАВЛЕНИЯ');
INSERT INTO  SPECIALITY VALUES(2, 'МАТЕМАТИЧЕСКОЕ ОБЕСПЕЧЕНИЕ ЭВМ');
INSERT INTO  SPECIALITY VALUES(3, 'ВЫЧИСЛИТЕЛЬНЫЕ СЕТИ И СИСТЕМЫ');
INSERT INTO  SPECIALITY VALUES(4, 'ЭКОНОМИКА ПРЕДПРИЯТИЙ');

INSERT INTO  STUDY_GROUP  VALUES (121 ,1 );
INSERT INTO  STUDY_GROUP  VALUES (122 ,1 );
INSERT INTO  STUDY_GROUP  VALUES (123 ,4 );
INSERT INTO  STUDY_GROUP  VALUES (124 ,4 );

INSERT INTO STUDENT  VALUES (3412 ,'Поляков' ,'Анатолий' ,'Алексеевич' ,200 , 121 );
INSERT INTO STUDENT  VALUES (3413 ,'Старова' ,'Любовь' ,'Михайловна' ,250 ,121 );
INSERT INTO STUDENT  VALUES (3414 ,'Гриценко' ,'Владимир ' ,'Николаевич' ,300,121 );
INSERT INTO STUDENT VALUES (3415 ,'Котенко' ,'Анатолий' ,'Николаевич' ,0,122);
INSERT INTO STUDENT  VALUES (3416 ,'Нагорный' ,'Евгений' ,'Васильевич' ,200,122);
INSERT INTO STUDENT  VALUES (3417 ,'Устинов' ,'Владимир' ,'Викторович' ,250,123);
INSERT INTO STUDENT  VALUES (3418 ,'Усов' ,'Валерий' ,'Харитонович' ,250,123);
INSERT INTO STUDENT  VALUES (3419 ,'Улиткин' ,'Андрей' ,'Сергеевич' ,225,124);
INSERT INTO STUDENT  VALUES (3420 ,'Ежов' ,'Алексей' ,'Павлович' ,200,124);

INSERT INTO LECTURER
VALUES (4002 ,'Костыркин' ,'Олег' ,'Владимирович' ,
                  TO_DATE('1-sep-1997', 'dd-Mon-yyyy') ,
                  '2-46-89-71' ,'Профессор' ,'DEPARTMENT 1' , NULL ,4000);
INSERT INTO LECTURER
VALUES (4001 ,'Викулина' ,'Валентина' ,'Ивановна' ,
                  TO_DATE('1-apr-1998', 'dd-Mon-yyyy') ,
                   '2-46-89-70' ,'Доцент' ,'DEPARTMENT 1' ,4002 ,3000  );
INSERT INTO LECTURER
VALUES (4006 ,'Соколов' ,'Петр' ,'Николаевич' ,
                  TO_DATE('1-feb-1978', 'dd-Mon-yyyy') ,
                   '2-46-89-75' ,'Ассистент' ,'DEPARTMENT 1' ,4001 ,1500  );
INSERT INTO LECTURER
VALUES (4003 ,'Казанко' ,'Виталий' ,'Владимрович' ,
                  TO_DATE('1-sep-1988', 'dd-Mon-yyyy') ,
                  '2-46-89-73' ,'Преподаватель' ,'DEPARTMENT 1' ,4006 ,2000  );
INSERT INTO LECTURER
VALUES (4008 ,'Абдулов' ,'Семен' ,'Антонович' ,
                  TO_DATE('1-jun-1988', 'dd-Mon-yyyy') ,
                  '2-46-89-78' ,'Доцент' ,'DEPARTMENT 2' ,NULL ,3000  );
INSERT INTO LECTURER
VALUES (4007 ,'Студейкин' ,'Андрей' ,'Андреевич' ,
                   TO_DATE('1-may-1979', 'dd-Mon-yyyy') ,
                   '2-46-89-78' ,'Доцент' ,'DEPARTMENT 2' ,4008 ,2500  );
INSERT INTO LECTURER
VALUES (4005 ,'Загарийчук' ,'Игорь' ,'Дмитриевич' ,
                  TO_DATE('1-sep-1977', 'dd-Mon-yyyy') ,
                  '2-46-89-78' ,'Ассистент' ,'DEPARTMENT 2' ,4008 ,2000  );
INSERT INTO LECTURER
VALUES (4004 ,'Позднякова' ,'Любовь' ,'Алексеевна' ,
                  TO_DATE('10-may-1979', 'dd-Mon-yyyy') ,
                  '2-46-89-72' ,'Преподаватель' ,'DEPARTMENT 2' ,4005 ,2500  );
INSERT INTO LECTURER
VALUES (4009 ,'Тарасова' ,'Людмила' ,'Алексеевна' ,
                  TO_DATE('20-may-1981', 'dd-Mon-yyyy') ,
                  '2-46-89-72' ,'Преподаватель' ,'DEPARTMENT 2' ,4008 ,2000  );

INSERT INTO COURSE   VALUES (2001 ,'Физика' ,4001,34 );
INSERT INTO COURSE     VALUES (2002 ,'Химия' ,4002,68 );
INSERT INTO COURSE    VALUES (2003 ,'Математика' ,4001,68  );
INSERT INTO COURSE    VALUES (2004 ,'Философия' ,4004 ,17  );
INSERT INTO COURSE      VALUES (2005 ,'Экономика' ,4005 ,17  );
INSERT INTO COURSE     VALUES (2006 ,'Менеджмент' , NULL ,34 );

INSERT INTO  CURRICULUM   VALUES (1, 2001 );
INSERT INTO  CURRICULUM   VALUES (1, 2003 );
INSERT INTO  CURRICULUM   VALUES (4, 2003 );
INSERT INTO  CURRICULUM   VALUES (4, 2006);
INSERT INTO  CURRICULUM   VALUES (4, 2005 );


INSERT INTO GRADES 
 VALUES ( NULL ,5 ,TO_DATE('10-jun-1999', 'dd-Mon-yyyy') ,3412 ,2001  );  
INSERT INTO GRADES  
 VALUES ( NULL ,5 ,TO_DATE('10-jun-1999', 'dd-Mon-yyyy') ,3413 ,2001  );
INSERT INTO GRADES  
 VALUES ( NULL ,5 ,TO_DATE('12-jun-1999', 'dd-Mon-yyyy') ,3413 ,2003  );
INSERT INTO GRADES
 VALUES ( NULL ,2 ,TO_DATE('10-jun-1999', 'dd-Mon-yyyy') ,3414 ,2001  );
INSERT INTO GRADES
 VALUES ( NULL ,3 ,TO_DATE('15-jun-1999', 'dd-Mon-yyyy') ,3414 ,2005  );
INSERT INTO GRADES
  VALUES ( NULL ,4 ,TO_DATE('12-jun-1999', 'dd-Mon-yyyy') ,3412 ,2003  );
INSERT INTO GRADES
  VALUES ( NULL ,5 ,TO_DATE('12-jun-1999', 'dd-Mon-yyyy') ,3416 ,2003  );
INSERT INTO GRADES
  VALUES ( NULL ,2 ,TO_DATE('12-jun-1999', 'dd-Mon-yyyy') ,3417 ,2003  );
INSERT INTO GRADES
  VALUES ( NULL ,5 ,TO_DATE('12-jun-1999', 'dd-Mon-yyyy') ,3418 ,2003  );
INSERT INTO GRADES
  VALUES ( NULL ,4 ,TO_DATE('18-jun-1999', 'dd-Mon-yyyy') ,3418 ,2006  );
INSERT INTO GRADES
  VALUES ( NULL ,3 ,TO_DATE('15-jun-1999', 'dd-Mon-yyyy') ,3418 ,2005  );

COMMIT;

REM  ###########################################################################
