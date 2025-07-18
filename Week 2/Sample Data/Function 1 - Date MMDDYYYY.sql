CREATE FUNCTION FormatDate_MMDDYYYY (@InputDate DATETIME)
RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @FormattedDate VARCHAR(10)

    SET @FormattedDate = 
        RIGHT('0' + CAST(MONTH(@InputDate) AS VARCHAR), 2) + '/' +
        RIGHT('0' + CAST(DAY(@InputDate) AS VARCHAR), 2) + '/' +
        CAST(YEAR(@InputDate) AS VARCHAR)

    RETURN @FormattedDate
END;

SELECT dbo.FormatDate_MMDDYYYY('2006-11-21 23:34:05.920') AS FormattedDate;
