-- MS SQL
-- Формирование письма-уведомления для филиалов
-- в зависимости от условий выполнения плана продаж сопутствующих товаров
-- анализ данных производиться на основании данных процедуры:
--"ПолучитьДанные_ВыполнениеЦелейДопродаж"
	-- данные о продажах на основании документов "Розничные чеки"
	-- для анализа берутся продажи двух предыдущих месяцев и сравниваются с текущим (т.е. 3 периода)
	-- ЧекиВсего1 - в чеки одна позиция "сопутствующего" товара
	-- ЧекиВсего2 - в чеки две позиции "сопутствующего" товара
	-- ЧекиВсего3 - в чек вошло три и более позиции "сопутствующего" товара

DECLARE @ТаблицаРезультатов TABLE (
					СкладКод int,
					СкладНаименование varchar(150),
					ДоменноеИмя varchar(20),
					Период1_Чеки1 int, 
					Период2_Чеки1 int, 
					Период3_Чеки1 int, 
					Период1_СреднийЧек1 money, 
					Период2_СреднийЧек1 money, 
					Период3_СреднийЧек1 money, 
					Период1_СреднийЧек money,
					Период2_СреднийЧек money,
					Период3_СреднийЧек money, 
					Период1_СуммаЧеки1 money, 
					Период2_СуммаЧеки1 money, 
					Период3_СуммаЧеки1 money, 
					ЧекиВсего1 int,
					ЧекиВсего2 int,
					ЧекиВсего3 int,
					Период3_ПроцентОтОбщего1 money,
					Цель_ПроцентОтОбщего1 money,
					Цель_СреднийЧек1 money
		
	)
DECLARE @ДатаПостроения datetime = dateadd(dd, -1, getdate())
DECLARE @Дата varchar(8) = convert(varchar, @ДатаПостроения, 112)
INSERT @ТаблицаРезультатов EXEC ПолучитьДанные_ВыполнениеЦелейДопродаж @Дата
	
DECLARE 
	@СкладКод int,
	@СкладНаименование varchar(150),
	@ДоменноеИмя varchar(20),
	@Период3_Чеки1 int, 
	@Период3_СреднийЧек1 money, 
	@Период1_СреднийЧек money,
	@Период2_СреднийЧек money,
	@Период3_СреднийЧек money, 
	@ЧекиВсего1 int,
	@ЧекиВсего2 int,
	@ЧекиВсего3 int,
	@Период3_ПроцентОтОбщего1 money,
	@Цель_ПроцентОтОбщего1 money,
	@Цель_СреднийЧек1 money,
	@Цель_ПроцентОтОбщего1_Выполнение varchar(150),
	@Цель_СреднийЧек1_Выполнение varchar(150),
	@ТемаПисьма varchar(250),
	@ТекстПисьма varchar(max),
	@Адрес varchar(50)

DECLARE cur CURSOR local FOR
	SELECT 
		СкладКод,
		СкладНаименование,
		ДоменноеИмя,
		Период3_Чеки1,
		Период3_СреднийЧек1,
		Период1_СреднийЧек,
		Период2_СреднийЧек,
		Период3_СреднийЧек,
		ЧекиВсего1,
		ЧекиВсего2,
		ЧекиВсего3,
		Период3_ПроцентОтОбщего1,
		Цель_ПроцентОтОбщего1,
		Цель_СреднийЧек1,
		CASE
			WHEN Период3_ПроцентОтОбщего1 <= Цель_ПроцентОтОбщего1 THEN '(условие выполнено)'
			ELSE '(условие не выполнено, доля выше 20%, не хватает  ' + cast(cast(ЧекиВсего3 * (Цель_ПроцентОтОбщего1 / 100.0) - Период3_Чеки1 as int) as varchar)+ ' чеков с допродажами)'
		END as Цель_ПроцентОтОбщего1_Выполнение,
		CASE
			WHEN Период3_СреднийЧек >= Цель_СреднийЧек1 THEN '(условие выполнено)' 
			ELSE '(условие не выполнено, необходимо делать допродажу большему кол-ву покупателей или товара с более высокой ценой, цель - '+ cast(Цель_СреднийЧек1 as varchar)+')'
		END as Цель_СреднийЧек1_Выполнение
	FROM
		@ТаблицаРезультатов

OPEN cur
FETCH NEXT FROM cur 
	INTO @СкладКод, @СкладНаименование,	@ДоменноеИмя, @Период3_Чеки1, @Период3_СреднийЧек1, @Период1_СреднийЧек, @Период2_СреднийЧек, @Период3_СреднийЧек, @ЧекиВсего1, @ЧекиВсего2, @ЧекиВсего3, @Период3_ПроцентОтОбщего1, @Цель_ПроцентОтОбщего1, @Цель_СреднийЧек1, @Цель_ПроцентОтОбщего1_Выполнение, @Цель_СреднийЧек1_Выполнение

WHILE @@fetch_status = 0 
BEGIN
	SET @ТемаПисьма = 'Выполнение плана допродаж по состоянию на: ' + convert(varchar, @ДатаПостроения, 104)
	SET @ТекстПисьма = '' 
	SET @ТекстПисьма = @ТекстПисьма + 'Итоги с начала месяца по: ' + convert(varchar, @ДатаПостроения, 104) + char(13)
	SET @ТекстПисьма = @ТекстПисьма +'	- чеков с одним SKU: ' + cast(@Период3_Чеки1 as varchar) + char(13)
	SET @ТекстПисьма = @ТекстПисьма +'	- всего чеков: ' + cast(@ЧекиВсего3 as varchar) + char(13) + char(13)

	SET @ТекстПисьма = @ТекстПисьма + 'Выполнение целей' + char(13)
	SET @ТекстПисьма = @ТекстПисьма + '  - чеки с одним SKU: доля чеков от общего количества: ' + cast(@Период3_ПроцентОтОбщего1 as varchar)+' % ' + + @Цель_ПроцентОтОбщего1_Выполнение + char(13)
	SET @ТекстПисьма = @ТекстПисьма + '  - средний чек: ' + cast(@Период3_СреднийЧек as varchar) + ' руб. ' + @Цель_СреднийЧек1_Выполнение + char(13) + char(13) 
			
	Set @Адрес = @ДоменноеИмя+'@Домен.ru'	
	EXEC rs_SendMessage null, 'mail', null, @Адрес, @ТемаПисьма, @ТекстПисьма, NULL, NULL, null, NULL, NULL, NULL, NULL
			
	FETCH NEXT FROM cur 
		INTO @СкладКод, @СкладНаименование,	@ДоменноеИмя, @Период3_Чеки1, @Период3_СреднийЧек1, @Период1_СреднийЧек, @Период2_СреднийЧек, @Период3_СреднийЧек, @ЧекиВсего1, @ЧекиВсего2, @ЧекиВсего3, @Период3_ПроцентОтОбщего1, @Цель_ПроцентОтОбщего1, @Цель_СреднийЧек1, @Цель_ПроцентОтОбщего1_Выполнение, @Цель_СреднийЧек1_Выполнение
END
CLOSE cur
DEALLOCATE cur
