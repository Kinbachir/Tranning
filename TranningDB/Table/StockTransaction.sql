CREATE TABLE StockTransaction (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
    TransactionType NVARCHAR(10) NOT NULL CHECK (TransactionType IN ('IN', 'OUT')), -- 'IN' for adding stock, 'OUT' for reducing stock
    Quantity INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);