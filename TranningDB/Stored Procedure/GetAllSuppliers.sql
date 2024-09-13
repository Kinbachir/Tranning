CREATE PROCEDURE GetAllSuppliers
AS
BEGIN
    SELECT SupplierID, SupplierName, ContactEmail, Phone
    FROM Supplier;
END;
