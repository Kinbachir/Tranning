CREATE PROCEDURE GetStockTransactionByID
    @TransactionID INT
AS
BEGIN
    SELECT TransactionID, ProductID, Quantity, TransactionDate, TransactionType
    FROM StockTransaction
    WHERE TransactionID = @TransactionID;
END;
