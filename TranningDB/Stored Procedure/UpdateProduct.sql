CREATE PROCEDURE UpdateProduct
    @ProductID INT,
    @ProductName NVARCHAR(100),
    @UnitPrice DECIMAL(18, 2),
    @QuantityInStock INT
AS
BEGIN
    UPDATE Product
    SET ProductName = @ProductName,
        UnitPrice = @UnitPrice,
        QuantityInStock = @QuantityInStock
    WHERE ProductID = @ProductID;
END;
