1. «Процент мужщин/женщин в заданную дату (OE)»
  1. bitmap index (`gender`)
  2. function-based index (`TRUNC(order_date, 'dd')`)
2. «Имена сотрудник ов, встречающиеся более 2-ух раз (HR)»
  1. b-tree index (on `last_name`)
  2. переписывание запроса
3. «Вывод г рупп с отличник ами и должник ами (STUDENT)»
  1. ?
  2. ?
4. «К лиент, сделавший пок упк у на мак симальную сумму (SH)»
  1. ?
  2. ?
5. «Список сотрудник ов по должностям и зарплатам (HR)»
  1. ?
  2. ?