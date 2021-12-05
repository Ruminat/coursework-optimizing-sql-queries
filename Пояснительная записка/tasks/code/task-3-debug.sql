SELECT * FROM student.student_grades_statistics;

GRANT CREATE MATERIALIZED VIEW TO student;
-- GRANT ON COMMIT REFRESH TO student;

-- CREATE MATERIALIZED VIEW LOG ON hr.study_group WITH ROWID (employee_id) INCLUDING NEW VALUES;
-- CREATE MATERIALIZED VIEW LOG ON hr.speciality WITH ROWID (employee_id) INCLUDING NEW VALUES;
-- CREATE MATERIALIZED VIEW LOG ON hr.student WITH ROWID (employee_id) INCLUDING NEW VALUES;
-- CREATE MATERIALIZED VIEW LOG ON hr.curriculum WITH ROWID (employee_id) INCLUDING NEW VALUES;

DROP INDEX grades_stud_num_idx;
DROP INDEX student_group_num_idx;
DROP INDEX student_grades_stud_num_course_num_idx;
DROP INDEX grades_exam_date_idx;

CREATE INDEX grades_stud_num_idx ON student.grades (stud_num);
EXEC DBMS_STATS.GATHER_TABLE_STATS('STUDENT', 'GRADES');


CREATE BITMAP INDEX student_group_num_idx ON student.student (group_num);
EXEC DBMS_STATS.GATHER_TABLE_STATS('STUDENT', 'STUDENT');
EXEC DBMS_STATS.GATHER_INDEX_STATS('STUDENT', 'STUDENT_GROUP_NUM_IDX');


CREATE INDEX student_grades_stud_num_course_num_idx ON student.grades (stud_num, course_num);
EXEC DBMS_STATS.GATHER_TABLE_STATS('STUDENT', 'GRADES');

CREATE INDEX grades_exam_date_idx ON student.grades (exam_date DESC);
-- ALTER INDEX grades_exam_date_idx REBUILD;
EXEC DBMS_STATS.GATHER_TABLE_STATS('STUDENT', 'GRADES');
EXEC DBMS_STATS.GATHER_INDEX_STATS('STUDENT', 'GRADES_EXAM_DATE_IDX');


EXEC DBMS_STATS.GATHER_TABLE_STATS('STUDENT', 'STUDENT');
EXEC DBMS_STATS.GATHER_TABLE_STATS('STUDENT', 'COURSE');
EXEC DBMS_STATS.GATHER_TABLE_STATS('STUDENT', 'GRADES');
EXEC DBMS_STATS.GATHER_TABLE_STATS('STUDENT', 'STUDY_GROUP');
EXEC DBMS_STATS.GATHER_TABLE_STATS('STUDENT', 'CURRICULUM');
EXEC DBMS_STATS.GATHER_TABLE_STATS('STUDENT', 'SPECIALITY');

ANALYZE TABLE student.student DELETE STATISTICS;
ANALYZE TABLE student.course DELETE STATISTICS;
ANALYZE TABLE student.grades DELETE STATISTICS;
ANALYZE TABLE student.study_group DELETE STATISTICS;
ANALYZE TABLE student.curriculum DELETE STATISTICS;
ANALYZE TABLE student.speciality DELETE STATISTICS;

-- sus
SELECT * FROM student.student ORDER BY 1 FETCH FIRST 30 ROWS ONLY;
SELECT * FROM student.course ORDER BY 1 FETCH FIRST 10 ROWS ONLY;
SELECT * FROM student.grades ORDER BY 1, 2, 3 FETCH FIRST 30 ROWS ONLY;
SELECT * FROM student.study_group ORDER BY 1 FETCH FIRST 20 ROWS ONLY;
SELECT * FROM student.curriculum ORDER BY 1 FETCH FIRST 10 ROWS ONLY;
SELECT * FROM student.speciality ORDER BY 1 FETCH FIRST 10 ROWS ONLY;



-- OG
WITH
  groups_with_students AS (
    SELECT
      student.study_group.group_num,
      student.speciality.spec_title,
      COUNT(student.stud_num) AS students_count
    FROM
      student.study_group
        JOIN student.speciality
          ON student.study_group.spec_num = student.speciality.spec_num
        LEFT JOIN student.student
          ON student.study_group.group_num = student.group_num
    GROUP BY
      student.study_group.group_num,
      student.speciality.spec_title
  ),
  student_courses AS (
    SELECT
      student.study_group.group_num,
      student.stud_num,
      student.curriculum.course_num
    FROM student.student
      JOIN student.study_group
        ON student.study_group.group_num = student.group_num
      JOIN student.curriculum
        ON student.study_group.spec_num = student.curriculum.spec_num
  ),
  correct_grades AS (
    SELECT
      student_courses.group_num,
      student.grades.stud_num,
      student.grades.course_num,
      FIRST_VALUE(student.grades.grade)
        OVER (
          PARTITION BY student.grades.stud_num, student.grades.course_num
          ORDER BY student.grades.exam_date DESC
        )
        AS last_grade
    FROM student.grades
      JOIN student_courses
        ON student.grades.stud_num = student_courses.stud_num
          AND student.grades.course_num = student_courses.course_num
  ),
  min_grades AS (
    SELECT
      group_num,
      stud_num,
      MIN(last_grade) AS min_grade
    FROM correct_grades
    GROUP BY group_num, stud_num
  )
SELECT
  groups_with_students.group_num AS "Группа",
  groups_with_students.students_count AS "Кол-во студентов",
  groups_with_students.spec_title AS "Кол-во студентов",
  COUNT(CASE WHEN min_grades.min_grade = 5 THEN 1 END) AS "Кол-во круглых отличников",
  COUNT(CASE WHEN min_grades.min_grade = 2 THEN 1 END) AS "Кол-во должников"
FROM groups_with_students
  LEFT JOIN min_grades
    ON min_grades.group_num = groups_with_students.group_num
GROUP BY
  groups_with_students.group_num,
  groups_with_students.students_count,
  groups_with_students.spec_title;

-- IOT
DROP TABLE student_lookup PURGE;
CREATE TABLE student_lookup (
  stud_num,
  group_num,
  CONSTRAINT student_lookup_pk PRIMARY KEY (stud_num)
)
ORGANIZATION INDEX
AS
  SELECT
    employee_id,
    job_id,
    last_name,
    salary
  FROM hr.employees;

SELECT
  job_id AS "Job ID",
  salary AS "Salary",
  -- CAST нужен для того, чтобы список помещался в одну строчку.
  CAST(
    LISTAGG(last_name, ', ')
      WITHIN GROUP (ORDER BY last_name)
    AS VARCHAR2(64)
  ) AS "Surnames"
FROM hr.employee_lookup
GROUP BY job_id, salary
HAVING COUNT(*) > 1
ORDER BY "Salary" DESC, "Job ID";
