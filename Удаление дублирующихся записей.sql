/******************************************************************************************************
* Примеры и вариации поиска и удаления дублирующихся записей.
*
*	1. Having count(*)
*	2. Оконная функция ROW_NUMBER()
*	3. WITH - временный результирующий набор(CTE)
*	4. JOIN
*	5. Функция ранжирования rank()
* 
*******************************************************************************************************/
-- Создание таблицы для тестирования
IF OBJECT_ID('t') IS NOT NULL
BEGIN
	DROP TABLE t
END
GO

CREATE TABLE t 
	(
		id		INT IDENTITY NOT NULL PRIMARY KEY,
		col_num NUMERIC,
		col_int INT
	)
GO

-- Заполнение тестовыми данными
INSERT INTO t
	(col_num, col_int)
VALUES
	(null, 1),
	(null, 1),
	(null, 1),
	(null, 4),
	(null, null),
	(null, null),
	(null, 13),
	(null, 13.00),
	(null, 13.00),
	(5, null),
	(5, 0.00)
GO

-- Вариант 1.
-- Выборка дублей через Having count(*)
SELECT 
	t.col_int,
	t.col_num,
	COUNT(*) КолВо_Дублей 
FROM
	t
GROUP BY   
	t.col_int,
	t.col_num
Having 	
	COUNT(*) > 1

-- Удаляем все задвоения, кроме первовведенных (с минимальным ID)
DELETE
FROM 
	t
WHERE id NOT IN (
				SELECT
					MIN(t.id)
				FROM
					t
				GROUP BY   
					t.col_int,
					t.col_num
				)

-- Вариант 2.
-- Выборка дублей с помощью оконной функции ROW_NUMBER()
SELECT  
	tbl.id,
	tbl.Rownum
FROM (
		SELECT 
			t.id,
			ROW_NUMBER() OVER(PARTITION BY t.col_int, t.col_num ORDER BY ID) Rownum
		FROM 
			t
	)tbl
WHERE 
	Rownum > 1

-- Удаляем все задвоения, кроме последних (с максимальным ID)
DELETE
FROM 
	t
WHERE id IN (
				SELECT  
					tbl.id
				FROM (
						SELECT 
							t.id,
							ROW_NUMBER() OVER(PARTITION BY t.col_int, t.col_num ORDER BY ID DESC) Rownum
						FROM 
							t
					)tbl
				WHERE 
					Rownum > 1
			)

-- Вариант 3.
-- Используем WITH CTE - это временный результирующий набор, на который можно ссылаться в другой инструкции 
WITH CTE (
	col_int,
	col_num,
	Rownum
)
AS (SELECT 
		col_int,
		col_num,
	    ROW_NUMBER() OVER(PARTITION BY t.col_int, t.col_num ORDER BY ID) AS Rownum
	FROM 
		t)
DELETE FROM CTE
WHERE 
	Rownum > 1
GO

-- Вариант 4.
-- Выборка дублей через Join
DELETE
FROM 
	t
WHERE id IN (
			SELECT
				t.id
			FROM
				t
			LEFT JOIN
				(SELECT MIN(id) as id, col_int, col_num FROM t GROUP BY col_int, col_num) as t2
				ON
					t.id = t2.id
			WHERE
				t2.id is NULL
			)


-- Вариант 5.
-- Выборка дублей с использованием rank()
SELECT 
	t1.col_int,
	t1.col_num, 
	t2.ranking
FROM
	t as t1
INNER JOIN
	(SELECT 
		*,
		rank() OVER(PARTITION BY col_int, col_num ORDER BY id) as ranking
	FROM
		t
	) as t2
	ON t1.id = t2.id
WHERE
	ranking > 1

-- Удаление дублей rank()
DELETE
FROM	
	t
WHERE 
	ID IN (
			SELECT 
				t1.id
			FROM
				t as t1
			INNER JOIN
				(SELECT 
					*,
					rank() OVER(PARTITION BY col_int, col_num ORDER BY id) as ranking
				FROM
					t
				) as t2
				ON t1.id = t2.id
			WHERE
				ranking > 1)