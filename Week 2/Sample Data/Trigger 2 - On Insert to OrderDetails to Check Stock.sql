CREATE TRIGGER trg_CheckStockBeforeInsert
ON OrderDetails
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProductID INT, @Quantity INT, @OrderID INT;

    SELECT 
        @ProductID = ProductID, 
        @Quantity = Quantity,
        @OrderID = OrderID
    FROM INSERTED;

    DECLARE @CurrentStock INT;
    SELECT @CurrentStock = UnitsInStock FROM Products WHERE ProductID = @ProductID;

    IF @CurrentStock IS NULL
    BEGIN
        PRINT 'Invalid Product ID.';
        RETURN;
    END

    IF @CurrentStock < @Quantity
    BEGIN
        PRINT 'Order could not be placed. Insufficient stock.';
        RETURN;
    END

    INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
    SELECT OrderID, ProductID, UnitPrice, Quantity, Discount FROM INSERTED;

    UPDATE Products
    SET UnitsInStock = UnitsInStock - @Quantity
    WHERE ProductID = @ProductID;

    PRINT 'Order placed and stock updated.';
END;

INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (101, 3, 1500, 1, 0);

INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (101, 3, 1500, 999, 0);
