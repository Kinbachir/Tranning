CREATE PROCEDURE DeleteSupplier
    @SupplierID INT
AS
BEGIN
    DELETE FROM Supplier
    WHERE SupplierID = @SupplierID;

    -- Return success or failure
    IF @@ROWCOUNT = 0
        RAISERROR('Supplier not found.', 16, 1);
END;
