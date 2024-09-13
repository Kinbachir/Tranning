CREATE PROCEDURE AddProduct
    @ProductName NVARCHAR(100),
    @UnitPrice DECIMAL(18, 2),
    @QuantityInStock INT
AS
BEGIN
    INSERT INTO Product (ProductName, UnitPrice, QuantityInStock)
    VALUES (@ProductName, @UnitPrice, @QuantityInStock);
    
    SELECT SCOPE_IDENTITY() AS ProductID; -- Return the newly inserted ProductID
END;
