/************************************************************************
* Date			Programmer		Notes
* --------------------------------------------------------------------
* 10/24/2018	Brian Jenks		First instantiation
*  
*************************************************************************/
USE MediaLibrary
GO
/***************** 3. ************************/
/* Create a procedure to create artist with input data */
--Start with checking whether it exists, and drop it if it does
IF OBJECT_ID('sp_InsertArtist') IS NOT NULL
   DROP PROC sp_InsertArtist
GO
--Make the procedure
CREATE PROC sp_InsertArtist
	@ArtistTypeID INT,
	@GroupName VARCHAR(75) = NULL,
	@FirstName VARCHAR(30) = NULL,
	@LastName VARCHAR(40) = NULL
AS
BEGIN TRY
BEGIN TRAN;
	--If they're a band, only GroupName expected, if not, first and last name expected
	IF ((@ArtistTypeID = 2 AND @GroupName IS NOT NULL AND @FirstName IS NULL AND @LastName IS NULL)
			 OR (@ArtistTypeID != 2 AND @GroupName IS NULL AND @FirstName IS NOT NULL
			 AND @LastName IS NOT NULL)) --Data validation, making sure that artists are properly input
/* Note- Regularly, I would separate procedures for creation of a group from individuals */
		BEGIN
			INSERT Artist
			VALUES	(@GroupName, @FirstName, @LastName, @ArtistTypeID)
		END
	ELSE --If they didn't properly put a group name or first/last name
		THROW 50001, 'If Artist ID is 2, group name expected, otherwise first and last name expected.', 1;
COMMIT TRAN;
END TRY
--If they input incorrect information, display why
BEGIN CATCH
	ROLLBACK TRAN;
	PRINT 'An error occurred.'
	PRINT 'Message: ' + CONVERT(varchar, ERROR_MESSAGE());
END CATCH
GO --End creation of sp_InsertArtist


/* Create a procedure to update an artist's name */
IF OBJECT_ID('sp_UpdateArtistName') IS NOT NULL
   DROP PROC sp_UpdateArtistName
GO
CREATE PROC sp_UpdateArtistName
	@ArtistID INT,
	@GroupName VARCHAR(75) = NULL,
	@FirstName VARCHAR(30) = NULL,
	@LastName VARCHAR(40) = NULL
AS
BEGIN TRY
BEGIN TRAN;
	--Check the ID to see if we have it
	IF EXISTS (SELECT * FROM Artist WHERE ArtistID = @ArtistID)
	BEGIN
		--Check whether they have any data at all
		IF (@GroupName IS NULL AND @FirstName IS NULL AND @LastName IS NULL)
			THROW 50013, 'No data to update', 1;
		--If they have a group name...
		IF (@GroupName IS NOT NULL)
		BEGIN
			--If they're a band, update the group name
			IF ((SELECT ArtistTypeID FROM Artist WHERE ArtistID = @ArtistID) = 2)
				UPDATE Artist
				SET GroupName = @GroupName
				WHERE ArtistID = @ArtistID
			ELSE --Did they not choose the right ID?
				THROW 50002, 'Expected artist type to be a band.', 1;
		END
		--If they've got either a first or last name...
		ELSE IF (@FirstName IS NOT NULL OR @LastName IS NOT NULL)
		BEGIN
			--If they're not a band, put their information in
			IF ((SELECT ArtistTypeID FROM Artist WHERE ArtistID = @ArtistID) != 2)
				IF (@FirstName IS NOT NULL)
					UPDATE Artist
					SET FirstName = @FirstName
					WHERE ArtistID = @ArtistID
				IF (@LastName IS NOT NULL)
					UPDATE Artist
					SET LastName = @LastName
					WHERE ArtistID = @ArtistID
			ELSE --Did they not choose the right ID?
				THROW 50003, 'Expected artist type to not be a band.', 1;
		END
	END --End if ArtistID exists
	ELSE
		THROW 50004, 'ArtistID not found.', 1;
COMMIT TRAN;
END TRY

BEGIN CATCH
	ROLLBACK TRAN;
	PRINT 'An error occurred.'
	PRINT 'Message: ' + CONVERT(varchar, ERROR_MESSAGE());
END CATCH
GO --End creation of sp_UpdateArtistName

/* Create a procedure to drop an artist from our table */
IF OBJECT_ID('sp_DeleteArtist') IS NOT NULL
   DROP PROC sp_DeleteArtist
GO
CREATE PROC sp_DeleteArtist
	@ArtistID INT
AS
BEGIN TRY
BEGIN TRAN;
	--If the ArtistID exists, delete it
	IF EXISTS (SELECT * FROM Artist WHERE ArtistID = @ArtistID)
		DELETE Artist
		WHERE ArtistID = @ArtistID
	ELSE
		THROW 50004, 'ArtistID not found.', 1;
COMMIT TRAN;
END TRY

BEGIN CATCH
	ROLLBACK TRAN;
	PRINT 'An error occurred.'
	PRINT 'Message: ' + CONVERT(varchar, ERROR_MESSAGE());
END CATCH
GO --End creation of sp_DeleteArtist

/***************** 4. ************************/

/* Create a procedure to make a borrower */
IF OBJECT_ID('sp_InsertBorrower') IS NOT NULL
   DROP PROC sp_InsertBorrower
GO
CREATE PROC sp_InsertBorrower
	@FirstName VARCHAR(30),
	@LastName VARCHAR(40),
	@PhoneNumber CHAR(10)
AS
BEGIN TRY
BEGIN TRAN;
	--Make sure all our data has values
	IF (@FirstName IS NOT NULL AND @LastName IS NOT NULL AND @PhoneNumber IS NOT NULL)
		IF (ISNUMERIC(@PhoneNumber) = 1) --Check whether our phone number is just digits
			INSERT Borrower
			VALUES	(@FirstName, @LastName, @PhoneNumber)
		ELSE --When the phone number is not digits
			THROW 50008, 'Phone number must be digits', 1;
	ELSE --When not all fields are populated
		THROW 50005, 'First, Last, and phone number must all be populated.', 1;
COMMIT TRAN;
END TRY

BEGIN CATCH
	ROLLBACK TRAN;
	PRINT 'An error occurred.'
	PRINT 'Message: ' + CONVERT(varchar, ERROR_MESSAGE());
END CATCH
GO --End create sp_InsertBorrower


/* Create a procedure to update a borrower */
IF OBJECT_ID('sp_UpdateBorrowerName') IS NOT NULL
   DROP PROC sp_UpdateBorrowerName
GO
CREATE PROC sp_UpdateBorrowerName
	@BorrowerID INT,
	@FirstName VARCHAR(30) = NULL,
	@LastName VARCHAR(40) = NULL
AS
BEGIN TRY
BEGIN TRAN;
	--Make sure the borrower exists
	IF EXISTS (SELECT * FROM Borrower WHERE BorrowerID = @BorrowerID)
	BEGIN
		--If we don't have any data
		IF (@FirstName IS NULL AND @LastName IS NULL)
			THROW 50006, 'One name must be populated.', 1;
		--If we have a first name
		IF (@FirstName IS NOT NULL)
			UPDATE Borrower
			SET FirstName = @FirstName
			WHERE BorrowerID = @BorrowerID
		--If we have a last name
		IF(@LastName IS NOT NULL)
			UPDATE Borrower
			SET LastName = @LastName
			WHERE BorrowerID = @BorrowerID
	END
	ELSE
		THROW 50007, 'BorrowerID not found.', 1;
COMMIT TRAN;
END TRY

BEGIN CATCH
	ROLLBACK TRAN;
	PRINT 'An error occurred.'
	PRINT 'Message: ' + CONVERT(varchar, ERROR_MESSAGE());
END CATCH
GO --End update Borrower


/* Create a procedure to drop a borrower */
IF OBJECT_ID('sp_DeleteBorrower') IS NOT NULL
   DROP PROC sp_DeleteBorrower
GO
CREATE PROC sp_DeleteBorrower
	@BorrowerID INT
AS
BEGIN TRY
BEGIN TRAN;
	--Make sure the borrower exists
	IF EXISTS (SELECT * FROM Borrower WHERE BorrowerID = @BorrowerID)
	BEGIN
		DELETE Borrower
		WHERE BorrowerID = @BorrowerID
	END
	ELSE --If the ID isn't there...
		THROW 50007, 'BorrowerID not found.', 1;
COMMIT TRAN;
END TRY

BEGIN CATCH
	ROLLBACK TRAN;
	PRINT 'An error occurred.'
	PRINT 'Message: ' + CONVERT(varchar, ERROR_MESSAGE());
END CATCH
GO --End delete Borrower

/***************** 5. ************************/

/* Create an item in our inventory */
IF OBJECT_ID('sp_InsertInventory') IS NOT NULL
   DROP PROC sp_InsertInventory
GO
CREATE PROC sp_InsertInventory
	@ItemName VARCHAR(75),
	@ReleaseDate DATE,
	@TypeID INT,
	@GenreID INT,
	@StatusCode INT = 1 --We'll default to an available status
AS
BEGIN TRY
BEGIN TRAN;
	--See if any fields are not filled
	IF (@ItemName IS NOT NULL AND @ReleaseDate IS NOT NULL AND @TypeID IS NOT NULL
		AND @GenreID IS NOT NULL)
		--Ensure TypeID exists
		IF EXISTS (SELECT * FROM MediaType WHERE TypeID = @TypeID)
			--Ensure GenreID exists
			IF EXISTS (SELECT * FROM MediaGenre WHERE GenreID = @GenreID)
				--Ensure StatusCode exists
				IF EXISTS (SELECT * FROM MediaStatus WHERE StatusCode = @StatusCode)
					INSERT Inventory
					VALUES (@ItemName, @ReleaseDate, @TypeID, @GenreID, @StatusCode)
				ELSE --When StatusCode doesn't exist
					THROW 50009, 'Status code not found', 1;
			ELSE --When GenreID doesn't exist
				THROW 50010, 'GenreID not found', 1;
		ELSE --When TypeID doesn't exist
			THROW 50011, 'TypeID not found', 1;
	ELSE --When not all fields are filled
		THROW 50012, 'Unpopulated fields exist', 1;
COMMIT TRAN;
END TRY

BEGIN CATCH
	ROLLBACK TRAN;
	PRINT 'An error occurred.'
	PRINT 'Message: ' + CONVERT(varchar, ERROR_MESSAGE());
END CATCH
GO --End insert inventory


/* Update an item in inventory */
IF OBJECT_ID('sp_UpdateInventory') IS NOT NULL
   DROP PROC sp_UpdateInventory
GO
CREATE PROC sp_UpdateInventory
	@ItemID INT,
	@ItemName VARCHAR(75) = NULL,
	@ReleaseDate DATE = NULL,
	@TypeID INT = NULL,
	@GenreID INT = NULL,
	@StatusCode INT = NULL
AS
BEGIN TRY
BEGIN TRAN;
	--Check for whether the item we want to update exists
	IF EXISTS (SELECT * FROM Inventory WHERE ItemID = @ItemID)
	BEGIN
		--Check whether we have any data to update
		IF (@ItemName IS NULL AND @ReleaseDate IS NULL AND @TypeID IS NULL
		AND @GenreID IS NULL AND @StatusCode IS NULL)
			THROW 50013, 'No data to update', 1; --If no data, throw
		--Here, we check each item individually to see if they need to be updated
		IF (@ItemName IS NOT NULL)
			UPDATE Inventory
			SET ItemName = @ItemName
			WHERE ItemID = @ItemID
		IF (@ReleaseDate IS NOT NULL)
			UPDATE Inventory
			SET ReleaseDate = @ReleaseDate
			WHERE ItemID = @ItemID
		IF (@TypeID IS NOT NULL)
			UPDATE Inventory
			SET TypeID = @TypeID
			WHERE ItemID = @ItemID
		IF (@GenreID IS NOT NULL)
			UPDATE Inventory
			SET GenreID = @GenreID
			WHERE ItemID = @ItemID
		IF (@StatusCode IS NOT NULL)
			UPDATE Inventory
			SET StatusCode = @StatusCode
			WHERE ItemID = @ItemID

	END
	ELSE --If the item does not exist
		THROW 50014, 'ItemID not found', 1;
COMMIT TRAN;
END TRY

BEGIN CATCH
	ROLLBACK TRAN;
	PRINT 'An error occurred.'
	PRINT 'Message: ' + CONVERT(varchar, ERROR_MESSAGE());
END CATCH
GO --End update inventory


/* Delete an item from inventory */
IF OBJECT_ID('sp_DeleteInventory') IS NOT NULL
   DROP PROC sp_DeleteInventory
GO
CREATE PROC sp_DeleteInventory
	@ItemID INT
AS
BEGIN TRY
BEGIN TRAN;
	--Check if the item exists
	IF EXISTS (SELECT * FROM Inventory WHERE ItemID = @ItemID)
		DELETE Inventory
		WHERE ItemID = @ItemID
	ELSE --When it doesn't exist
		THROW 50014, 'ItemID not found', 1;
COMMIT TRAN;
END TRY

BEGIN CATCH
	ROLLBACK TRAN;
	PRINT 'An error occurred.'
	PRINT 'Message: ' + CONVERT(varchar, ERROR_MESSAGE());
END CATCH
GO --End delete inventory


/***************** 8. ************************/
--Execute our inserts
EXEC sp_InsertArtist @FirstName = 'Fred', @LastName = 'Flintstone', @ArtistTypeID = 3;
GO
EXEC sp_InsertBorrower 'Sweetie', 'Pie','5555555555';
GO
EXEC sp_InsertInventory 'TestItem', '02/17/2017', 4, 3;
GO

/* --Check our items
SELECT * FROM Artist WHERE FirstName = 'Fred'
SELECT * FROM Borrower WHERE FirstName = 'Sweetie'
SELECT * FROM Inventory WHERE ItemName = 'TestItem'
*/

--Execute our updates
EXEC sp_UpdateArtistName 21, @LastName = 'Jones';
GO
EXEC sp_UpdateBorrowerName 22, 'Cutie';
GO
EXEC sp_UpdateInventory 22, @StatusCode = 3; --BREAK OUR TEST ITEM! YEAH!
GO

/* -- Check our new data
SELECT * FROM Artist WHERE FirstName = 'Fred'
SELECT * FROM Borrower WHERE LastName = 'Pie'
SELECT * FROM Inventory WHERE StatusCode = 3
*/

EXEC sp_DeleteArtist 21;
GO
EXEC sp_DeleteBorrower 22;
GO
EXEC sp_DeleteInventory 22;
GO