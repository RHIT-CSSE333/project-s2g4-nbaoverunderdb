USE [NBAOverUnderDB]
GO

CREATE PROCEDURE [LoginQuery]
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
