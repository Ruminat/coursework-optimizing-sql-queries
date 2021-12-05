import { createCounter, generateSurnameRu, generateNameRu, generatePatronimRu, randomInt } from "../../utils.js"
import { studentStartId, studentsCount, groupStartId, groupsCount } from "../../definitions.js"

const studentCounter = createCounter(studentStartId)
const getStudentId = () => studentCounter()

export function generateStudents () {
  const students = []
  for (let i = studentStartId; i < studentStartId + studentsCount; i++) {
    students.push(generateStudent(i))
  }
  return students.join("\n")
}

function generateStudent (i) {
  const groupId = randomInt(groupStartId, groupStartId + groupsCount)
  const columns = `stud_num, last_name, first_name, patronymic, scholarship, group_num`
  const values = `${getStudentId()}, '${generateSurnameRu(i)}', '${generateNameRu(i)}', '${generatePatronimRu(i)}', 1729, ${groupId}`
  return `INSERT INTO student (${columns}) VALUES (${values});`
}
