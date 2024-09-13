CREATE PROCEDURE UpdateSupplier
    @SupplierID INT,
    @SupplierName NVARCHAR(100),
    @ContactEmail NVARCHAR(100),
    @Phone NVARCHAR(20)
AS
BEGIN
    UPDATE Supplier
    SET SupplierName = @SupplierName,
        ContactEmail = @ContactEmail,
        Phone = @Phone
    WHERE SupplierID = @SupplierID;
END;
