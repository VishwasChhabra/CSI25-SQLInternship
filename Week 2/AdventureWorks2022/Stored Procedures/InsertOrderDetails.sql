CREATE PROCEDURE sp_InsertOrderItem
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT,
    @Discount FLOAT = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Stock INT;
    DECLARE @ReorderLevel INT;
    DECLARE @ActualUnitPrice MONEY;

    -- Fetch stock, reorder level, and actual unit price
    SELECT 
        @Stock = UnitsInStock, 
        @ReorderLevel = ReorderLevel,
        @ActualUnitPrice = UnitPrice
    FROM Products
    WHERE ProductID = @ProductID;

    -- Set default unit price if not provided
    SET @UnitPrice = ISNULL(@UnitPrice, @ActualUnitPrice);

    -- Check stock availability
    IF @Quantity > @Stock
    BEGIN
        PRINT 'Insufficient stock. Order aborted.';
        RETURN;
    END

    -- Insert the order detail
    INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
    VALUES (@OrderID, @ProductID, @UnitPrice, @Quantity, @Discount);

    -- Check if insert was successful
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to place the order. Please try again.';
        RETURN;
    END

    -- Update product stock
    UPDATE Products
    SET UnitsInStock = UnitsInStock - @Quantity
    WHERE ProductID = @ProductID;

    -- Warn if stock is below reorder level
    IF EXISTS (
        SELECT 1 FROM Products
        WHERE ProductID = @ProductID AND UnitsInStock < ReorderLevel
    )
    BEGIN
        PRINT 'Warning: Stock below reorder level!';
    END
END
