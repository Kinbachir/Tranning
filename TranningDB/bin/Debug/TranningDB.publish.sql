/*
Script de déploiement pour tranning

Ce code a été généré par un outil.
La modification de ce fichier peut provoquer un comportement incorrect et sera perdue si
le code est régénéré.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "tranning"
:setvar DefaultFilePrefix "tranning"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Détectez le mode SQLCMD et désactivez l'exécution du script si le mode SQLCMD n'est pas pris en charge.
Pour réactiver le script une fois le mode SQLCMD activé, exécutez ce qui suit :
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Le mode SQLCMD doit être activé de manière à pouvoir exécuter ce script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET PAGE_VERIFY NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
PRINT N'Création de Table [dbo].[Product]...';


GO
CREATE TABLE [dbo].[Product] (
    [ProductID]       INT             IDENTITY (1, 1) NOT NULL,
    [ProductName]     NVARCHAR (100)  NOT NULL,
    [SupplierID]      INT             NULL,
    [UnitPrice]       DECIMAL (18, 2) NOT NULL,
    [QuantityInStock] INT             NOT NULL,
    [ReorderLevel]    INT             NOT NULL,
    PRIMARY KEY CLUSTERED ([ProductID] ASC)
);


GO
PRINT N'Création de Table [dbo].[StockTransaction]...';


GO
CREATE TABLE [dbo].[StockTransaction] (
    [TransactionID]   INT           IDENTITY (1, 1) NOT NULL,
    [ProductID]       INT           NOT NULL,
    [TransactionDate] DATETIME      NOT NULL,
    [TransactionType] NVARCHAR (10) NOT NULL,
    [Quantity]        INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([TransactionID] ASC)
);


GO
PRINT N'Création de Table [dbo].[Supplier]...';


GO
CREATE TABLE [dbo].[Supplier] (
    [SupplierID]   INT            IDENTITY (1, 1) NOT NULL,
    [SupplierName] NVARCHAR (100) NOT NULL,
    [ContactEmail] NVARCHAR (100) NULL,
    [Phone]        NVARCHAR (20)  NULL,
    PRIMARY KEY CLUSTERED ([SupplierID] ASC)
);


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Product]...';


GO
ALTER TABLE [dbo].[Product]
    ADD DEFAULT 0 FOR [QuantityInStock];


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Product]...';


GO
ALTER TABLE [dbo].[Product]
    ADD DEFAULT 10 FOR [ReorderLevel];


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[StockTransaction]...';


GO
ALTER TABLE [dbo].[StockTransaction]
    ADD DEFAULT GETDATE() FOR [TransactionDate];


GO
PRINT N'Création de Clé étrangère contrainte sans nom sur [dbo].[Product]...';


GO
ALTER TABLE [dbo].[Product] WITH NOCHECK
    ADD FOREIGN KEY ([SupplierID]) REFERENCES [dbo].[Supplier] ([SupplierID]);


GO
PRINT N'Création de Clé étrangère contrainte sans nom sur [dbo].[StockTransaction]...';


GO
ALTER TABLE [dbo].[StockTransaction] WITH NOCHECK
    ADD FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Product] ([ProductID]);


GO
PRINT N'Création de Contrainte de validation contrainte sans nom sur [dbo].[StockTransaction]...';


GO
ALTER TABLE [dbo].[StockTransaction] WITH NOCHECK
    ADD CHECK (TransactionType IN ('IN', 'OUT'));


GO
PRINT N'Création de Procédure [dbo].[AddProduct]...';


GO
CREATE PROCEDURE AddProduct
    @ProductName NVARCHAR(100),
    @UnitPrice DECIMAL(18, 2),
    @QuantityInStock INT
AS
BEGIN
    INSERT INTO Product (ProductName, UnitPrice, QuantityInStock)
    VALUES (@ProductName, @UnitPrice, @QuantityInStock);
    
    SELECT SCOPE_IDENTITY() AS ProductID; -- Return the newly inserted ProductID
END;
GO
PRINT N'Création de Procédure [dbo].[AddStockTransaction]...';


GO
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
GO
PRINT N'Création de Procédure [dbo].[AddSupplier]...';


GO
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
GO
PRINT N'Création de Procédure [dbo].[DeleteProduct]...';


GO
CREATE PROCEDURE DeleteProduct
    @ProductID INT
AS
BEGIN
    DELETE FROM Product
    WHERE ProductID = @ProductID;
END;
GO
PRINT N'Création de Procédure [dbo].[DeleteSupplier]...';


GO
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
GO
PRINT N'Création de Procédure [dbo].[GetAllProducts]...';


GO
CREATE PROCEDURE [dbo].[GetAllProducts]
	@param1 int = 0,
	@param2 int
AS
	SELECT @param1, @param2
RETURN 0
GO
PRINT N'Création de Procédure [dbo].[GetAllStockTransactions]...';


GO
CREATE PROCEDURE GetAllStockTransactions
AS
BEGIN
    SELECT TransactionID, ProductID, Quantity, TransactionDate, TransactionType
    FROM StockTransaction;
END;
GO
PRINT N'Création de Procédure [dbo].[GetAllSuppliers]...';


GO
CREATE PROCEDURE GetAllSuppliers
AS
BEGIN
    SELECT SupplierID, SupplierName, ContactEmail, Phone
    FROM Supplier;
END;
GO
PRINT N'Création de Procédure [dbo].[GetProductByID]...';


GO
CREATE PROCEDURE GetProductByID
    @ProductID INT
AS
BEGIN
    SELECT ProductID, ProductName, UnitPrice, QuantityInStock
    FROM Product
    WHERE ProductID = @ProductID;
END;
GO
PRINT N'Création de Procédure [dbo].[GetStockTransactionByID]...';


GO
CREATE PROCEDURE GetStockTransactionByID
    @TransactionID INT
AS
BEGIN
    SELECT TransactionID, ProductID, Quantity, TransactionDate, TransactionType
    FROM StockTransaction
    WHERE TransactionID = @TransactionID;
END;
GO
PRINT N'Création de Procédure [dbo].[GetSupplierByID]...';


GO
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
GO
PRINT N'Création de Procédure [dbo].[UpdateProduct]...';


GO
CREATE PROCEDURE UpdateProduct
    @ProductID INT,
    @ProductName NVARCHAR(100),
    @UnitPrice DECIMAL(18, 2),
    @QuantityInStock INT
AS
BEGIN
    UPDATE Product
    SET ProductName = @ProductName,
        UnitPrice = @UnitPrice,
        QuantityInStock = @QuantityInStock
    WHERE ProductID = @ProductID;
END;
GO
PRINT N'Création de Procédure [dbo].[UpdateSupplier]...';


GO
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
GO
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
CREATE TABLE [#__checkStatus] (
    id           INT            IDENTITY (1, 1) PRIMARY KEY CLUSTERED,
    [Schema]     NVARCHAR (256),
    [Table]      NVARCHAR (256),
    [Constraint] NVARCHAR (256)
);

SET NOCOUNT ON;

DECLARE tableconstraintnames CURSOR LOCAL FORWARD_ONLY
    FOR SELECT SCHEMA_NAME([schema_id]),
               OBJECT_NAME([parent_object_id]),
               [name],
               0
        FROM   [sys].[objects]
        WHERE  [parent_object_id] IN (OBJECT_ID(N'dbo.Product'), OBJECT_ID(N'dbo.StockTransaction'))
               AND [type] IN (N'F', N'C')
                   AND [object_id] IN (SELECT [object_id]
                                       FROM   [sys].[check_constraints]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0
                                       UNION
                                       SELECT [object_id]
                                       FROM   [sys].[foreign_keys]
                                       WHERE  [is_not_trusted] <> 0
                                              AND [is_disabled] = 0);

DECLARE @schemaname AS NVARCHAR (256);

DECLARE @tablename AS NVARCHAR (256);

DECLARE @checkname AS NVARCHAR (256);

DECLARE @is_not_trusted AS INT;

DECLARE @statement AS NVARCHAR (1024);

BEGIN TRY
    OPEN tableconstraintnames;
    FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
    WHILE @@fetch_status = 0
        BEGIN
            PRINT N'Vérification de la contrainte : ' + @checkname + N' [' + @schemaname + N'].[' + @tablename + N']';
            SET @statement = N'ALTER TABLE [' + @schemaname + N'].[' + @tablename + N'] WITH ' + CASE @is_not_trusted WHEN 0 THEN N'CHECK' ELSE N'NOCHECK' END + N' CHECK CONSTRAINT [' + @checkname + N']';
            BEGIN TRY
                EXECUTE [sp_executesql] @statement;
            END TRY
            BEGIN CATCH
                INSERT  [#__checkStatus] ([Schema], [Table], [Constraint])
                VALUES                  (@schemaname, @tablename, @checkname);
            END CATCH
            FETCH tableconstraintnames INTO @schemaname, @tablename, @checkname, @is_not_trusted;
        END
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') >= 0
    CLOSE tableconstraintnames;

IF CURSOR_STATUS(N'LOCAL', N'tableconstraintnames') = -1
    DEALLOCATE tableconstraintnames;

SELECT N'Échec de vérification de la contrainte :' + [Schema] + N'.' + [Table] + N',' + [Constraint]
FROM   [#__checkStatus];

IF @@ROWCOUNT > 0
    BEGIN
        DROP TABLE [#__checkStatus];
        RAISERROR (N'Une erreur s''est produite lors de la vérification des contraintes', 16, 127);
    END

SET NOCOUNT OFF;

DROP TABLE [#__checkStatus];


GO
PRINT N'Mise à jour terminée.';


GO
