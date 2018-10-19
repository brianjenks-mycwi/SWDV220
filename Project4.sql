/************************************************************************
* Date			Programmer		Notes
* --------------------------------------------------------------------
* 10/19/2018	Brian Jenks		First instantiation
*  
*************************************************************************/
USE MediaLibrary
GO



--Show disks with an individual artist (3.)
SELECT I.ItemName, I.ReleaseDate, A.FirstName, A.LastName
FROM Inventory AS I
JOIN MediaArtists AS MA
	ON I.ItemID = MA.ItemID
JOIN Artist AS A
	ON MA.ArtistID = A.ArtistID
WHERE A.LastName IS NOT NULL
GO

--Make a view to see only individual artists/actors (4.)
CREATE VIEW View_Individual_Artist
AS
SELECT ArtistID, FirstName, LastName
FROM Artist
WHERE LastName IS NOT NULL
GO

SELECT * FROM View_Individual_Artist
GO

-- Showing only groups, using the view to remove particular choices (5.)
--SELECT * FROM Inventory
SELECT I.ItemName, I.ReleaseDate, A.GroupName, A.LastName
FROM MediaArtists AS MA
JOIN Inventory AS I
	ON I.ItemID = MA.ItemID
JOIN Artist AS A
	ON MA.ArtistID = A.ArtistID
WHERE A.ArtistID NOT IN (SELECT ArtistID
	FROM View_Individual_Artist)
GO

-- Which disks have been borrowed, by who? (6.)
SELECT B.FirstName, B.LastName, I.ItemName
FROM BorrowedTimes AS BT
JOIN Inventory AS I
	ON I.ItemID = BT.ItemID
JOIN Borrower AS B
	ON B.BorrowerID = BT.BorrowerID
ORDER BY B.LastName
GO

-- Show number of times a disk has been borrowed (7.)
SELECT I.ItemID, I.ItemName, COUNT(BT.ItemID) AS TimesBorrowed
FROM Inventory AS I
JOIN BorrowedTimes AS BT
	ON I.ItemID = BT.ItemID
GROUP BY I.ItemID, I.ItemName
GO

--Show disks that are still on loan (8.)
SELECT B.FirstName, B.LastName, I.ItemName
FROM BorrowedTimes AS BT
JOIN Inventory AS I
	ON I.ItemID = BT.ItemID
JOIN Borrower AS B
	ON B.BorrowerID = BT.BorrowerID
WHERE BT.ReturnDate IS NULL
ORDER BY B.LastName
GO