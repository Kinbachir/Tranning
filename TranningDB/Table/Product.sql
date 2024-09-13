CREATE TABLE Product (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    SupplierID INT,
    UnitPrice DECIMAL(18,2) NOT NULL,
    QuantityInStock INT NOT NULL DEFAULT 0,
    ReorderLevel INT NOT NULL DEFAULT 10,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);