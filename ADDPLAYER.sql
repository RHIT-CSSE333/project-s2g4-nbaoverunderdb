Create Procedure addPlayer
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
		Insert into Player(First,Last)
		Values(@FName,@LName);
	end
	