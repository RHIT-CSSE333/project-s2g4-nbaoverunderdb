--CREATE DATABASE NBAOverUnderDB;
--GO


USE NBAOverUnderDB;
GO

CREATE TABLE [Statistics] (
    ID INT IDENTITY(0,1) PRIMARY KEY,
    Points DECIMAL(10,1) CHECK (Points >= 0), 
    Assists DECIMAL(10,1) CHECK (Assists >= 0),
    Rebounds DECIMAL(10,1) CHECK (Rebounds >= 0),
    Steals DECIMAL(10,1) CHECK (Steals >= 0),
    Blocks DECIMAL(10,1) CHECK (Blocks >= 0),
);

CREATE TABLE PicksInParlay (
    PickID INT NOT NULL,
    ParlayID INT NOT NULL,
    PRIMARY KEY (PickID, ParlayID),
    FOREIGN KEY (PickID) REFERENCES Pick(ID),
    FOREIGN KEY (ParlayID) REFERENCES Parlay(ID)
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



CREATE TABLE GameStats (
	StatsID INT NOT NULL,
	GameID INT NOT NULL,
	PlayerID INT NOT NULL, 
	PRIMARY KEY (StatsID, GameID, PlayerID),
	FOREIGN KEY (StatsID) REFERENCES [Statistics](ID),
	FOREIGN KEY (GameID) REFERENCES Game(ID),
	FOREIGN KEY (PlayerID) REFERENCES Player(ID)
);
	