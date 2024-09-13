CREATE PROCEDURE GetProductByID
    @ProductID INT
AS
BEGIN
    SELECT ProductID, ProductName, UnitPrice, QuantityInStock
    FROM Product
    WHERE ProductID = @ProductID;
END;
