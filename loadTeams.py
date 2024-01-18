import pandas as pd
import pyodbc

server = 'golem.csse.rose-hulman.edu'
database = 'NBAOverUnderDB'
username = 'nbaoverunderuser'
password = 'NBAPassword123'
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=' +
                      server+';DATABASE='+database+';UID='+username+';PWD=' + password)

csv_file = 'teams.csv'

df = pd.read_csv(csv_file)

for index, row in df.iterrows():
    team_name = row["name"]

    with cnxn.cursor() as cursor:
        cursor.execute("EXEC InsertTeam ?", team_name)
        cnxn.commit()

cnxn.close()