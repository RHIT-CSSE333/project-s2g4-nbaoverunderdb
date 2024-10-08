USE [NBAOverUnderDB]
GO

CREATE PROCEDURE Register
	@Username varchar(255),
	@Email varchar(255),
	@PasswordSalt varchar(255),
	@PasswordHash varchar(255)
AS
BEGIN
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
	  RETURN(5)
	END
	INSERT INTO [User](Username, Email, PasswordSalt, PasswordHash)
	VALUES (@username, @email, @passwordSalt, @passwordHash)
	RETURN(0)
END
