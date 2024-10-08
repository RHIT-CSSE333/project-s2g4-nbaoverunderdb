USE [master]
GO
/****** Object:  Database [NBAOverUnderDB]    Script Date: 2/16/2024 12:05:15 AM ******/
:setvar DatabaseName "NBAOverUnderDB5"

CREATE DATABASE [$(DatabaseName)]
GO

USE [$(DatabaseName)]
GO
/****** Object:  User [pengkx]    Script Date: 2/16/2024 12:05:23 AM ******/
CREATE USER [pengkx] FOR LOGIN [pengkx] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [nbaoverunderuser]    Script Date: 2/16/2024 12:05:23 AM ******/
CREATE USER [nbaoverunderuser] FOR LOGIN [nbaoverunderuser] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [akinsetr]    Script Date: 2/16/2024 12:05:23 AM ******/
CREATE USER [akinsetr] FOR LOGIN [akinsetr] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [pengkx]
GO
ALTER ROLE [db_datareader] ADD MEMBER [nbaoverunderuser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [nbaoverunderuser]
GO
ALTER ROLE [db_owner] ADD MEMBER [akinsetr]
GO
/****** Object:  Table [dbo].[Favorite Player]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Favorite Player](
	[User Username] [varchar](255) NOT NULL,
	[Player ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[User Username] ASC,
	[Player ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Favorite Team]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Favorite Team](
	[User Username] [varchar](255) NOT NULL,
	[Team ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[User Username] ASC,
	[Team ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Parlay]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parlay](
	[ID] [int] IDENTITY(0,1) NOT NULL,
	[Bet] [money] NOT NULL,
	[Payout] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pick]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pick](
	[ID] [int] IDENTITY(0,1) NOT NULL,
	[Prediction] [bit] NOT NULL,
	[Team_ID] [int] NULL,
	[Player_ID] [int] NULL,
	[Guess_Stat] [varchar](255) NOT NULL,
	[Team_Against_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PicksInParlay]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PicksInParlay](
	[PickID] [int] NOT NULL,
	[ParlayID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PickID] ASC,
	[ParlayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Player]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Player](
	[ID] [int] IDENTITY(0,1) NOT NULL,
	[First] [varchar](255) NOT NULL,
	[Last] [varchar](255) NOT NULL,
	[TeamID] [int] NULL,
	[StatsID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Statistics]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Statistics](
	[ID] [int] IDENTITY(0,1) NOT NULL,
	[Points] [decimal](10, 1) NULL,
	[Assists] [decimal](10, 1) NULL,
	[Rebounds] [decimal](10, 1) NULL,
	[Steals] [decimal](10, 1) NULL,
	[Blocks] [decimal](10, 1) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Team]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Team](
	[ID] [int] IDENTITY(0,1) NOT NULL,
	[Name] [varchar](255) NULL,
	[StatsID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TeamStatistics]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeamStatistics](
	[ID] [int] IDENTITY(0,1) NOT NULL,
	[Points] [decimal](6, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Username] [varchar](255) NOT NULL,
	[Email] [varchar](255) NOT NULL,
	[PasswordSalt] [varchar](255) NOT NULL,
	[PasswordHash] [varchar](255) NOT NULL,
 CONSTRAINT [PK__User__536C85E5AD2A9027] PRIMARY KEY CLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserParlay]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserParlay](
	[User_ID] [varchar](255) NOT NULL,
	[Parlay_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[User_ID] ASC,
	[Parlay_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserPick]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPick](
	[User_ID] [varchar](255) NOT NULL,
	[Pick_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[User_ID] ASC,
	[Pick_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NCI_Player_First]    Script Date: 2/16/2024 12:05:23 AM ******/
CREATE NONCLUSTERED INDEX [NCI_Player_First] ON [dbo].[Player]
(
	[First] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NCI_Player_Last]    Script Date: 2/16/2024 12:05:23 AM ******/
CREATE NONCLUSTERED INDEX [NCI_Player_Last] ON [dbo].[Player]
(
	[Last] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NCI_Team_Name]    Script Date: 2/16/2024 12:05:23 AM ******/
CREATE NONCLUSTERED INDEX [NCI_Team_Name] ON [dbo].[Team]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Favorite Player]  WITH CHECK ADD FOREIGN KEY([Player ID])
REFERENCES [dbo].[Player] ([ID])
GO
ALTER TABLE [dbo].[Favorite Player]  WITH CHECK ADD FOREIGN KEY([User Username])
REFERENCES [dbo].[User] ([Username])
GO
ALTER TABLE [dbo].[Favorite Team]  WITH CHECK ADD FOREIGN KEY([Team ID])
REFERENCES [dbo].[Team] ([ID])
GO
ALTER TABLE [dbo].[Favorite Team]  WITH CHECK ADD  CONSTRAINT [FK__Favorite __User __4D5F7D71] FOREIGN KEY([User Username])
REFERENCES [dbo].[User] ([Username])
GO
ALTER TABLE [dbo].[Favorite Team] CHECK CONSTRAINT [FK__Favorite __User __4D5F7D71]
GO
ALTER TABLE [dbo].[Pick]  WITH CHECK ADD FOREIGN KEY([Player_ID])
REFERENCES [dbo].[Player] ([ID])
GO
ALTER TABLE [dbo].[Pick]  WITH CHECK ADD FOREIGN KEY([Team_Against_ID])
REFERENCES [dbo].[Team] ([ID])
GO
ALTER TABLE [dbo].[Pick]  WITH CHECK ADD FOREIGN KEY([Team_ID])
REFERENCES [dbo].[Team] ([ID])
GO
ALTER TABLE [dbo].[PicksInParlay]  WITH CHECK ADD FOREIGN KEY([ParlayID])
REFERENCES [dbo].[Parlay] ([ID])
GO
ALTER TABLE [dbo].[PicksInParlay]  WITH CHECK ADD FOREIGN KEY([PickID])
REFERENCES [dbo].[Pick] ([ID])
GO
ALTER TABLE [dbo].[Player]  WITH CHECK ADD FOREIGN KEY([StatsID])
REFERENCES [dbo].[Statistics] ([ID])
GO
ALTER TABLE [dbo].[Player]  WITH CHECK ADD FOREIGN KEY([TeamID])
REFERENCES [dbo].[Team] ([ID])
GO
ALTER TABLE [dbo].[Team]  WITH CHECK ADD FOREIGN KEY([StatsID])
REFERENCES [dbo].[TeamStatistics] ([ID])
GO
ALTER TABLE [dbo].[UserParlay]  WITH CHECK ADD FOREIGN KEY([Parlay_ID])
REFERENCES [dbo].[Parlay] ([ID])
GO
ALTER TABLE [dbo].[UserParlay]  WITH CHECK ADD FOREIGN KEY([User_ID])
REFERENCES [dbo].[User] ([Username])
GO
ALTER TABLE [dbo].[UserPick]  WITH CHECK ADD FOREIGN KEY([User_ID])
REFERENCES [dbo].[User] ([Username])
GO
ALTER TABLE [dbo].[Parlay]  WITH CHECK ADD CHECK  (([Payout]>=(1)))
GO
ALTER TABLE [dbo].[Statistics]  WITH CHECK ADD CHECK  (([Assists]>=(0)))
GO
ALTER TABLE [dbo].[Statistics]  WITH CHECK ADD CHECK  (([Blocks]>=(0)))
GO
ALTER TABLE [dbo].[Statistics]  WITH CHECK ADD CHECK  (([Points]>=(0)))
GO
ALTER TABLE [dbo].[Statistics]  WITH CHECK ADD CHECK  (([Rebounds]>=(0)))
GO
ALTER TABLE [dbo].[Statistics]  WITH CHECK ADD CHECK  (([Steals]>=(0)))
GO
ALTER TABLE [dbo].[TeamStatistics]  WITH CHECK ADD CHECK  (([Points]>=(0)))
GO
/****** Object:  StoredProcedure [dbo].[AddFavoritePlayer]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddFavoritePlayer]
    @PlayerFName VARCHAR(100),
	@PlayerLName VARCHAR(100),
    @UserName VARCHAR(100)
AS
BEGIN

	if not exists (Select * From [User] Where Username = @UserName)
		begin
		raiserror('username does not exist',14,1)
		end
	end
    -- Variable to hold TeamID
    DECLARE @PlayerID INT;

    -- Find the TeamID based on the TeamName
    SELECT @PlayerID = ID FROM Player WHERE First=@PlayerFName and Last=@PlayerLName;

    -- Check if the team exists
    IF @PlayerID IS NOT NULL
    BEGIN
        -- Insert the player into the Players table
        INSERT INTO [Favorite Player]([User Username],[Player ID])
        VALUES (@UserName, @PlayerID);
    END
    ELSE
    BEGIN
        -- Handle the case where the team does not exist
		raiserror('cannot find player',14,1)
    END
GO
/****** Object:  StoredProcedure [dbo].[AddFavoriteTeam]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddFavoriteTeam]
    @TeamName VARCHAR(100),
    @UserName VARCHAR(100)
AS
BEGIN
    -- Variable to hold TeamID
    DECLARE @TeamID INT;

    -- Find the TeamID based on the TeamName
    SELECT @TeamID = ID FROM Team WHERE Name=@TeamName;

	if not exists (Select * From [User] Where Username = @UserName)
		begin
		raiserror('username does not exist',14,1)
		end
	end
    -- Check if the team exists
    IF @TeamID IS NOT NULL
    BEGIN
        -- Insert the player into the Players table
        INSERT INTO [Favorite Team]([User Username],[Team ID])
        VALUES (@UserName, @TeamID);
    END
    ELSE
    BEGIN
        -- Handle the case where the team does not exist
		raiserror('cannot find team',14,1)
    END
GO
/****** Object:  StoredProcedure [dbo].[AddParlay]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[AddParlay]
    @Bet money,
    @Payout int
As
Begin
    -- Check for null values
    if @Payout is null or @Bet is null
    Begin
        raiserror('null parlay entries', 14, 1)
        return 1;
    End

	 -- Check for valid values
    if @Payout <= 0 or @Bet <= 0
    Begin
        raiserror('Invalid parlay entries. Bet and Payout must be greater than 0.', 14, 1)
        return 1;
    End

    -- Insert the values into the Parlay table
    Insert into Parlay(Bet, Payout)
    Values(@Bet, @Payout)
End
GO
/****** Object:  StoredProcedure [dbo].[AddPick]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPick]
    @Prediction bit,
    @Team_Name varchar(255) = null,
    @Player_First_Name varchar(255) = null,
    @Player_Last_Name varchar(255) = null,
    @Guess_Stat varchar(255),
    @Team_Against_Name varchar(255)
AS
BEGIN
    -- Check for null values
    IF @Prediction IS NULL OR @Guess_Stat IS NULL OR @Team_Against_Name IS NULL
    BEGIN
        RAISERROR('Null values are not allowed for Prediction, Guess_Stat, and Team_Against_Name.', 16, 1);
        RETURN 1;
    END

    -- Check for null values
    IF @Team_Name IS NULL AND (@Player_First_Name IS NULL OR @Player_Last_Name IS NULL)
    BEGIN
        RAISERROR('Either a team name or both first and last names for the player must be provided.', 16, 1);
        RETURN 2;
    END

    -- Variables to hold IDs
    DECLARE @Team_ID int, @Player_ID int, @Team_Against_ID int;

    -- Check and get Team_ID
    IF @Team_Name IS NOT NULL
    BEGIN
        SELECT @Team_ID = ID FROM Team WHERE Name = @Team_Name;
        IF @Team_ID IS NULL
        BEGIN
            RAISERROR('Team_Name does not exist in the Team table.', 16, 1);
            RETURN 3;
        END
    END

    -- Check and get Player_ID using First Name and Last Name
    IF @Player_First_Name IS NOT NULL AND @Player_Last_Name IS NOT NULL
    BEGIN
        SELECT @Player_ID = ID FROM Player WHERE First = @Player_First_Name AND Last = @Player_Last_Name;
        IF @Player_ID IS NULL
        BEGIN
            RAISERROR('Player name does not exist in the Player table.', 16, 1);
            RETURN 4;
        END
    END

    -- Check and get Team_Against_ID
    SELECT @Team_Against_ID = ID FROM Team WHERE Name = @Team_Against_Name;
    IF @Team_Against_ID IS NULL
    BEGIN
        RAISERROR('Team_Against_Name does not exist in the Team table.', 16, 1);
        RETURN 5;
    END

    -- Insert operation with IDs resolved from names
    INSERT INTO Pick(Prediction, Team_ID, Player_ID, Guess_Stat, Team_Against_ID)
    VALUES (@Prediction, @Team_ID, @Player_ID, @Guess_Stat, @Team_Against_ID);
END
GO
/****** Object:  StoredProcedure [dbo].[addPlayer]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[addPlayer]
	@FName varchar(255),
	@LName varchar(255),
	@TeamID int = null,
	@StatsID int = null
as
	begin
		if @FName is null or @LName is null
		begin
			print 'ERROR INSERTED NULL VALUES';
			Return 1
		end
		if exists (select First, Last From Player Where First=@FName and Last=@LName)
		begin
			print 'player already exists';
			Return 2
		end
		Insert into Player(First,Last,TeamID, StatsID)
		Values(@FName,@LName,@TeamID,@StatsID);
	end
GO
/****** Object:  StoredProcedure [dbo].[AddPlayerToTeam]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPlayerToTeam]
    @PlayerFName VARCHAR(100),
	@PlayerLName VARCHAR(100),
    @TeamName VARCHAR(100)
AS
BEGIN
	IF @PlayerFName IS NOT NULL AND @PlayerLName IS NOT NULL
	BEGIN
		RAISERROR('Invalid player name', 16, 1);
	END

	IF NOT EXISTS (SELECT 1 FROM Player WHERE First = @PlayerFName AND Last = @PlayerLName)
	BEGIN
		RAISERROR('Player does not exist in the Player table.', 16, 1);
		RETURN 1;
	END

    -- Variable to hold TeamID
    DECLARE @TeamID INT;

    -- Find the TeamID based on the TeamName
    SELECT @TeamID = ID FROM Team WHERE Name = @TeamName;

    -- Check if the team exists
    IF @TeamID IS NOT NULL
    BEGIN
        -- Insert the player into the Players table
        INSERT INTO Player ([First],[Last], TeamID)
        VALUES (@PlayerFName, @PlayerLName, @TeamID);
    END
    ELSE
    BEGIN
        -- Handle the case where the team does not exist
        RAISERROR('Team not found', 16, 1);
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[AddStats]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddStats]
	@FName varchar(255),
	@LName varchar(255),
	@PointsAvg decimal(5,2) = null,
	@ReboundsAvg decimal(5,2) = null,
	@BlocksAvg decimal(5,2) = null,
	@StealsAvg decimal(5,2) = null,
	@AssistsAvg decimal(5,2) = null,
	@StatsID int OUTPUT
AS
BEGIN

	-- Insert and capture the identity
	INSERT INTO [Statistics] (Points, Assists, Rebounds, Steals, Blocks)
	VALUES (@PointsAvg, @AssistsAvg, @ReboundsAvg, @StealsAvg, @BlocksAvg);

	-- Set the output parameter
	SET @StatsID = @@IDENTITY

	-- Assuming successful insertion
	RETURN 0;
END
GO
/****** Object:  StoredProcedure [dbo].[ADDTEAM]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[ADDTEAM]
	@TName varchar(255),
	@StatsID int = null
as
	begin
		if @TName is null
		begin
			print 'ERROR INSERTED NULL VALUES';
			Return 1
		end
		if exists (select * From Team Where Name=@TName)
		begin
			print 'Team already exists';
			Return 2
		end
		Insert into Team([Name], StatsID)
		Values(@TName, @StatsID);
	end
GO
/****** Object:  StoredProcedure [dbo].[AddTeamStats]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddTeamStats]
	-- @FName varchar(255),
	-- @LName varchar(255),
	@PointsAvg decimal(6,2) = null,
	@StatsID int OUTPUT
AS
BEGIN

	-- Insert and capture the identity
	INSERT INTO [TeamStatistics] (Points)
	VALUES (@PointsAvg);

	-- Set the output parameter
	SET @StatsID = @@IDENTITY

	-- Assuming successful insertion
	RETURN 0;
END
GO
/****** Object:  StoredProcedure [dbo].[AddUserParlay]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddUserParlay]
    @Username NVARCHAR(255),
    @ParlayID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO UserParlay (User_ID, Parlay_ID)
    VALUES (@Username, @ParlayID);

END;
GO
/****** Object:  StoredProcedure [dbo].[AddUserPick]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddUserPick]
    @Username NVARCHAR(255),
    @PickID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO UserPick (User_ID, Pick_ID)
    VALUES (@Username, @PickID);

END;
GO
/****** Object:  StoredProcedure [dbo].[DeleteFavoritePlayer]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFavoritePlayer]
    @PlayerFName VARCHAR(100),
    @PlayerLName VARCHAR(100),
    @UserName VARCHAR(100)
AS
BEGIN
    -- Check if the user exists
    IF NOT EXISTS (SELECT * FROM [User] WHERE Username = @UserName)
    BEGIN
        RAISERROR('Username does not exist', 14, 1);
        RETURN 1; -- Stop execution if user doesn't exist
    END

    -- Variable to hold PlayerID
    DECLARE @PlayerID INT;

    -- Find the PlayerID based on the Player's First and Last Name
    SELECT @PlayerID = ID FROM Player WHERE First = @PlayerFName AND Last = @PlayerLName;

    -- Check if the player exists
    IF @PlayerID IS NOT NULL
    BEGIN
        -- Delete the favorite player for the user
        DELETE FROM [Favorite Player]
        WHERE [User Username] = @UserName AND [Player ID] = @PlayerID;
		RETURN 0;
    END
    ELSE
    BEGIN
        -- Handle the case where the player does not exist
        RAISERROR('Player does not exist or is not a favorite.', 15, 1);
		RETURN 2;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteFavoriteTeam]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFavoriteTeam]
    @TeamName VARCHAR(100),
    @UserName VARCHAR(100)
AS
BEGIN
    -- Check if the user exists
    IF NOT EXISTS (SELECT * FROM [User] WHERE Username = @UserName)
    BEGIN
        RAISERROR('Username does not exist', 14, 1);
        RETURN 1; -- Stop execution if user doesn't exist
    END

    -- Variable to hold PlayerID
    DECLARE @TeamID INT;

    -- Find the PlayerID based on the Player's First and Last Name
    SELECT @TeamID = ID FROM Team WHERE Name = @TeamName 
    -- Check if the player exists
    IF @TeamID IS NOT NULL
    BEGIN
        -- Delete the favorite player for the user
        DELETE FROM [Favorite Team]
        WHERE [User Username] = @UserName AND [Team ID] = @TeamID;
		RETURN 0;
    END
    ELSE
    BEGIN
        -- Handle the case where the player does not exist
		RAISERROR('Team does not exist or is not a favorite.', 15, 1);
		RETURN 2;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteParlay]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteParlay]
	@Username varchar(255),
	@ParlayID int
AS
BEGIN
	-- Check for null value
	IF @ParlayID IS NULL OR @Username IS NULL
	BEGIN
		RAISERROR('Null value is not allowed for ParlayID or Username.', 16, 1);
		RETURN 1;
	END


	IF NOT EXISTS (SELECT 1 FROM UserParlay WHERE [User_ID] = @Username AND [Parlay_ID] = @ParlayID)
	BEGIN
		RAISERROR('Parlay does not exist in the UserParlay table.', 16, 1);
		RETURN 3;
	END

	-- Delete the UserParlay by ParlayID
	DELETE FROM UserParlay WHERE [User_ID] = @Username and Parlay_ID = @ParlayID;
END
GO
/****** Object:  StoredProcedure [dbo].[DeletePick]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeletePick]
	@PickID int
AS
BEGIN
	-- Check for null value
	IF @PickID IS NULL
	BEGIN
		RAISERROR('Null value is not allowed for PickID.', 16, 1);
		RETURN 1;
	END

	-- Check if PickID exists in Pick table
	IF NOT EXISTS (SELECT 1 FROM Pick WHERE ID = @PickID)
	BEGIN
		RAISERROR('Pick does not exist in the Pick table.', 16, 1);
		RETURN 2;
	END

	-- Delete the pick by PickID
	DELETE FROM Pick WHERE ID = @PickID;
END
GO
/****** Object:  StoredProcedure [dbo].[FindAllPlayerStats]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FindAllPlayerStats]
    @First varchar(255),
    @Last varchar(255)

AS
BEGIN
    IF @First is null or @First = ''
    BEGIN
        Print 'First cannot be null or empty.';
        RETURN (1)
    END
    IF @Last is null or @Last = ''
    BEGIN
        Print 'Last cannot be null or empty.';
        RETURN (2)
    END

    Select p.First, p.Last, s.Points, s.Assists, s.Rebounds, s.Blocks, s.Steals
	From Player p
	Join [Statistics] s on s.ID = p.StatsID
	Where p.First = @First and p.Last = @Last

	return

END
GO
/****** Object:  StoredProcedure [dbo].[FindAllTeamStats]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[FindAllTeamStats]
    @Name varchar(255)
AS
BEGIN
    IF @Name is null or @Name = ''
    BEGIN
        Print 'Name cannot be null or empty.';
        RETURN (1)
    END

    Select t.Name, ts.Points
	From Team t
	Join [TeamStatistics] ts on ts.ID = t.StatsID
	Where t.Name = @Name

	return

END
GO
/****** Object:  StoredProcedure [dbo].[FindPlayerStat]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FindPlayerStat]
    @First varchar(255),
    @Last varchar(255),
    @Stat varchar(255)
AS
BEGIN
    IF @First is null or @First = ''
    BEGIN
        Print 'First cannot be null or empty.';
        RETURN (1)
    END
    IF @Last is null or @Last = ''
    BEGIN
        Print 'Last cannot be null or empty.';
        RETURN (2)
    END
    IF @Stat is null or @Stat = ''
    BEGIN
        Print 'Stat cannot be null or empty.';
        RETURN (3)
    END

    Declare @StatsID int;
    Declare @SQLQuery AS NVARCHAR(500);

    SELECT @StatsID = StatsID FROM Player WHERE First = @First AND Last = @Last;

    IF @StatsID IS NOT NULL
    BEGIN
        SET @SQLQuery = 'SELECT ' + @Stat + ' FROM [Statistics] WHERE (ID = ' + CAST(@StatsID AS VARCHAR(255)) + ')';
        EXEC sp_executesql @SQLQuery;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[FindTeamStat]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FindTeamStat]
    @Name varchar(255)
AS
BEGIN
    IF @Name is null or @Name = ''
    BEGIN
        Print 'Name cannot be null or empty.';
        RETURN (1)
    END

    Declare @StatsID int;
    Declare @SQLQuery AS NVARCHAR(500);

    SELECT @StatsID = StatsID FROM Team WHERE [Name] = @Name;

    IF @StatsID IS NOT NULL
    BEGIN
        SET @SQLQuery = 'SELECT Points FROM [TeamStatistics] WHERE (ID = ' + CAST(@StatsID AS VARCHAR(255)) + ')';
        EXEC sp_executesql @SQLQuery;
    END
END
GO
/****** Object:  StoredProcedure [dbo].[GetFavPlayerNames]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFavPlayerNames]
    @Username NVARCHAR(255) 
AS
BEGIN
    SELECT p.First, p.Last 
    FROM [Favorite Player] fp
    JOIN Player p ON fp.[Player ID] = p.ID
    WHERE fp.[User Username] = @Username 
END
GO
/****** Object:  StoredProcedure [dbo].[GetFavTeamNames]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFavTeamNames]
    @Username NVARCHAR(255) 
AS
BEGIN
    SELECT t.Name 
    FROM [Favorite Team] ft
    JOIN Team t ON t.ID = ft.[Team ID]
    WHERE ft.[User Username] = @Username 
END
GO
/****** Object:  StoredProcedure [dbo].[GetPickDataByUsername]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPickDataByUsername]
    @Username NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Retrieve picks with player names and team names instead of IDs
    SELECT 
        p.ID AS id,
        p.Prediction AS Prediction,
        Team.Name AS TeamName,
        Player.First AS PlayerFirstName,
        Player.Last AS PlayerLastName,
        p.Guess_Stat AS Guess_Stat,
        AgainstTeam.Name AS TeamAgainstName
    FROM UserPick up
    JOIN Pick p ON up.Pick_ID = p.ID
    LEFT JOIN Player ON p.Player_ID = Player.ID
    LEFT JOIN Team ON p.Team_ID = Team.ID
    LEFT JOIN Team AS AgainstTeam ON p.Team_Against_ID = AgainstTeam.ID
    WHERE up.User_ID = @Username;
END
GO
/****** Object:  StoredProcedure [dbo].[GetPlayerNames]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPlayerNames]
AS
BEGIN

    SELECT First, Last FROM Player;

END
GO
/****** Object:  StoredProcedure [dbo].[GetTeamNames]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTeamNames]
AS
BEGIN

    SELECT Name FROM Team;

END
GO
/****** Object:  StoredProcedure [dbo].[GetUserParlayDetails]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetUserParlayDetails]
    @Username NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.ID AS ParlayID,
        p.Bet,
        p.Payout,
        pk.ID AS PickID,
        pk.Prediction,
        pk.Guess_Stat,
        t.Name AS Team,
        tOpp.Name AS OpposingTeam,
        pl.First + ' ' + pl.Last AS PlayerName
    FROM 
        UserParlay up
        INNER JOIN Parlay p ON up.Parlay_ID = p.ID
        INNER JOIN PicksInParlay pip ON p.ID = pip.ParlayID
        INNER JOIN Pick pk ON pip.PickID = pk.ID
        LEFT JOIN Team t ON pk.Team_ID = t.ID
        LEFT JOIN Team tOpp ON pk.Team_Against_ID = tOpp.ID
        LEFT JOIN Player pl ON pk.Player_ID = pl.ID
    WHERE 
        up.User_ID = @Username
	ORDER BY 
        p.ID ASC

END;
GO
/****** Object:  StoredProcedure [dbo].[InsertGameByTeamNames]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertGameByTeamNames](@HomeTeamName VARCHAR(255), @AwayTeamName VARCHAR(255), @GameDate Date)
AS
BEGIN
    DECLARE @HomeTeamID INT;
    DECLARE @AwayTeamID INT;

    SELECT @HomeTeamID = ID FROM Team WHERE Name = @HomeTeamName;

	IF @HomeTeamID IS NULL
	BEGIN
		PRINT 'Home team ' + @HomeTeamName + ' not found'
		Return 1
	END

    SELECT @AwayTeamID = ID FROM Team WHERE Name = @AwayTeamName;

	IF @AwayTeamName IS NULL
	BEGIN
		PRINT 'Away team ' + @AwayTeamName + ' not found'
		Return 1
	END

    INSERT INTO Game ([Home Team ID], [Away Team ID], [GameDate])
    VALUES (@HomeTeamID, @AwayTeamID, @GameDate);
	Return 0
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertTeam]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertTeam] (@Name VARCHAR(255))
AS
BEGIN
	IF(@Name IS NULL)
	BEGIN
		PRINT('ERROR: Name is null')
		RETURN 1
	END
	IF(EXISTS(SELECT * FROM [Team] WHERE Name = @Name))
	BEGIN
		PRINT('ERROR: Team already exists')
		RETURN 2
	END
	INSERT INTO Team(Name)
	VALUES(@Name)
	PRINT('SUCCESSFUL INSERT')
	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[LoginQuery]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[LoginQuery]
	@Username varchar(255)
AS
BEGIN
	if @Username is null or @Username = ''
	BEGIN
		RETURN (1) -- invalid input
	END
	IF ( SELECT COUNT(*) FROM [User]
          WHERE Username = @Username) = 0
	BEGIN
		RETURN(2) -- username not found
	END
	SELECT PasswordSalt, PasswordHash
	FROM [User]
	WHERE (Username = @Username)
	RETURN(0)
END
GO
/****** Object:  StoredProcedure [dbo].[PickisInParlay]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[PickisInParlay]
	@PickID int,
	@ParlayID int
As
Begin
	if @PickID is null or @ParlayID is null
	begin
		raiserror('null value entered',14,1)
		return 1;
	end

	-- Check if PickID exists in Pick table
	IF NOT EXISTS (SELECT 1 FROM Pick WHERE ID = @PickID)
	BEGIN
		RAISERROR('PickID does not exist in the Pick table.', 16, 1);
		RETURN 1;
	END

	-- Check if ParlayID exists in Parlay table
	IF NOT EXISTS (SELECT 1 FROM Parlay WHERE ID = @ParlayID)
	BEGIN
		RAISERROR('ParlayID does not exist in the Parlay table.', 16, 1);
		RETURN 1;
	END

	Insert into PicksInParlay(PickID, ParlayID)
	Values(@PickID, @ParlayID)
End
GO
/****** Object:  StoredProcedure [dbo].[Register]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Register]
	@Username varchar(255),
	@Email varchar(255),
	@PasswordSalt varchar(255),
	@PasswordHash varchar(255)
AS
BEGIN
	SET NOCOUNT ON
	if @Username is null or @Username = ''
	BEGIN
		Print 'Username cannot be null or empty.';
		RETURN (1)
	END
	if @Email is null or @Email = ''
	BEGIN
		Print 'Email cannot be null or empty.';
		RETURN (2)
	END
	if @PasswordSalt is null or @PasswordSalt = ''
	BEGIN
		Print 'PasswordSalt cannot be null or empty.';
		RETURN (3)
	END
	if @PasswordHash is null or @PasswordHash = ''
	BEGIN
		Print 'PasswordHash cannot be null or empty.';
		RETURN (4)
	END
	IF (SELECT COUNT(*) FROM [User]
          WHERE Username = @Username) = 1
	BEGIN
		PRINT 'ERROR: Username already exists.';
		RETURN(4)
	END
	INSERT INTO [User](Username, Email, PasswordSalt, PasswordHash)
	VALUES (@username, @email, @passwordSalt, @passwordHash)

	SELECT Username FROM [User] WHERE Username=@Username AND Email=@Email
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateParlay]    Script Date: 2/16/2024 12:05:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateParlay]
	@Username varchar(255),
	@ParlayID int,
	@bet money,
	@payout int
AS
BEGIN
	-- Check for null value
	IF @ParlayID IS NULL OR @Username IS NULL OR @bet IS NULL OR @payout IS NULL
	BEGIN
		RAISERROR('Null value is not allowed for any param.', 16, 1);
		RETURN 1;
	END


	IF NOT EXISTS (SELECT 1 FROM UserParlay WHERE [User_ID] = @Username AND [Parlay_ID] = @ParlayID)
	BEGIN
		RAISERROR('Parlay does not exist in the UserParlay table.', 16, 1);
		RETURN 3;
	END

	-- Delete the UserParlay by ParlayID
	UPDATE Parlay
	SET Bet = @bet, Payout = @payout
	WHERE ID = @ParlayID;
END
GO

GRANT EXECUTE ON [dbo].[AddFavoritePlayer] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[AddFavoriteTeam] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[AddParlay] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[AddPick] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[addPlayer] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[AddPlayerToTeam] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[AddStats] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[ADDTEAM] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[AddTeamStats] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[AddUserParlay] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[AddUserPick] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[DeleteFavoritePlayer] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[DeleteFavoriteTeam] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[DeleteParlay] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[DeletePick] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[FindAllPlayerStats] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[FindAllTeamStats] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[FindPlayerStat] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[FindTeamStat] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[GetFavPlayerNames] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[GetFavTeamNames] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[GetPickDataByUsername] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[GetPlayerNames] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[GetTeamNames] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[GetUserParlayDetails] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[InsertGameByTeamNames] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[InsertTeam] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[LoginQuery] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[PickisInParlay] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[Register] TO [nbaoverunderuser];
GRANT EXECUTE ON [dbo].[UpdateParlay] TO [nbaoverunderuser];
