CREATE PROCEDURE GetOrderDetails
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = @OrderID)
    BEGIN
        PRINT 'Order ID not found.';
        RETURN;
    END

    SELECT 
        od.OrderID,
        o.OrderDate,
        o.CompanyName,
        p.ProductName,
        od.UnitPrice,
        od.Quantity,
        od.Discount,
        (od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalPrice
    FROM OrderDetails od
    INNER JOIN Products p ON od.ProductID = p.ProductID
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    WHERE od.OrderID = @OrderID;
END;


-- Example Usage
EXEC GetOrderDetails @OrderID = 101;
