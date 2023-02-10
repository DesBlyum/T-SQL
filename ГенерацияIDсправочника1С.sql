-- копирование разделов(групп) справочника ...
-- из-за специфики 1С и настройки БД требуется доп. приседания для переноса данных справочника
DECLARE @MaxID char(12)
SELECT @MaxID = dbo.Convert36To10(LEFT(MAX(ID),6)) FROM [dbo].SC18218 WHERE RIGHT(ID,3) = 'ÖÈÁ'

INSERT INTO [SC18218]
        (ID
        ,[PARENTID]
        ,[CODE]
        ,[DESCR]
        ,[ISFOLDER]
        ,[ISMARK]
        ,[VERSTAMP]
        ,[SP18215]
        ,[SP18216]
        ,[SP18227])
SELECT
	dbo.Convert10To36(CAST(ROW_NUMBER() OVER(ORDER BY t.ID) as bigint) + @MaxID) + 'ÖÈÁ' as ID,
	ParentID,
	(CODE+200) as CODE,
	RTRIM(Descr)+'_äèñêàóíòåð',
	isfolder,
	ismark,
	0 as VERSTAMP,
	SP18215,
	sp18216,
	SP18227	
FROM SC18218 AS t
WHERE ISMARK = 0 and ISFOLDER = 1 and CODE < 100



