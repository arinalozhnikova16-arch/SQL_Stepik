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

