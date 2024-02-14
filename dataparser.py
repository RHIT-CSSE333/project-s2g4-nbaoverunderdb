# import pandas as pd
# import pyodbc

# server = 'golem.csse.rose-hulman.edu'
# database = 'NBAOverUnderDB2'
# username = 'nbaoverunderuser'
# password = 'NBAPassword123'
# cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=' +
#                       server+';DATABASE='+database+';UID='+username+';PWD=' + password)

# csv_file = 'nbadata.csv'

# df = pd.read_csv(csv_file)

# for index, row in df.iterrows():
#     PName = row['Player'].split(" ")
#     FName = PName[0]
#     LName = PName[1]
#     ptsAvg = row['PTS']
#     rebAvg = row['TRB']
#     assistAvg = row['AST']
#     blkAvg = row['BLK']
#     stlAvg = row['STL']

#     with cnxn.cursor() as cursor:
#         sql = """
#             DECLARE @OutputStatsID INT;
#             EXEC AddStats = @FName=?, @LName=?, @PointsAvg=?, @AssistsAvg=?, @ReboundsAvg=?, @StealsAvg=?, @BlocksAvg=?, @StatsID=@OutputStatsID OUTPUT;
#             SELECT @OutputStatsID
#             """
            
#         # Execute the stored procedure and get the output
#     # Prepare and execute the stored procedure with an OUTPUT parameter
#         cursor.execute("""
#             DECLARE @OutputStatsID INT;
#             EXEC AddStats @FName=?, @LName=?, @PointsAvg=?, @AssistsAvg=?, @ReboundsAvg=?, @StealsAvg=?, @BlocksAvg=?, @StatsID=@OutputStatsID OUTPUT;
#             INSERT INTO #TempStatsID (StatsID) VALUES (@OutputStatsID);
#             """, (FName, LName, ptsAvg, assistAvg, rebAvg, stlAvg, blkAvg))

#         # Retrieve the output parameter from the temporary table
#         cursor.execute("SELECT StatsID FROM #TempStatsID")
#         StatsID = cursor.fetchone()[0]
#         print("StatsID:", StatsID)
#         cursor.execute("EXEC ADDPLAYER ?, ?, ?, ?", FName, LName, None, StatsID)
#         cnxn.commit()

        


# cnxn.close()