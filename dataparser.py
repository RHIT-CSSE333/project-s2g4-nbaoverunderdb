import pandas as pd
import pyodbc

server = 'your_server'
database = 'NBAOverUnderDB'
username = 'nbaoverunderuser'
password = 'NBAPassword123'
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=' +
                      server+';DATABASE='+database+';UID='+username+';PWD=' + password)

csv_file = 'path/to/your/csvfile.csv'

df = pd.read_csv(nbadata.csv)

for index, row in df.iterrows():
    home_team_name = row['HomeTeam']
    away_team_name = row['AwayTeam']

    with cnxn.cursor() as cursor:
        cursor.execute("EXEC InsertGameByTeamNames ?, ?", home_team_name, away_team_name)
        cnxn.commit()

cnxn.close()