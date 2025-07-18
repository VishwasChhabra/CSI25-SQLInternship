CREATE TRIGGER trg_InsteadOfDeleteOrders
ON Orders
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM OrderDetails
    WHERE OrderID IN (SELECT OrderID FROM DELETED);

    DELETE FROM Orders
    WHERE OrderID IN (SELECT OrderID FROM DELETED);

    PRINT 'Order and related order details deleted successfully.';
END;

INSERT INTO Orders (OrderID, OrderDate, CompanyName)
VALUES (999, GETDATE(), 'Test Corp');

INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (999, 1, 55000, 1, 0.1);

DELETE FROM Orders WHERE OrderID = 999;