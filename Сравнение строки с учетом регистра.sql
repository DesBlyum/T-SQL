-- MS SQL
IF ASCII('�������') = ASCII('�������')
BEGIN
	SELECT '���� � ����'
END
ELSE
BEGIN
	SELECT '��������'
END

IF UNICODE('�������') = UNICODE('�������')
BEGIN
	SELECT '���� � ����'
END
ELSE
BEGIN
	SELECT '��������'
END


-- Sybase
IF dbo.str_value_ascii('�������') = dbo.str_value_ascii('�������')
BEGIN
	SELECT '���� � ����'
END
ELSE
BEGIN
	SELECT '��������'
END

IF CONVERT(unichar(8000),'�������') = CONVERT(unichar(8000),'�������')
BEGIN
	SELECT '���� � ����'
END
ELSE
BEGIN
	SELECT '��������'
END