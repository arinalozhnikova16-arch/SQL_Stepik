/* В таблицу attempt включить новую попытку для студента Баранова Павла по дисциплине «Основы баз данных».
Установить текущую дату в качестве даты выполнения попытки. */

INSERT INTO attempt (student_id, subject_id, date_attempt)
VALUES
    (
        (SELECT student_id
        FROM student
        WHERE name_student = "Баранов Павел"),
        (SELECT subject_id
        FROM subject
        WHERE name_subject = "Основы баз данных"),
        NOW()
    );
    
SELECT * FROM attempt;

/****************************************************************/

/* Случайным образом выбрать три вопроса по дисциплине, тестирование по которой собирается проходить студент,
занесенный в таблицу attempt последним, и добавить их в таблицу testing. id последней попытки
получить как максимальное значение id из таблицы attempt. */

INSERT INTO testing (attempt_id, question_id)
SELECT
    (
        SELECT attempt_id
        FROM attempt
        ORDER BY attempt_id DESC
        LIMIT 1
    ),
    q.question_id
    FROM question q
    WHERE q.subject_id = 
        (
            SELECT subject_id
            FROM attempt
            ORDER BY attempt_id DESC
            LIMIT 1
        )
    ORDER BY RAND()
    LIMIT 3;

SELECT * FROM testing;

/****************************************************************/

/* Студент прошел тестирование (то есть все его ответы занесены в таблицу testing), далее необходимо
вычислить результат(запрос) и занести его в таблицу attempt для соответствующей попытки.  Результат попытки вычислить
как количество правильных ответов, деленное на 3 (количество вопросов в каждой попытке) и умноженное на 100. Результат округлить до целого.
Будем считать, что мы знаем id попытки,  для которой вычисляется результат, в нашем случае это 8. */

UPDATE attempt
SET result =
    (
        SELECT ROUND(((SUM(is_correct) / 3) * 100))
        FROM
            testing t
            INNER JOIN answer a USING(answer_id)
        WHERE attempt_id = 8
    )
WHERE attempt_id = 8;

SELECT * FROM attempt;

/****************************************************************/

/* Удалить из таблицы attempt все попытки, выполненные раньше 1 мая 2020 года. Также удалить и все соответствующие этим попыткам вопросы из таблицы testing */

DELETE FROM attempt
WHERE date_attempt < "2020-05-01";

SELECT * FROM attempt;
SELECT * FROM testing;

/****************************************************************/

