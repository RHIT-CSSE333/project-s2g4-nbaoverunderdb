--CREATE DATABASE NBAOverUnderDB;
--GO

--CREATE USER [akinsetr] LOGIN [akinsetr];

--exec sp_addrolemember 'db_owner', 'akinsetr'; 

--GO

--CREATE USER [pengkx] LOGIN [pengkx];

--exec sp_addrolemember 'db_owner', 'pengkx'; 

--GO

USE NBAOverUnderDB;
GO

-- Create Table [Game](
-- ID int IDENTITY(0,1),
-- [Home Team ID] int,
-- [Away Team ID] int,
-- Primary Key(ID)
-- )

Create Table [User](
Username nvarchar(255),
Email varchar(255) NOT NULL,
[PasswordSalt] varchar(255) NOT NULL,
[PasswordHash] varchar(255) NOT NULL,
Primary Key(Username),
)

Create Table [Team](
ID int IDENTITY(0,1),
[Name] varchar(255),
Primary Key(ID)
)

CREATE TABLE Parlay (
	ID INT IDENTITY(0,1),
	Bet MONEY NOT NULL,
	Payout INT NOT NULL CHECK (Payout >= 1),
	PRIMARY KEY (ID)
);

CREATE TABLE Pick (
	ID INT IDENTITY(0,1),
	Prediction BIT NOT NULL,
	Team_ID INT,
	Player_ID INT,
	Guess_Stat VARCHAR(255) NOT NULL,
	Team_Against_ID INT NOT NULL,
	PRIMARY KEY (ID)
);

CREATE TABLE UserParlay (
	User_ID VARCHAR(255) NOT NULL,
	Parlay_ID INT NOT NULL,
	PRIMARY KEY (User_ID, Parlay_ID)
);

CREATE TABLE UserPick (
	User_ID VARCHAR(255) NOT NULL,
	Pick_ID INT NOT NULL,
	PRIMARY KEY (User_ID, Pick_ID)
);

CREATE TABLE [Statistics] (
    ID INT IDENTITY(0,1) PRIMARY KEY,
    Points DECIMAL(10,1) CHECK (Points >= 0), 
    Assists DECIMAL(10,1) CHECK (Assists >= 0),
    Rebounds DECIMAL(10,1) CHECK (Rebounds >= 0),
    Steals DECIMAL(10,1) CHECK (Steals >= 0),
    Blocks DECIMAL(10,1) CHECK (Blocks >= 0),
);


CREATE TABLE Player (
    ID INT IDENTITY(0,1) PRIMARY KEY,
    First VARCHAR(255) NOT NULL,
    Last VARCHAR(255) NOT NULL,
    TeamID INT,
	StatsID INT, 
	FOREIGN KEY (TeamID) REFERENCES Team(ID),
	FOREIGN KEY (StatsID) REFERENCES [Statistics](ID),
);

CREATE TABLE PicksInParlay (
    PickID INT NOT NULL,
    ParlayID INT NOT NULL,
    PRIMARY KEY (PickID, ParlayID),
    FOREIGN KEY (PickID) REFERENCES Pick(ID),
    FOREIGN KEY (ParlayID) REFERENCES Parlay(ID)
);


-- CREATE TABLE GameStats (
-- 	StatsID INT NOT NULL,
-- 	GameID INT NOT NULL,
-- 	PlayerID INT NOT NULL, 
-- 	PRIMARY KEY (StatsID, GameID, PlayerID),
-- 	FOREIGN KEY (StatsID) REFERENCES [Statistics](ID),
-- 	FOREIGN KEY (GameID) REFERENCES Game(ID),
-- 	FOREIGN KEY (PlayerID) REFERENCES Player(ID)
-- );

 
Create Table [Favorite Player](
 
[User Username] varchar(255),
[Player ID] int,
Primary Key([User Username],[Player ID]),
 
)
 
Alter table [Favorite Player]
ADD FOREIGN KEY ([User Username]) References [User](Username),
Foreign Key([Player ID]) References [Player](ID);
 
 
Create Table [Favorite Team](
 
[User Username] varchar(255),
[Team ID] int,
Primary Key([User Username],[Team ID]),
 
)
 
Alter table [Favorite Team]
ADD FOREIGN KEY ([User Username]) References [User](Username),
	FOREIGN key ([Team ID]) References [Team](ID);
 

 
-- Alter table [Game]
-- Add Foreign Key([Home Team ID]) References [Team](ID),
-- Foreign Key([Away Team ID]) References [Team](ID);

ALTER TABLE Pick
	ADD FOREIGN KEY (Team_ID) REFERENCES Team(ID),
		FOREIGN KEY (Player_ID) REFERENCES Player(ID),
		FOREIGN KEY (Team_Against_ID) REFERENCES Team(ID);

ALTER TABLE UserPick
	ADD FOREIGN KEY (User_ID) REFERENCES [User](Username),
		FOREIGN KEY (Pick_ID) REFERENCES Pick(ID);

ALTER TABLE UserParlay
	ADD FOREIGN KEY (User_ID) REFERENCES [User](Username),
		FOREIGN KEY (Parlay_ID) REFERENCES Parlay(ID);
	