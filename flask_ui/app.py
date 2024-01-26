from flask import Flask, render_template, jsonify, request   
import pyodbc

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/data/players')
def get_team_data():
    return render_template('/data/nbadata.csv')

@app.route('/data/teams')
def get_player_data():
    return render_template('/data/teams.csv')

@app.route('/execute-script', methods=['POST'])
def execute_script():
    # Extract data from the request
    data = request.json
    player = data.get('player')
    homeAway = data.get('homeAway')
    playingAgainst = data.get('playingAgainst')
    stat = data.get('statistic')
    baseline = float(data.get('baseline'))

    # Your prediction logic here using the extracted data
    prediction = run_prediction(player, homeAway, playingAgainst, stat, baseline)  # Adjust with your function

    if prediction:
        if float(prediction) > baseline:
            prediction = f"Over (Predicting {prediction} {stat})"
        else:
            prediction = f"Under (Predicting {prediction} {stat})"
    else:
        prediction = f"Error Creating Prediction. Please try again"

    return jsonify({'result': prediction})

def run_prediction(player, homeAway, playingAgainst, stat, baseline):
    print('Running prediction...')

    # Split the player name into first and last name
    first_name, last_name = player.split(' ', 1)

    # Call the stored procedure and get the stat
    player_stat = call_find_player_stat(first_name, last_name, stat)

    if player_stat is None:
        print("No stat found for player:", player)
        return False
    else:
        print(f"{stat} for {player}: {player_stat[0][0]}")
        return player_stat[0][0]

    

def call_find_player_stat(first_name, last_name, stat):
    # Database connection parameters
    server = 'golem.csse.rose-hulman.edu'
    database = 'NBAOverUnderDB'
    username = 'nbaoverunderuser'
    password = 'NBAPassword123'
    cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=' +
                          server + ';DATABASE=' + database + ';UID=' +
                          username + ';PWD=' + password)

    cursor = cnxn.cursor()
    try:
        # Calling the stored procedure
        cursor.execute("EXEC dbo.FindPlayerStat ?, ?, ?", first_name, last_name, stat)
        result = cursor.fetchall()

    except Exception as e:  # Catches any exception and stores it in variable 'e'
        print("An error occurred:", e)
        result = None

    finally:
        cursor.close()  # Ensure the cursor is closed regardless of success or failure

    # You can now use the 'result' variable outside the try-except block
    return result

if __name__ == '__main__':
    app.run(debug=True)