CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM OrderDetails 
        WHERE OrderID = @OrderID AND ProductID = @ProductID
    )
    BEGIN
        PRINT 'No matching order detail found.';
        RETURN;
    END

    DECLARE @Quantity INT;
    SELECT @Quantity = Quantity 
    FROM OrderDetails 
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    UPDATE Products
    SET UnitsInStock = UnitsInStock + @Quantity
    WHERE ProductID = @ProductID;

    DELETE FROM OrderDetails
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    PRINT 'Order detail deleted and stock restored.';
END;


EXEC DeleteOrderDetails @OrderID = 101, @ProductID = 4;
