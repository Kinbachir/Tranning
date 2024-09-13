CREATE PROCEDURE AddStockTransaction
    @ProductID INT,
    @Quantity INT,
    @TransactionType NVARCHAR(10)
AS
BEGIN
    INSERT INTO StockTransaction (ProductID, Quantity, TransactionType)
    VALUES (@ProductID, @Quantity, @TransactionType);
    
    IF @TransactionType = 'IN'
    BEGIN
        UPDATE Product SET QuantityInStock = QuantityInStock + @Quantity WHERE ProductID = @ProductID;
    END
    ELSE IF @TransactionType = 'OUT'
    BEGIN
        UPDATE Product SET QuantityInStock = QuantityInStock - @Quantity WHERE ProductID = @ProductID;
    END
END;
