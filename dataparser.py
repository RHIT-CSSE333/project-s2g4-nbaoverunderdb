import pandas as pd
import pyodbc

server = 'golem.csse.rose-hulman.edu'
database = 'NBAOverUnderDB'
username = 'nbaoverunderuser'
password = 'NBAPassword123'
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=' +
                      server+';DATABASE='+database+';UID='+username+';PWD=' + password)

csv_file = 'nbadata.csv'

df = pd.read_csv(csv_file)

for index, row in df.iterrows():
    PName = row['Player'].split(" ")
    FName = PName[0]
    LName = PName[1]
    ptsAvg = row['PTS']
    rebAvg = row['TRB']
    assistAvg = row['AST']
    blkAvg = row['BLK']
    stlAvg = row['STL']

    with cnxn.cursor() as cursor:
        cursor.execute("EXEC @StatsID = AddStats ?,?, ?, ?, ?, ?, ?", FName, LName, ptsAvg, assistAvg, rebAvg, stlAvg, blkAvg)
        StatsID = cursor.fetchval()
        print(StatsID)
        cursor.execute("EXEC ADDPLAYER ?, ?, ?, ?", FName, LName, None, stat_id)
        cnxn.commit()

        


cnxn.close()