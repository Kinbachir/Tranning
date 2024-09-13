CREATE PROCEDURE AddSupplier
    @SupplierName NVARCHAR(100),
    @ContactEmail NVARCHAR(100),
    @Phone NVARCHAR(20)
AS
BEGIN
    INSERT INTO Supplier (SupplierName, ContactEmail, Phone)
    VALUES (@SupplierName, @ContactEmail, @Phone);

    -- Return the newly inserted SupplierID
    SELECT SCOPE_IDENTITY() AS SupplierID;
END;
