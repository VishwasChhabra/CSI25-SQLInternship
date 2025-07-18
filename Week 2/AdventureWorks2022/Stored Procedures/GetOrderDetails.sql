CREATE PROCEDURE sp_GetOrderDetailsById
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the order exists
    IF NOT EXISTS (
        SELECT 1 FROM [Order Details] WHERE OrderID = @OrderID
    )
    BEGIN
        PRINT 'The OrderID ' + CAST(@OrderID AS VARCHAR) + ' does not exist.';
        RETURN 1;
    END

    -- Retrieve and return order details
    SELECT *
    FROM [Order Details]
    WHERE OrderID = @OrderID;
END
