/* =============================================
*	��������:	������ ��� ������ ��������� ��������� ������ � �������� ����������
*	����������:	������������ ��������
* =============================================*/
DECLARE @text varchar(100)
SET @text = '%����� ��� ������%'

SELECT DISTINCT
	o.name AS [���������]
FROM
	sysobjects	o,
	syscomments	c
WHERE
	o.id	= c.id	AND
	o.type  = 'P'	AND
	(c.text like @text OR EXISTS(
								SELECT 
									1
								FROM 
									syscomments c2
								WHERE 
									c.id	  = c2.id		AND
									c.colid+1 = c2.colid	AND
									RIGHT(c.text,100) + SUBSTRING(c2.text,1,100) like @text
								)
	)
ORDER BY 1

