CREATE PROCEDURE GetSupplierByID
    @SupplierID INT
AS
BEGIN
    SELECT SupplierID, SupplierName, ContactEmail, Phone
    FROM Supplier
    WHERE SupplierID = @SupplierID;

    IF @@ROWCOUNT = 0
        RAISERROR('Supplier not found.', 16, 1);
END;
