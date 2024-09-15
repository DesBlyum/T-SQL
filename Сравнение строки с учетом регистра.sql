-- MS SQL
IF ASCII('саратов') = ASCII('САРАТОВ')
BEGIN
	SELECT 'Одно и тоже'
END
ELSE
BEGIN
	SELECT 'Различны'
END

IF UNICODE('саратов') = UNICODE('САРАТОВ')
BEGIN
	SELECT 'Одно и тоже'
END
ELSE
BEGIN
	SELECT 'Различны'
END


-- Sybase
IF dbo.str_value_ascii('саратов') = dbo.str_value_ascii('САРАТОВ')
BEGIN
	SELECT 'Одно и тоже'
END
ELSE
BEGIN
	SELECT 'Различны'
END

IF CONVERT(unichar(8000),'саратов') = CONVERT(unichar(8000),'САРАТОВ')
BEGIN
	SELECT 'Одно и тоже'
END
ELSE
BEGIN
	SELECT 'Различны'
END
