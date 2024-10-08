USE NBAOverUnderDB
GO
CREATE PROCEDURE InsertTeam (@Name VARCHAR(255))
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
