CREATE PROCEDURE GetAllProducts
AS
BEGIN
    SELECT ProductID, ProductName, UnitPrice, QuantityInStock
    FROM Product;
END;