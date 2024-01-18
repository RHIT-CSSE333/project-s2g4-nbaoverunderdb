import pandas as pd
import pyodbc
from datetime import datetime

server = 'golem.csse.rose-hulman.edu'
database = 'NBAOverUnderDB'
username = 'nbaoverunderuser'
password = 'NBAPassword123'
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=' +
                      server+';DATABASE='+database+';UID='+username+';PWD=' + password)

csv_file = 'nbaScheduleData.csv'

df = pd.read_csv(csv_file)

for index, row in df.iterrows():
    home_team_name = row['Home/Neutral']
    away_team_name = row['Visitor/Neutral']
    date = row['Date']
    date_obj = datetime.strptime(date, "%a %b %d %Y")
    formatted_date = date_obj.strftime("%Y-%m-%d")

    with cnxn.cursor() as cursor:
        cursor.execute("EXEC InsertGameByTeamNames ?, ?, ?", home_team_name, away_team_name, formatted_date)
        cnxn.commit()

cnxn.close()