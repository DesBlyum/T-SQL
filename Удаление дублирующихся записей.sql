/******************************************************************************************************
* ������� � �������� ������ � �������� ������������� �������.
*
*	1. Having count(*)
*	2. ������� ������� ROW_NUMBER()
*	3. WITH - ��������� �������������� �����(CTE)
*	4. LEFT JOIN
* 
*******************************************************************************************************/
-- �������� ������� ��� ������������
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

-- ���������� ��������� �������
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

-- ������� 1.
-- ������� ������ ����� Having count(*)
SELECT 
	t.col_int,
	t.col_num,
	COUNT(*) �����_������ 
FROM
	t
GROUP BY   
	t.col_int,
	t.col_num
Having 	
	COUNT(*) > 1

-- ������� ��� ���������, ����� �������������� (� ����������� ID)
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

-- ������� 2.
-- ������� ������ � ������� ������� ������� ROW_NUMBER()
SELECT  
	tbl.id,
	tbl.Rownum
FROM (
		SELECT 
			t.id,
			ROW_NUMBER() OVER(Partition By t.col_int, t.col_num ORDER by ID) Rownum
		FROM 
			t
	)tbl
WHERE 
	Rownum > 1

-- ������� ��� ���������, ����� ��������� (� ������������ ID)
DELETE
FROM 
	t
WHERE id IN (
				SELECT  
					tbl.id
				FROM (
						SELECT 
							t.id,
							ROW_NUMBER() OVER(Partition By t.col_int, t.col_num ORDER by ID DESC) Rownum
						FROM 
							t
					)tbl
				WHERE 
					Rownum > 1
			)

-- ������� 3.
-- ���������� WITH CTE - ��� ��������� �������������� �����, �� ������� ����� ��������� � ������ ���������� 
WITH CTE (
	col_int,
	col_num,
	Rownum
)
AS (SELECT 
		col_int,
		col_num,
	    ROW_NUMBER() OVER(Partition By t.col_int, t.col_num ORDER by ID) AS Rownum
	FROM 
		t)
DELETE FROM CTE
WHERE 
	Rownum > 1
GO

-- ������� 4.
-- ������� ������ ����� Join
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