/**********************************
* ������� � �������� ������������� dynamic T-Sql
* ����������, ������� ������������ ��� ������� ����� �� ���������� ���������� �������, �������� ������,
* ��������, ��������� � ��������� ������ ��� ��������, �������� ��� �������� ������� �������� � �������� ����������.
***********************************/

-- ����������� ������ ������� �� ��������� � ��������� ����� EXEC/EXECUTE
DECLARE @sql varchar(1000)
DECLARE @columnList varchar(100)
DECLARE @nameTable varchar(100)

SET @columnList = 'ID'
SET @nameTable	= 'Test'

SELECT @sql = 'SELECT ' + @columnList + ' FROM ' +  @nameTable

EXEC (@sql)

-- C ������������� �������� ��������� sp_executesql
-- ��������� ������� ������ ���� �������������� � ������� .N 
DECLARE @sqlCommand NVARCHAR(1000)
DECLARE @ParmDef	NVARCHAR(1000)
DECLARE @value		INT
DECLARE @ret		INT

SET @sqlCommand = N'SELECT @ret = MAX(ID) FROM Test WHERE ID = @value'
SET @ParmDef	= N'@value int, @ret int OUT'
SET @value	= 5

EXEC sp_executesql @sqlCommand, @ParmDef, @value = @value, @ret = @ret OUT

SELECT @ret

-- ��������� �����
DECLARE @sqlCommand NVARCHAR(1000)
DECLARE @nameTable	NVARCHAR(100)
DECLARE @ret		INT

SET @nameTable	= 'Test'
SET @sqlCommand = 'SELECT @ret = MAX(ID) FROM ' + @nameTable

EXEC sp_executesql @sqlCommand, N'@ret int OUT', @ret = @ret OUT

SELECT @ret