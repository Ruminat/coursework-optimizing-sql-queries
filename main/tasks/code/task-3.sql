WITH
  groups_with_students AS (
    SELECT
      student.study_group.group_num,
      student.speciality.spec_title,
      COUNT(student.student.stud_num) AS students_count
    FROM
      student.study_group
        JOIN student.speciality
          ON student.study_group.spec_num = student.speciality.spec_num
        LEFT JOIN student.student
          ON student.study_group.group_num = student.student.group_num
    GROUP BY
      student.study_group.group_num,
      student.speciality.spec_title
  ),
  student_courses AS (
    SELECT
      student.study_group.group_num,
      student.student.stud_num,
      student.curriculum.course_num
    FROM student.student
      JOIN student.study_group
        ON student.study_group.group_num = student.student.group_num
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