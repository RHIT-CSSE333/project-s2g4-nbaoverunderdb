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

	-- Insert and capture the identity
	INSERT INTO [Statistics] (Points, Assists, Rebounds, Steals, Blocks)
	VALUES (@PointsAvg, @AssistsAvg, @ReboundsAvg, @StealsAvg, @BlocksAvg);

	-- Set the output parameter
	SET @StatsID = @@IDENTITY

	-- Assuming successful insertion
	RETURN 0;
END