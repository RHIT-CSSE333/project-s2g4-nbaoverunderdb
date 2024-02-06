Create Procedure addPlayer
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
		Insert into Team(Name, StatsID)
		Values(@TName, @StatsID);
	end