CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT = NULL,
    @Discount FLOAT = NULL
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

    DECLARE @OldQuantity INT;
    SELECT @OldQuantity = Quantity 
    FROM OrderDetails 
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    DECLARE @QuantityDiff INT = 0;
    IF @Quantity IS NOT NULL
        SET @QuantityDiff = @Quantity - @OldQuantity;

    IF @QuantityDiff > 0
    BEGIN
        DECLARE @Stock INT;
        SELECT @Stock = UnitsInStock FROM Products WHERE ProductID = @ProductID;

        IF @Stock < @QuantityDiff
        BEGIN
            PRINT 'Not enough stock to increase the quantity.';
            RETURN;
        END

        UPDATE Products 
        SET UnitsInStock = UnitsInStock - @QuantityDiff 
        WHERE ProductID = @ProductID;
    END
    ELSE IF @QuantityDiff < 0
    BEGIN
        UPDATE Products 
        SET UnitsInStock = UnitsInStock + ABS(@QuantityDiff) 
        WHERE ProductID = @ProductID;
    END

    UPDATE OrderDetails
    SET 
        UnitPrice = ISNULL(@UnitPrice, UnitPrice),
        Quantity = ISNULL(@Quantity, Quantity),
        Discount = ISNULL(@Discount, Discount)
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    PRINT 'Order details updated successfully.';
END;


-- Example Usage

EXEC UpdateOrderDetails 
    @OrderID = 101, 
    @ProductID = 4, 
    @UnitPrice = 980, 
    @Discount = 0.15;
