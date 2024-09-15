/**********************************
* Примеры и вариации использования dynamic T-Sql
* Инструмент, который используется для решения задач по построению динамичных отчётов, миграция данных,
* создание, изменение и получение данных или объектов, значения или названия которых приходят в качестве параметров.
***********************************/

-- Составление текста запроса со вставками и выполение через EXEC/EXECUTE
-- При таком запросе возможны SQL инъекции. Например, могут задать значение вроде такого @nameTable = 'DROP TABLE Test'
DECLARE @sql		VARCHAR(1000)
DECLARE @columnList VARCHAR(100)
DECLARE @nameTable	VARCHAR(100)

SET @columnList = 'ID'
SET @nameTable	= 'Test'

SELECT @sql = 'SELECT ' + @columnList + ' FROM ' +  @nameTable

EXEC (@sql)

-- C использование хранимой процедуры sp_executesql
-- Константы Юникода должны быть префиксированы с помощью .N 
DECLARE @sqlCommand NVARCHAR(1000)
DECLARE @ParmDef	NVARCHAR(1000)
DECLARE @value		INT
DECLARE @ret		INT

SET @sqlCommand = N'SELECT @ret = MAX(ID) FROM Test WHERE ID = @value'
SET @ParmDef	= N'@value int, @ret int OUT'
SET @value		= 5

EXEC sp_executesql @sqlCommand, @ParmDef, @value = @value, @ret = @ret OUT

SELECT @ret

-- Смешанный стиль
DECLARE @sqlCommand NVARCHAR(1000)
DECLARE @nameTable	NVARCHAR(100)
DECLARE @ret		INT

SET @nameTable	= 'Test'
SET @sqlCommand = 'SELECT @ret = MAX(ID) FROM ' + @nameTable

EXEC sp_executesql @sqlCommand, N'@ret int OUT', @ret = @ret OUT

SELECT @ret

-- Передача наименование таблицы в качестве параметра 
--(используется QUOTENAME() - Возвращает строку Юникода с разделителями, добавленными, чтобы сделать входную строку допустимым идентификатором разделителя SQL Server)
DECLARE @sqlCommand NVARCHAR(1000)
DECLARE @ParmDef	NVARCHAR(1000)
DECLARE @nameTable	NVARCHAR(500)
DECLARE @value		INT
DECLARE @ret		INT

SET @nameTable	= 'Test'
SET @value		= 5

SET @sqlCommand = N'SELECT @ret = MAX(ID) FROM  '+ QuoteName(@nameTable) + 'WHERE ID = @value'
SET @ParmDef	= N'@value int, @ret int OUT'

EXEC sp_executesql @sqlCommand, @ParmDef, @value = @value, @ret = @ret OUT

SELECT @ret