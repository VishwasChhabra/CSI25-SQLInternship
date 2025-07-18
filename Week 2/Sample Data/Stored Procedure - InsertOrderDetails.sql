CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT,
    @Discount FLOAT = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Stock INT, @ReorderLevel INT, @ActualUnitPrice MONEY;

    SELECT @Stock = UnitsInStock, @ReorderLevel = ReorderLevel, @ActualUnitPrice = UnitPrice
    FROM Products
    WHERE ProductID = @ProductID;

    IF @UnitPrice IS NULL
        SET @UnitPrice = @ActualUnitPrice;

    IF @Stock IS NULL
    BEGIN
        PRINT 'Product not found.';
        RETURN;
    END

    IF @Stock < @Quantity
    BEGIN
        PRINT 'Not enough stock to place the order.';
        RETURN;
    END

    INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
    VALUES (@OrderID, @ProductID, @UnitPrice, @Quantity, @Discount);

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to place the order. Please try again.';
        RETURN;
    END

    UPDATE Products
    SET UnitsInStock = UnitsInStock - @Quantity
    WHERE ProductID = @ProductID;

    SELECT @Stock = UnitsInStock FROM Products WHERE ProductID = @ProductID;
    IF @Stock < @ReorderLevel
    BEGIN
        PRINT 'Warning: Stock is below the reorder level.';
    END
END;

EXEC InsertOrderDetails @OrderID = 102, @ProductID = 4, @UnitPrice = NULL, @Quantity = 3, @Discount = NULL;

EXEC InsertOrderDetails @OrderID = 101, @ProductID = 2, @Quantity = 1;