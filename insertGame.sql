USE NBAOverUnderDB
Go

CREATE PROCEDURE InsertGameByTeamNames(@HomeTeamName VARCHAR(255), @AwayTeamName VARCHAR(255), @GameDate Date)
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