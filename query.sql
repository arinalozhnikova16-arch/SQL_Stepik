/* Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат.
Информацию вывести по убыванию результатов тестирования. */

SELECT st.name_student, a.date_attempt, a.result
FROM
    student st
    INNER JOIN attempt a ON st.student_id = a.student_id
    INNER JOIN subject sb ON a.subject_id = sb.subject_id
WHERE sb.name_subject = "Основы баз данных"
ORDER BY 3 DESC;

/****************************************************************/

/* Вывести, сколько попыток сделали студенты по каждой дисциплине, а также средний результат попыток, который округлить до 2 знаков после запятой.
Под результатом попытки понимается процент правильных ответов на вопросы теста, который занесен в столбец result.
В результат включить название дисциплины, а также вычисляемые столбцы Количество и Среднее. Информацию вывести по убыванию средних результатов. */

SELECT s.name_subject, COUNT(a.subject_id) AS Количество, ROUND(AVG(a.result), 2) AS Среднее
FROM 
    subject s
    LEFT OUTER JOIN attempt a USING(subject_id)
GROUP BY s.name_subject
ORDER BY Среднее DESC;

/****************************************************************/

/* Вывести студентов (различных студентов), имеющих максимальные результаты попыток. Информацию отсортировать в алфавитном порядке по фамилии студента.
Максимальный результат не обязательно будет 100%, поэтому явно это значение в запросе не задавать. */

SELECT s.name_student, a.result
FROM
    student s
    INNER JOIN attempt a USING(student_id)
WHERE a.result = 
    (
        SELECT MAX(result)
        FROM attempt
    )
ORDER BY 1;

/****************************************************************/

/* Если студент совершал несколько попыток по одной и той же дисциплине, то вывести разницу в днях между первой и последней попыткой.
В результат включить фамилию и имя студента, название дисциплины и вычисляемый столбец Интервал. Информацию вывести по возрастанию разницы.
Студентов, сделавших одну попытку по дисциплине, не учитывать. */

SELECT st.name_student, sb.name_subject, DATEDIFF(MAX(date_attempt), MIN(date_attempt)) AS Интервал
FROM
    student st
    INNER JOIN attempt a USING(student_id)
    INNER JOIN subject sb USING(subject_id)
GROUP BY st.name_student, sb.name_subject
HAVING COUNT(attempt_id) > 1
ORDER BY Интервал ASC;

/****************************************************************/

/* Студенты могут тестироваться по одной или нескольким дисциплинам (не обязательно по всем). Вывести дисциплину и количество уникальных студентов
(столбец назвать Количество), которые по ней проходили тестирование . Информацию отсортировать сначала по убыванию количества, а потом по названию дисциплины.
В результат включить и дисциплины, тестирование по которым студенты еще не проходили, в этом случае указать количество студентов 0. */

SELECT s.name_subject, COUNT(DISTINCT a.student_id) AS Количество
FROM
    subject s
    LEFT OUTER JOIN attempt a ON s.subject_id = a.subject_id
GROUP BY s.name_subject
ORDER BY 2 DESC, 1 ASC;

/****************************************************************/

/* Случайным образом отберите 3 вопроса по дисциплине «Основы баз данных». В результат включите столбцы question_id и name_question. */

SELECT q.question_id, q.name_question
FROM
    subject s
    INNER JOIN question q USING(subject_id)
WHERE s.name_subject = "Основы баз данных"
ORDER BY RAND()
LIMIT 3;

/****************************************************************/

/* Вывести вопросы, которые были включены в тест для Семенова Ивана по дисциплине «Основы SQL» 2020-05-17
(значение attempt_id для этой попытки равно 7). Указать, какой ответ дал студент и правильный он или нет
(вывести Верно или Неверно). В результат включить вопрос, ответ и вычисляемый столбец  Результат. */

SELECT q.name_question, a.name_answer,
    IF(a.is_correct = 1, "Верно", "Неверно") AS Результат
FROM
    answer a
    INNER JOIN testing t USING(answer_id)
    INNER JOIN question q ON q.question_id = t.question_id
WHERE t.attempt_id = 7;

/****************************************************************/

/* Посчитать результаты тестирования. Результат попытки вычислить как количество правильных ответов, деленное
на 3 (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до двух знаков после запятой.
Вывести фамилию студента, название предмета, дату и результат. Последний столбец назвать Результат.
Информацию отсортировать сначала по фамилии студента, потом по убыванию даты попытки. */

SELECT st.name_student, sb.name_subject, a.date_attempt,
    ROUND((SUM(is_correct) / 3) * 100, 2) AS Результат 
FROM
    student st
    INNER JOIN attempt a ON st.student_id = a.student_id
    INNER JOIN testing t ON a.attempt_id = t.attempt_id
    INNER JOIN subject sb ON a.subject_id = sb.subject_id
    INNER JOIN question q ON t.question_id = q.question_id
    INNER JOIN answer an ON t.answer_id = an.answer_id
GROUP BY 1, 2, 3
ORDER BY 1, 3 DESC;

/****************************************************************/

/* Для каждого вопроса вывести процент успешных решений, то есть отношение количества верных ответов к общему количеству
ответов, значение округлить до 2-х знаков после запятой. Также вывести название предмета, к которому относится вопрос, и
общее количество ответов на этот вопрос. В результат включить название дисциплины, вопросы по ней (столбец назвать Вопрос),
а также два вычисляемых столбца Всего_ответов и Успешность. Информацию отсортировать сначала по названию дисциплины, потом
по убыванию успешности, а потом по тексту вопроса в алфавитном порядке.
Поскольку тексты вопросов могут быть длинными, обрезать их 30 символов и добавить многоточие "...". */

SELECT
    sb.name_subject,
    CONCAT(LEFT(q.name_question, 30), "...") AS Вопрос,
    COUNT(t.answer_id) AS Всего_ответов,
    ROUND((SUM(is_correct) / COUNT(t.answer_id)) * 100, 2) AS Успешность
FROM
    student st
    INNER JOIN attempt a ON st.student_id = a.student_id
    INNER JOIN testing t ON a.attempt_id = t.attempt_id
    INNER JOIN subject sb ON a.subject_id = sb.subject_id
    INNER JOIN question q ON t.question_id = q.question_id
    INNER JOIN answer an ON t.answer_id = an.answer_id
GROUP BY 1, 2
ORDER BY 1, 4 DESC, 2

/****************************************************************/











