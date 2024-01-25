CREATE PROCEDURE AddStats
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
	IF @FName IS NULL OR @LName IS NULL
	BEGIN
		PRINT 'ERROR: INSERTED NULL VALUES';
		RETURN 1;
	END

	IF NOT EXISTS (SELECT 1 FROM Player WHERE First = @FName AND Last = @LName)
	BEGIN
		PRINT 'ERROR: Player does not exist';
		RETURN 2;
	END

	-- Insert and capture the identity
	DECLARE @InsertedStatsID table (ID int);
	INSERT INTO [Statistics] (Points, Assists, Rebounds, Steals, Blocks)
	OUTPUT INSERTED.ID INTO @InsertedStatsID
	VALUES (@PointsAvg, @AssistsAvg, @ReboundsAvg, @StealsAvg, @BlocksAvg);

	-- Set the output parameter
	SELECT TOP 1 @StatsID = ID FROM @InsertedStatsID;

	-- Assuming successful insertion
	RETURN 0;
END