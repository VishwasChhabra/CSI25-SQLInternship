CREATE TABLE TimeDimension (
    DateValue DATE PRIMARY KEY,
    CalendarDay INT,
    CalendarMonth INT,
    CalendarQuarter INT,
    CalendarYear INT,
    DayNameLong VARCHAR(20),
    DayNameShort VARCHAR(3),
    DayNumberOfWeek INT,
    DayNumberOfYear INT,
    WeekNumber INT,
    MonthName VARCHAR(20),
    FiscalYear INT,
    FiscalQuarter INT,
    FiscalWeek INT,
    FiscalPeriod INT
);

DELIMITER $$

DROP PROCEDURE IF EXISTS fill_time_dimension_year $$
CREATE PROCEDURE fill_time_dimension_year(in_date DATE)
BEGIN
    DECLARE y INT;
    DECLARE d_start DATE;
    DECLARE d_end DATE;
    SET y = YEAR(in_date);
    SET d_start = MAKEDATE(y,1);
    SET d_end = DATE_SUB(MAKEDATE(y+1,1), INTERVAL 1 DAY);
    INSERT INTO TimeDimension (
        DateValue, CalendarDay, CalendarMonth, CalendarQuarter, CalendarYear,
        DayNameLong, DayNameShort, DayNumberOfWeek, DayNumberOfYear,
        WeekNumber, MonthName, FiscalYear, FiscalQuarter, FiscalWeek, FiscalPeriod
    )
    WITH RECURSIVE seq AS (
        SELECT d_start AS dt
        UNION ALL
        SELECT dt + INTERVAL 1 DAY FROM seq WHERE dt + INTERVAL 1 DAY <= d_end
    )
    SELECT
        dt,
        DAY(dt),
        MONTH(dt),
        QUARTER(dt),
        YEAR(dt),
        DAYNAME(dt),
        LEFT(DAYNAME(dt),3),
        DAYOFWEEK(dt),
        DAYOFYEAR(dt),
        WEEK(dt,3),
        MONTHNAME(dt),
        YEAR(dt),
        QUARTER(dt),
        WEEK(dt,3),
        MONTH(dt)
    FROM seq;
END $$

DELIMITER ;

CALL fill_time_dimension_year('2020-07-14');

-- Checking the data inserted
SELECT * FROM TimeDimension ORDER BY DateValue LIMIT 20;

-- Verifying total rows
SELECT COUNT(*) AS TotalRows FROM TimeDimension;

-- Sample checking for particular date
SELECT * FROM TimeDimension WHERE DateValue = '2020-07-14';
