CREATE PROCEDURE GetAllStockTransactions
AS
BEGIN
    SELECT TransactionID, ProductID, Quantity, TransactionDate, TransactionType
    FROM StockTransaction;
END;
