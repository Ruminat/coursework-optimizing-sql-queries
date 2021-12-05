import { groupsCount, groupStartId } from "../../definitions.js"
import { randomFrom } from "../../utils.js";

const specialities = [1, 4]

export function generateGroups () {
  const groups = []
  for (let i = groupStartId; i < groupStartId + groupsCount; i++) {
    groups.push(generateGroup(i))
  }
  return groups.join("\n")
}

function generateGroup (i) {
  return `INSERT INTO study_group (group_num, spec_num) VALUES (${i}, ${randomFrom(specialities)});`;
}

// delete from study_group where group_num = 666;
// select * from study_group;
