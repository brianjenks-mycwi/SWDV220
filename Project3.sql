/************************************************************************
* Date			Programmer		Notes
* --------------------------------------------------------------------
* 10/12/2018	Brian Jenks		Instantiating test data in MediaLibrary DB
*  
*************************************************************************/

USE MediaLibrary
GO

/*
********************* Input all data in a proper order ******************
*/

--Start with MediaStatus, allow three types
INSERT INTO MediaStatus
	(Description)--StatusCode is auto generated
--	 VCHAR(50)
VALUES
	('Available'),
	('CheckedOut'),
	('Broken') --May need a different status name
/*
SELECT * FROM MediaStatus
*/

--Instantiate the genre types of media
INSERT INTO MediaGenre
	(Description)
--	 VCHAR(50)
VALUES
	('Rock'),
	('Classical'),
	('ACapella'),
	('Action'),
	('Comedy'),
	('Thriller')
/*
SELECT * FROM MediaGenre
*/

--Instantiate different media formats
INSERT INTO MediaType
	(Description)
--	 VCHAR(50)
VALUES
	('CD'),
	('DVD'),
	('VHS'),
	('8Track'),
	('Record')
/*
SELECT * FROM MediaType
*/

--Instantiate types of artists
INSERT INTO ArtistType
	(Description)
--	 VCHAR(40)
VALUES
	('Singer'),
	('Band'),
	('Actor'),
	('Composer')
/*
SELECT * FROM ArtistType
*/


/* Whoops. A problem with the original DB. This should correct it */
ALTER TABLE Borrower
	ALTER COLUMN PhoneNumber CHAR(10) NOT NULL
GO

--Instantiate borrowers of the media
INSERT INTO Borrower
	(FirstName, LastName, PhoneNumber)
--	 VCHAR(30), VCHAR(40), CHAR(10)
VALUES
	('Bob', 'Smythe', '8888888888'),
	('Robert', 'Smith', '5555555555'),
	('Jane', 'Doe', '5555554444'),
	('John', 'Doe', '1234567890'),
	('John', 'Smith', '2345678901'),
	('Pocahontas', 'Treehugger', '3456789012'),
	('Pocahontas', 'Raccoontalker', '4567890123'),
	('William', 'DaKid', '5678901234'),
	('McDonnell', 'Douglas', '6789012345'),
	('Papa', 'Smurf', '7890123456'),
	('Smurfette', 'Smurf', '8901234567'),
	('Brainy', 'Smurf', '9012345678'),
	('Clumsy', 'Smurf', '9876543210'),
	('Grouchy', 'Smurf', '8765432109'),
	('Hefty', 'Smurf', '7654321098'),
	('Vanity', 'Smurf', '6543210987'),
	('Gutsy', 'Smurf', '5432109876'),
	('Jokey', 'Smurf', '4321098765'),
	('Handy', 'Smurf', '3210987654'),
	('Greedy', 'Smurf', '8888888888'),
	('Dopey', 'Dwarf', '5555551212')
/*
SELECT * FROM Borrower
*/

--Instantiate artist
INSERT INTO Artist
	(GroupName, FirstName, LastName, ArtistTypeID)
--	 VCHAR(75), VCHAR(30), VCHAR(40), FKINT
VALUES
	(NULL, 'David', 'Archuleta', 1),
	(NULL, 'Johann', 'Bach', 1),
	('ColdPlay', NULL, NULL, 2),
	('GreenDay', NULL, NULL, 2),
	('TheBand', NULL, NULL, 2),
	('Beatles', NULL, NULL, 2),
	('Friederikson', NULL, NULL, 2),
	('BennyAndTheJets', NULL, NULL, 2),
	(NULL, 'Phil', 'Coulson', 1),
	('NonExistant', NULL, NULL, 2),
	(NULL, 'Michael', 'Jackson', 1),
	('TheMonkees', NULL, NULL, 2),
	('Eagles', NULL, NULL, 2),
	(NULL, 'Elvis', 'Presley', 1),
	('WhatsTheirFace', NULL, NULL, 2),
	(NULL, 'Clark', 'Gregg', 3),
	(NULL, 'Mark', 'Hamill', 3),
	(NULL, 'Harrison', 'Ford', 3),
	(NULL, 'Anon', 'Ymous', 3),
	(NULL, 'Phil', 'Coulson', 3)
/*
SELECT * FROM Artist
*/

--Instantiate the media we have
INSERT INTO Inventory
	(ItemName, ReleaseDate, TypeID, GenreID, StatusCode)
--	 VCHAR(75), DATE,		FKINT,	FKINT,	 FKINT
VALUES
	('Avengers', '02/01/2012', 2, 4, 1),
	('IAmGroot', '02/01/2010', 4, 5, 3),
	('Thriller', '02/01/1992', 1, 6, 2),
	('TheCoulsSon', '02/01/2018', 2, 5, 1),
	('Symphony1', '07/16/1950', 5, 2, 1),
	('Symphony1', '07/16/1950', 5, 2, 1),
	('Symphony1', '07/16/1950', 5, 2, 2),
	('Symphony2', '07/16/1952', 5, 2, 3),
	('VivaLaVida', '02/01/2012', 2, 4, 1),
	('VivaLaVida', '02/01/2012', 2, 4, 1),
	('IAmGroot', '02/01/2010', 4, 5, 1),
	('IAmGroot', '02/01/2010', 4, 5, 1),
	('IAmGroot', '02/01/2010', 4, 5, 1),
	('Avengers', '02/01/2012', 2, 4, 2),
	('Avengers', '02/01/2012', 2, 4, 2),
	('Avengers', '02/01/2012', 2, 4, 2),
	('Avengers', '02/01/2012', 2, 4, 3),
	('Avengers', '02/01/2012', 2, 4, 3),
	('Avengers', '02/01/2012', 2, 4, 3),
	('Avengers', '02/01/2012', 2, 4, 3),
	('Avengers', '02/01/2012', 2, 4, 3)
/* *****************************************************************
SELECT * FROM Inventory
*/


/*
SELECT * FROM Inventory
GO
SELECT * FROM Artist
GO
*/
--Instantiate the artists of the media ****************************
INSERT INTO MediaArtists
	(ArtistID, ItemID)
--	 FKINT,		FKINT
VALUES
	(20, 1),
	(20, 2),
	(20, 4), --Here's the disk with two artists
	(16, 4), --See above
	(20, 11),
	(20, 12),
	(20, 13), --Boy, Phil is in a lot of these movies
	(20, 14),
	(20, 15),
	(20, 16),
	(20, 17),
	(20, 18),
	(20, 19),
	(20, 20),
	(11, 3),
	(3, 9),
	(3, 10),
	(2, 5),
	(3, 6),
	(4, 7),
	(5, 8)
/*
--See if we have any media not tied to an artist
SELECT ItemName, Inventory.ItemID, ArtistID
FROM MediaArtists
RIGHT JOIN Inventory
	ON MediaArtists.ItemID = Inventory.ItemID
--There should be only one!
*/

--Instantiate time frame of borrowed items
INSERT INTO BorrowedTimes
	(BorrowedDate, ExpectedReturnDate, ReturnDate, BorrowerID, ItemID)
--	 DATE,			DATE,			   DATE NULL,  FKINT,	   FKINT
--	 CHECK NOT FUTURE
VALUES
	('02/02/2012', '03/03/2012', '03/03/2012', 3, 3),
	('02/02/2012', '03/03/2012', '03/03/2012', 3, 7),
	('02/02/2012', '03/03/2012', '03/03/2012', 3, 14),
	('02/02/2012', '03/03/2012', '03/03/2012', 3, 15), --Item has been checked out twice
	('02/02/2012', '03/03/2012', '03/03/2012', 3, 16),
	('02/02/2012', '03/03/2012', '03/03/2012', 20, 1),
	('02/02/2012', '03/03/2012', '03/03/2012', 17, 5),
	('02/02/2012', '03/03/2012', '03/03/2012', 15, 8),
	('02/02/2012', '03/03/2012', '03/03/2012', 2, 9),
	('02/02/2012', '03/03/2012', '03/03/2012', 8, 15), --Borrower rechecked this out
	('02/02/2012', '03/03/2012', '08/03/2012', 8, 20),
	('02/02/2012', '03/03/2012', '08/03/2012', 15, 19),
	('02/02/2012', '03/03/2012', '08/03/2012', 11, 18),
	('08/02/2012', '09/03/2012', '08/03/2012', 3, 17),
	('02/02/2012', '03/03/2012', '03/03/2015', 3, 2),
	('02/02/2016', '03/03/2016', NULL, 6, 3),
	('02/02/2016', '03/03/2016', NULL, 6, 7),
	('02/02/2016', '03/03/2016', NULL, 7, 14),
	('02/02/2016', '03/03/2016', NULL, 8, 15),
	('02/02/2016', '03/03/2016', NULL, 9, 16)
/*
--Show all checked out stuff
SELECT * FROM BorrowedTimes

--Show whether items checked out are still checked out
SELECT Inventory.ItemID, ItemName, MediaStatus.Description AS 'Status', BorrowedDate, ReturnDate
FROM Inventory
LEFT JOIN BorrowedTimes
	ON BorrowedTimes.ItemID = Inventory.ItemID
JOIN MediaStatus
	ON Inventory.StatusCode = MediaStatus.StatusCode
*/

/*
*********** Editing the table data *******************
*/

--Delete one borrower from the system
DELETE Borrower
WHERE FirstName = 'Dopey'
--SELECT * FROM Borrower

--Update one item in Inventory
UPDATE Inventory
SET StatusCode = 3
WHERE ReleaseDate = '07/16/1952' --This release date was catasrophic! :D

/* Query what is out on a loan*/
SELECT Inventory.ItemID, ItemName, Borrower.FirstName, BorrowedDate, ReturnDate
FROM Inventory
LEFT JOIN BorrowedTimes
	ON BorrowedTimes.ItemID = Inventory.ItemID
JOIN Borrower
	ON BorrowedTimes.BorrowerID = Borrower.BorrowerID
WHERE ReturnDate IS NULL AND --If it hasn't been returned
	BorrowedDate IS NOT NULL --If it has been borrowed