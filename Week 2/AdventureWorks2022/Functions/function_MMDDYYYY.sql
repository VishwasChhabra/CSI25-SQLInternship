CREATE FUNCTION dbo.fn_GetDate_MMDDYYYY (@DateInput DATETIME)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN 
        RIGHT('0' + CONVERT(VARCHAR(2), MONTH(@DateInput)), 2) + '/' +
        RIGHT('0' + CONVERT(VARCHAR(2), DAY(@DateInput)), 2) + '/' +
        CONVERT(VARCHAR(4), YEAR(@DateInput))
END
