IF OBJECT_ID('binary_search') IS NOT NULL
BEGIN
	DROP PROCEDURE binary_search
	IF OBJECT_ID('binary_search') IS NOT NULL
		PRINT '<<<FAILED DROPPING PROCEDURE binary_search>>>'
	ELSE
		PRINT '<<<DROPPED PROCEDURE binary_search>>>'
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =============================================
*	���������:	binary_search
*	��������:	�������� ����� �������� �� �� ��������������� ������� (�������� ����������� �� �����������)
*	���������:	@nameTable	- ������������ ������� � ������� ����� ������������ �����
*				@nameColumn	- ������������ ������� ������� � ������� ����� ������������ �����
*				@value		- �������� ��� ������ (�������������)
*	����������:	@position	- ������� � �������/ID
*
*	������ ������:
*
*	DECLARE @nameTable		VARCHAR(500),
*			@nameColumn		INT,
*			@value			INT,
*			@position		INT 
*
*	EXEC binary_search
*			@nameTable		= 'Test',
*			@nameColumn		= 'quantity',
*			@value			= 303,
*			@position		= @position OUT
*
*	SELECT @position
* =============================================*/

CREATE PROCEDURE binary_search
	@nameTable		NVARCHAR(500),
	@nameColumn		NVARCHAR(500),
	@value			INT,
	@position		INT OUT
AS
BEGIN
	DECLARE @low		INT
	DECLARE @high		INT
	DECLARE @mid		INT
	DECLARE @guess		INT

	DECLARE @sqlCommand NVARCHAR(1000)
	DECLARE @ret		INT
	DECLARE @ParmDef	NVARCHAR(1000)

	-- ��������� ����� �������
	SET @sqlCommand = N'SELECT @ret = MAX(ID) FROM '+ QuoteName(@nameTable)
	-- ������������� ����������
	SET @ParmDef	= N'@nameTable NVARCHAR(500), @ret int OUT'

	EXEC sp_executesql @sqlCommand, @ParmDef, @nameTable = @nameTable, @ret = @ret OUT

	SET @low	= 0
	SET @high	= @ret --����� ���-�� ����� � �������

	WHILE @low <= @high
	BEGIN
		SET @mid = ROUND((@low + @high)/2,0) -- ����� �������� �� 2 �����
		
		SET @sqlCommand = N'SELECT @ret = '+ QuoteName(@nameColumn)+' FROM '+ QuoteName(@nameTable)+' WHERE ID = @mid'
		SET @ParmDef	= N'@nameTable NVARCHAR(500), @nameColumn NVARCHAR(500), @mid int, @ret int OUT'

		EXEC sp_executesql @sqlCommand, @ParmDef, @nameTable = @nameTable, @nameColumn = @nameColumn, @mid = @mid, @ret = @ret OUT

		SET @guess = @ret

		-- ��������� �������� ��������� � �������
		if @guess = @value
		begin
			SET @position = @mid
		end

		-- ��������� �������� ������ ��������, �� ��������� ������� ������� ���������
		if ISNULL(@guess,0) > @value
		begin
			SET @high = @mid - 1 
		end
		else -- ����������� ������ ������� ���������
		begin
			SET @low = @mid + 1
		end
	END
	
END
GO
