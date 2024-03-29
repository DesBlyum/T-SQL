-- ������������ ������-����������� ��� ��������
-- � ����������� �� ������� ���������� ����� ������ ������������� �������
-- ������ ������ ������������� �� ��������� ������ ���������:
--"��������������_�����������������������"
	-- ������ � �������� �� ��������� ���������� "��������� ����"
	-- ��� ������� ������� ������� ���� ���������� ������� � ������������ � ������� (�.�. 3 �������)
	-- ���������1 - � ���� ���� ������� "��������������" ������
	-- ���������2 - � ���� ��� ������� "��������������" ������
	-- ���������3 - � ��� ����� ��� � ����� ������� "��������������" ������

DECLARE @������������������ TABLE (
		�������� int,
		����������������� varchar(150),
		����������� varchar(20),
		������1_����1 int, 
		������2_����1 int, 
		������3_����1 int, 
		������1_����������1 money, 
		������2_����������1 money, 
		������3_����������1 money, 
		������1_���������� money,
		������2_���������� money,
		������3_���������� money, 
		������1_���������1 money, 
		������2_���������1 money, 
		������3_���������1 money, 
		���������1 int,
		���������2 int,
		���������3 int,
		������3_���������������1 money,
		����_���������������1 money,
		����_����������1 money
		
	)
	DECLARE @�������������� datetime = dateadd(dd, -1, getdate())
	DECLARE @���� varchar(8) = convert(varchar, @��������������, 112)
	INSERT @������������������ EXEC ��������������_����������������������� @����
	
	DECLARE 
		@�������� int,
		@����������������� varchar(150),
		@����������� varchar(20),
		@������3_����1 int, 
		@������3_����������1 money, 
		@������1_���������� money,
		@������2_���������� money,
		@������3_���������� money, 
		@���������1 int,
		@���������2 int,
		@���������3 int,
		@������3_���������������1 money,
		@����_���������������1 money,
		@����_����������1 money,
		@����_���������������1_���������� varchar(150),
		@����_����������1_���������� varchar(150),
		@���������� varchar(250),
		@����������� varchar(max),
		@����� varchar(50)

	DECLARE cur CURSOR local FOR
		SELECT 
			��������,
			�����������������,
			�����������,
			������3_����1,
			������3_����������1,
			������1_����������,
			������2_����������,
			������3_����������,
			���������1,
			���������2,
			���������3,
			������3_���������������1,
			����_���������������1,
			����_����������1,
			CASE
				WHEN ������3_���������������1 <= ����_���������������1 THEN '(������� ���������)'
				ELSE '(������� �� ���������, ���� ���� 20%, �� �������  ' + cast(cast(���������3 * (����_���������������1 / 100.0) - ������3_����1 as int) as varchar)+ ' ����� � �����������)'
			END as ����_���������������1_����������,
			CASE
				WHEN ������3_���������� >= ����_����������1 THEN '(������� ���������)' 
				ELSE '(������� �� ���������, ���������� ������ ��������� �������� ���-�� ����������� ��� ������ � ����� ������� �����, ���� - '+ cast(����_����������1 as varchar)+')'
			END as ����_����������1_����������
		FROM
			@������������������

	OPEN cur
	FETCH NEXT FROM cur 
		INTO @��������, @�����������������,	@�����������, @������3_����1, @������3_����������1, @������1_����������, @������2_����������, @������3_����������, @���������1, @���������2, @���������3, @������3_���������������1, @����_���������������1, @����_����������1, @����_���������������1_����������, @����_����������1_����������

	WHILE @@fetch_status = 0 
	BEGIN
		SET @���������� = '���������� ����� �������� �� ��������� ��: ' + convert(varchar, @��������������, 104)
		SET @����������� = '' 
		SET @����������� = @����������� + '����� � ������ ������ ��: ' + convert(varchar, @��������������, 104) + char(13)
		SET @����������� = @����������� +'	- ����� � ����� SKU: ' + cast(@������3_����1 as varchar) + char(13)
		SET @����������� = @����������� +'	- ����� �����: ' + cast(@���������3 as varchar) + char(13) + char(13)

		SET @����������� = @����������� + '���������� �����' + char(13)
		SET @����������� = @����������� + '  - ���� � ����� SKU: ���� ����� �� ������ ����������: ' + cast(@������3_���������������1 as varchar)+' % ' + + @����_���������������1_���������� + char(13)
		SET @����������� = @����������� + '  - ������� ���: ' + cast(@������3_���������� as varchar) + ' ���. ' + @����_����������1_���������� + char(13) + char(13) 
		 		
		Set @����� = @�����������+'@�����.ru'	
		exec rs_SendMessage null, 'mail', null, @�����, @����������, @�����������, NULL, NULL, null, NULL, NULL, NULL, NULL
				
		FETCH NEXT FROM cur 
			INTO @��������, @�����������������,	@�����������, @������3_����1, @������3_����������1, @������1_����������, @������2_����������, @������3_����������, @���������1, @���������2, @���������3, @������3_���������������1, @����_���������������1, @����_����������1, @����_���������������1_����������, @����_����������1_����������
	END
	CLOSE cur
	DEALLOCATE cur
