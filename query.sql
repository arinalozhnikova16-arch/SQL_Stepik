/* Вывести студентов, которые сдавали дисциплину «Основы баз данных», указать дату попытки и результат. Информацию вывести по убыванию результатов тестирования. */

SELECT st.name_student, a.date_attempt, a.result
FROM
    student st
    INNER JOIN attempt a ON st.student_id = a.student_id
    INNER JOIN subject sb ON a.subject_id = sb.subject_id
WHERE sb.name_subject = "Основы баз данных"
ORDER BY 3 DESC;

