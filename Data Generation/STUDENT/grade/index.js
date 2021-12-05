import { createCounter, randomInt, randomFrom } from "../../utils.js"
import { studentStartId, studentsCount, gradeStartId } from "../../definitions.js"

const date1 = `TO_DATE('10.06.1999', 'dd.mm.yyyy')`
const date2 = `TO_DATE('12.06.1999', 'dd.mm.yyyy')`
const courseIds = [`2001`, `2003`]

const gradeCounter = createCounter(gradeStartId)
const getGradeId = () => gradeCounter()

export function generateGrades () {
  const grades = []
  for (let i = studentStartId; i < studentStartId + studentsCount; i++) {
    const grade = randomInt(2, 5)
    const courseId = randomFrom(courseIds)
    const studentId = i
    grades.push(generateGrade({ date: date1, courseId, grade, studentId }))

    if (grade === 2 && randomInt(0, 1) === 1) {
      const newGrade = randomInt(2, 5)
      grades.push(generateGrade({ date: date2, courseId, grade: newGrade, studentId }))
    }
  }
  return grades.join("\n")
}

function generateGrade ({ date = date1, courseId = courseIds[0], grade = 4, studentId } = {}) {
  const columns = `num, grade, exam_date, stud_num, course_num`
  const values = `${getGradeId()}, ${grade}, ${date}, ${studentId}, ${courseId}`
  return `INSERT INTO grades (${columns}) VALUES (${values});`
}
