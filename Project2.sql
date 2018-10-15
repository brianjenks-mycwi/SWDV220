/************************************************************************
* Date			Programmer		Notes
* --------------------------------------------------------------------
* 10/5/2018		Brian Jenks		First creation of MediaLibrary DB
* 10/12/2018	Brian Jenks		Changed Borrower-Phone to CHAR(10) 
*
*************************************************************************/

/* Create the database, or drop it if it already exists */
IF DB_ID('MediaLibrary') IS NOT NULL
	DROP DATABASE MediaLibrary
GO

CREATE DATABASE MediaLibrary;
GO
/* Enter the DB */
USE MediaLibrary
GO

/* Create the tables for the Database */
/* This is to define the various status types of a media item */
CREATE TABLE MediaStatus
(
StatusCode       INT		PRIMARY KEY	IDENTITY,
Description      VARCHAR(50)	NOT NULL
);

/* This is to define the genre types of media */
CREATE TABLE MediaGenre
(
GenreID			INT            PRIMARY KEY IDENTITY,
Description     VARCHAR(50)		NOT NULL
);

/* This defines what format the media is on */
CREATE TABLE MediaType
(
TypeID			INT            PRIMARY KEY IDENTITY,
Description     VARCHAR(50)		NOT NULL
);

/* This defines different types of artists */
CREATE TABLE ArtistType
(
ArtistTypeID	INT		PRIMARY KEY		IDENTITY,
Description		VARCHAR(40)		NOT NULL
);

/* This defines a person who has borrowed media */
CREATE TABLE Borrower
(
BorrowerID      INT            PRIMARY KEY IDENTITY,
FirstName		VARCHAR(30)		NOT NULL,
LastName		VARCHAR(40)		NOT NULL,
PhoneNumber		CHAR(10)		NOT NULL
);

/* This defines an Artist of media */
CREATE TABLE Artist
(
ArtistID		INT            PRIMARY KEY IDENTITY,
GroupName		VARCHAR(75)		NULL,
FirstName		VARCHAR(30)		NULL,
LastName		VARCHAR(40)		NULL,
ArtistTypeID    INT		NOT NULL REFERENCES ArtistType (ArtistTypeID)
);

/* This defines the media */
CREATE TABLE Inventory
(
ItemID      INT            PRIMARY KEY IDENTITY,
ItemName	VARCHAR(75)		NOT NULL,
ReleaseDate		DATE		NOT NULL,
TypeID         INT NOT NULL REFERENCES MediaType (TypeID),
GenreID        INT NOT NULL REFERENCES MediaGenre (GenreID),
StatusCode     INT NOT NULL REFERENCES MediaStatus (StatusCode)
);

/* This defines what artists are connected with the media */
CREATE TABLE MediaArtists
(
ArtistID         INT NOT NULL REFERENCES Artist (ArtistID),
ItemID         INT NOT NULL REFERENCES Inventory (ItemID)
);

/* This defines a time frame for borrowed items */
CREATE TABLE BorrowedTimes
(
BorrowedDate		 DATE	NOT NULL,
ExpectedReturnDate	 DATE	NOT NULL,
ReturnDate		     DATE	NULL,
InvoiceID			 INT            PRIMARY KEY IDENTITY,
BorrowerID			 INT NOT NULL REFERENCES Borrower (BorrowerID),
ItemID				 INT NOT NULL REFERENCES Inventory (ItemID),
/* We need to make sure this date is not in the future */
CHECK ((BorrowedDate <= GETDATE()))
);