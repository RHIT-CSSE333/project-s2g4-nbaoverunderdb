from flask import Flask, render_template, request, redirect, session, url_for, flash, jsonify
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user
import pyodbc
import bcrypt
import os
from dotenv import load_dotenv
import base64 
load_dotenv()

encoded_bytes = os.getenv('FLASK_Password').encode("ascii") 
  
decoded_bytes = base64.b64decode(encoded_bytes) 
decoded_password = decoded_bytes.decode("ascii") 
  

config = {
    "SERVER": os.getenv('FLASK_Server'),
    "DATABASE_NAME": os.getenv('FLASK_DatabaseName'),
    "USERNAME": os.getenv('FLASK_Username'),
    "PASSWORD": decoded_password
}

secret_key = os.urandom(24)

# Flask application setup
app = Flask(__name__)
app.secret_key = secret_key

# Flask-Login setup
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'


# User model for Flask-Login
class User(UserMixin):
    def __init__(self, username):
        self.id = username

@login_manager.user_loader
def load_user(username):
    return User(username)

def get_db_connection():
    return pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};SERVER=' +
        config['SERVER'] + ';DATABASE=' + config['DATABASE_NAME'] + 
        ';UID=' + config['USERNAME'] + ';PWD=' + config['PASSWORD'])

def login_logic(username, password):
    try:
        cnxn = get_db_connection()
        cursor = cnxn.cursor()

        cursor.execute("EXEC LoginQuery @Username=?", username)
        result = cursor.fetchone()


        if result:
            password_salt = result.PasswordSalt.encode('utf-8')
            password_hash = result.PasswordHash.encode('utf-8')
            new_hashed = bcrypt.hashpw(password.encode('utf-8'), password_salt)
            return password_hash == new_hashed
            # print(new_hashed)
            # print(password_hash)
            # return bcrypt.checkpw(new_hashed, password_hash)
        return False
    except Exception as e:
        print("Error:", e)
        return False
    finally:
        cnxn.close()

@app.route('/addFavoriteTeam', methods=['POST'])
def add_favorite_team():
    
    if 'username' not in session:
        return jsonify({'success': False, 'message': 'User not logged in'})

    team_name = request.json['teamName']
    user_name = session['username']
    cnxn = get_db_connection()
    
    cursor = cnxn.cursor()
    try:
        cursor.execute("EXEC AddFavoriteTeam @TeamName = ?, @UserName = ?", team_name, user_name)
        cnxn.commit()
        return jsonify({'success': True, 'message': 'Team added successfully'})
    except Exception as e:
        return jsonify({'success': False, 'message': 'Error adding team', 'error': str(e)})
    finally:
        cursor.close()

@app.route('/addFavoritePlayer', methods=['POST'])
def add_favorite_player():
    if 'username' not in session:
        return jsonify({'success': False, 'message': 'User not logged in'})
    
    first_name = request.json['firstName']
    last_name = request.json['lastName']
    user_name = session['username']
    cnxn = get_db_connection()
    
    cursor = cnxn.cursor()
    try:
        cursor.execute("EXEC AddFavoritePlayer @PlayerFName = ?, @PlayerLName = ?, @UserName = ?", first_name, last_name, user_name)
        cnxn.commit()
        return jsonify({'success': True, 'message': 'Player added successfully'})
    except Exception as e:
        return jsonify({'success': False, 'message': 'Error adding player', 'error': str(e)})
    finally:
        cursor.close()
        
def register_logic(username, email, password):
    try:
        cnxn = get_db_connection()
        cursor = cnxn.cursor()

        salt = bcrypt.gensalt()
        hash = bcrypt.hashpw(password.encode('utf-8'), salt)

        cursor.execute("EXEC Register @Username=?, @Email=?, @PasswordSalt=?, @PasswordHash=?", 
                       username, email, salt.decode('utf-8'), hash.decode('utf-8'))
        user = cursor.fetchone()
        cnxn.commit()

        # TODO: Find a better way to check for successfull registration (Maybe use js function and get return value)
        if (user != None):
            return True
        else:
            return False
    except Exception as e:
        print("Error:", e)
        return False
    finally:
        cnxn.close()

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if login_logic(username, password):
            session['username'] = username
            user = User(username)
            login_user(user)
            return redirect(url_for('home'))
        else:
            flash('Invalid username or password')
    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        if register_logic(username, email, password):
            return redirect(url_for('login'))
        else:
            flash('Registration failed')
    return render_template('register.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

@app.route('/')
@login_required
def home():
    return render_template('index.html')

@app.route('/favorite')
@login_required
def favorite():
    return render_template('favorite.html')

@app.route('/data/teams')
def get_team_data():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("EXEC GetTeamNames")
    players = [str(row[0]) for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    return jsonify(players)

@app.route('/data/players')
def get_player_data():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("EXEC GetPlayerNames")
    players = [f"{row[0]} {row[1]}" for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    return jsonify(players)



@app.route('/data/favteams')
@login_required
def get_fav_team_data():
    conn = get_db_connection()
    cursor = conn.cursor()
    username = session['username']
    cursor.execute("EXEC GetFavTeamNames @Username = ?", username)
    teams = [str(row[0]) for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    return jsonify(teams)

@app.route('/data/favplayers')
@login_required
def get_fav_player_data():
    conn = get_db_connection()
    cursor = conn.cursor()
    username = session['username']
    cursor.execute("EXEC GetFavPlayerNames @Username = ?", username)
    players = [f"{row[0]} {row[1]}" for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    return jsonify(players)

@app.route('/deleteFavoritePlayer', methods=['POST'])
@login_required
def delete_favorite_player():
    if 'username' not in session:
        return jsonify({'success': False, 'message': 'User not logged in'})

    data = request.json
    first_name = data['firstName']
    last_name = data['lastName']
    user_name = session['username']
    
    cnxn = get_db_connection()
    cursor = cnxn.cursor()
    try:
        cursor.execute("EXEC DeleteFavoritePlayer @PlayerFName = ?, @PlayerLName = ?, @UserName = ?", first_name, last_name, user_name)
        result = cursor.fetchall()
        cnxn.commit()
        if result == 0:
            return jsonify({'success': True, 'message': 'Player deleted successfully'})
        else:
            return jsonify({'success': False, 'message': 'Error deleting player'})
    except Exception as e:
        return jsonify({'success': False, 'message': 'Error deleting player', 'error': str(e)})
    finally:
        cursor.close()



@app.route('/data/get_player_stats', methods=['POST'])
def get_fav_player_stats():
    conn = get_db_connection()
    cursor = conn.cursor()
    data = request.json
    players = data['favplayers']  # Expecting a list of players
    results = []

    for player_name in players:
        fullname = player_name.split(" ")
        firstname = fullname[0]
        lastname = fullname[1]

        try:
            cursor.execute("EXEC FindAllPlayerStats @First = ?, @Last = ?", firstname, lastname)
            player_stats = cursor.fetchall()

            # Assuming 'player_stats' is a list of tuples, each representing a player's stat row
            for stat in player_stats:
                # Example: Assuming 'stat' includes points, assists, etc., in known positions
                results.append({
                    "first_name": firstname,
                    "last_name": lastname,
                    "points": stat[2],  # Adjust these indices based on your actual stat positions
                    "assists": stat[3],
                    "rebounds": stat[4],
                    "blocks": stat[5],
                    "steals": stat[6],
                })
        except Exception as e:
            print(f"An error occurred while fetching stats for {firstname} {lastname}: {e}")
            # Handle error (maybe append an error message or skip)
    
    cursor.close()
    conn.close()
    return jsonify(results)

@app.route('/deleteFavoriteTeam', methods=['POST'])
@login_required
def delete_favorite_team():
    if 'username' not in session:
        return jsonify({'success': False, 'message': 'User not logged in'})

    data = request.json
    team_name = data['teamName']
    user_name = session['username']
    
    cnxn = get_db_connection()
    cursor = cnxn.cursor()
    try:
        print("here running well")
        cursor.execute("EXEC DeleteFavoriteTeam @TeamName = ?, @UserName = ?", team_name, user_name)
        result = cursor.fetchall()
        cnxn.commit()
        if result == 0:
            return jsonify({'success': True, 'message': 'Team deleted successfully'})
        else:
            return jsonify({'success': False, 'message': 'Error deleting team'})
    except Exception as e:
        return jsonify({'success': False, 'message': 'Error deleting team', 'error': str(e)})
    finally:
        cursor.close()


@app.route('/data/get_team_stats', methods=['POST'])
def get_fav_team_stats():
    conn = get_db_connection()
    cursor = conn.cursor()
    data = request.json
    teams = data['favteams']  # Expecting a list of players
    results = []

    for team_name in teams:
        # fullname = player_name.split(" ")
        # firstname = fullname[0]
        # lastname = fullname[1]

        try:
            cursor.execute("EXEC FindAllTeamStats @Name = ?", team_name)
            team_stats = cursor.fetchall()

            # Assuming 'player_stats' is a list of tuples, each representing a player's stat row
            for stat in team_stats:
                # Example: Assuming 'stat' includes points, assists, etc., in known positions
                results.append({
                    "name": team_name,
                    "points": stat[1],  # Adjust these indices based on your actual stat positions
                })
        except Exception as e:
            print(f"An error occurred while fetching stats for {team_name} : {e}")
            # Handle error (maybe append an error message or skip)
    
    cursor.close()
    conn.close()
    return jsonify(results)
               
# @app.route('/data/get_player_stats', methods=['POST'])
# def get_fav_player_stats():
#     conn = get_db_connection()
#     cursor = conn.cursor()
#     data = request.json
#     # print("look here")
#     # print(data)
#     players = data['favplayers']  # Expecting a list of players
#     results = []
#     # print("right here is players")
#     # print(players)
#     for ps in players:
#         fullname = ps.split(" ")
#         firstname = fullname[0]
#         lastname = fullname[1]
#         print("this is the first name")
#         # print(firstname)

#         player_result = {
#             cursor.execute("EXEC FindAllPlayerStats @First = ?, @Last = ?", firstname, lastname)
#             }
#         playerResults = cursor.fetchall()
#         print("player results")
#         print(results)
        
#         results.append(playerResults)
#     return jsonify(results)

@app.route('/picks')
@login_required
def view_picks():
    username = session['username']
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("EXEC dbo.GetPickDataByUsername @Username=?", username)
        picks_data = cursor.fetchall()

        picks = []
        for row in picks_data:
            playerName = None
            if(row.PlayerFirstName != None or row.PlayerLastName != None):
                playerName = f"{row.PlayerFirstName} {row.PlayerLastName}"
            picks.append({
                'player': playerName,  # Combining first and last names
                'team': row.TeamName,
                'playingAgainst': row.TeamAgainstName,
                'overUnder': 'Over' if row.Prediction == 1 else 'Under',  # Assuming 1 for Over, 0 for Under
                'baseline': row.Guess_Stat,  # Assuming 'Guess_Stat' column exists in your picks data
            })

    except Exception as e:
        print(f"Error fetching picks: {e}")
        picks = []  # Return an empty list in case of error

    finally:
        cursor.close()
        conn.close()

    return render_template('picks.html', picks=picks)

@app.route('/update-parlay/<parlay_id>', methods=['POST'])
@login_required
def update_parlay(parlay_id):
    data = request.json
    bet = data.get('bet')
    payout = data.get('payout')
    # Update the parlay in your database here
    username = session['username']
    conn = get_db_connection()
    cursor = conn.cursor()
    try: 
        cursor.execute("EXEC dbo.UpdateParlay @Username=?, @ParlayID=?, @bet=?, @payout=?", username, parlay_id, bet, payout)
        conn.commit()
        return jsonify({'message': 'Parlay updated successfully', 'id': parlay_id, 'bet': bet, 'payout': payout})
    except Exception as e:
        print(f"Error updating parlay details: {e}")
        return jsonify({'message': 'Could not update Parlay', 'id': parlay_id, 'bet': bet, 'payout': payout})
    finally:
        cursor.close()
        conn.close()

@app.route('/delete-parlay/<parlay_id>', methods=['POST'])
@login_required
def delete_parlay(parlay_id):
    username = session['username']
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("EXEC dbo.DeleteParlay @Username=?, @ParlayID=?", username, parlay_id)
        conn.commit()
        return jsonify({'message': 'Parlay deleted successfully', 'id': parlay_id})
    except Exception as e:
        return jsonify({'message': 'Could not delete Parlay', 'id': parlay_id,})
    finally:
        cursor.close()
        conn.close()



@app.route('/view-parlays')
@login_required
def view_parlays():
    parlays = []
    username = session['username']
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("EXEC dbo.GetUserParlayDetails @Username=?", username)
        current_parlay_id = None
        columns = [column[0] for column in cursor.description]  # Get column names
        for row in cursor:
            row_dict = dict(zip(columns, row))
            if row_dict['ParlayID'] != current_parlay_id:
                current_parlay_id = row_dict['ParlayID']
                parlays.append({
                    'ParlayID': row_dict['ParlayID'],
                    'Bet': row_dict['Bet'],
                    'Payout': row_dict['Payout'],
                    'Picks': []
                })
            parlays[-1]['Picks'].append({
                'PlayerName': row_dict['PlayerName'],
                'Team': row_dict['Team'],
                'OpposingTeam': row_dict['OpposingTeam'],
                'Prediction': 'Over' if row_dict["Prediction"] == 1 else 'Under',
                'Guess_Stat': row_dict['Guess_Stat']
            })
    except Exception as e:
        print(f"Error fetching parlay details: {e}")
        parlays = []  # Return an empty list in case of error
    return render_template('view-parlays.html', parlays=parlays)

@app.route('/parlays')
@login_required
def creat_parlay_view():
    username = session['username']
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("EXEC dbo.GetPickDataByUsername @Username=?", username)
        picks_data = cursor.fetchall()

        picks = []
        for row in picks_data:
            picks.append({
                'player': f"{row.PlayerFirstName} {row.PlayerLastName}",  # Combining first and last names
                'team': row.TeamName,
                'playingAgainst': row.TeamAgainstName,
                'overUnder': 'Over' if row.Prediction == 1 else 'Under',  # Assuming 1 for Over, 0 for Under
                'baseline': row.Guess_Stat,  # Assuming 'Guess_Stat' column exists in your picks data
                'id': row.id
            })

    except Exception as e:
        print(f"Error fetching picks: {e}")
        picks = []  # Return an empty list in case of error

    finally:
        cursor.close()
        conn.close()
        

    return render_template('parlays.html', picks=picks)

@app.route('/create-parlay', methods=['POST'])
def create_parlay():
    data = request.json
    bet_amount = data.get('betAmount')
    payout_amount = data.get('payoutAmount')
    selected_picks = data.get('picks')  # List of Pick IDs
    try: 
        conn = get_db_connection()
        cursor = conn.cursor()
        # Execute AddParlay stored procedure
        cursor.execute("EXEC dbo.AddParlay @Bet=?, @Payout=?", (bet_amount, payout_amount))
        cursor.execute("SELECT @@IDENTITY;")
        parlay_id = cursor.fetchval()
        username = session['username']

        # For each pick, associate it with the created parlay
        for pick_id in selected_picks:
            cursor.execute("EXEC dbo.PickisInParlay @PickID=?, @ParlayID=?", (pick_id, parlay_id))

        cursor.execute("""
        EXEC dbo.AddUserParlay
            @Username=?,
            @ParlayID=?
            """, (username, parlay_id))

        conn.commit()  # Commit the transaction
        return jsonify({'success': True})

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'success': False, 'error': str(e)})

    finally:
        cursor.close()
        conn.close()

@app.route('/save-pick', methods=['POST'])
def save_pick():
    data = request.json
    try:
        conn = get_db_connection()  # Ensure this function returns a valid connection
        cursor = conn.cursor()

        prediction = 1 if "over" in data["prediction"].lower() else 0
        first = last = None
        if data.get("player"):
            name = data["player"].split(" ")
            first = name[0]
            last = name[1] if len(name) > 1 else None

        team_name = data.get('team')
        team_against_name = data['playingAgainst']
        guess_stat = data['statistic']

        # Execute stored procedure without attempting to capture output parameter
        cursor.execute("""
            EXEC dbo.AddPick 
                @Prediction=?, 
                @Team_Name=?, 
                @Player_First_Name=?, 
                @Player_Last_Name=?, 
                @Guess_Stat=?, 
                @Team_Against_Name=?;
        """, (prediction, team_name, first, last, guess_stat, team_against_name))

        # Optionally, fetch the last identity value inserted if needed
        cursor.execute("SELECT @@IDENTITY;")
        pick_id = cursor.fetchval()
        username = session['username']

        cursor.execute("""
        EXEC dbo.AddUserPick
            @Username=?,
            @PickID=?
            """, (username, pick_id))

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({'success': True})

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'success': False, 'error': str(e)})

@app.route('/execute-script', methods=['POST'])
def execute_script():
    # Extract data from the request
    try: 
        data = request.json
        playerTeam = data.get('playerTeam')
        player = data.get('player')
        homeAway = data.get('homeAway')
        playingAgainst = data.get('playingAgainst')
        stat = data.get('statistic')
        baseline = float(data.get('baseline'))

        # Your prediction logic here using the extracted data
        prediction = run_prediction(playerTeam, player, homeAway, playingAgainst, stat, baseline)  # Adjust with your function

        if prediction:
            if float(prediction) > baseline:
                prediction = f"Over (Predicting {prediction} {stat})"
            else:
                prediction = f"Under (Predicting {prediction} {stat})"
        else:
            prediction = f"Error Creating Prediction. Please try again"

        return jsonify({'result': prediction})
    except Exception as e:
        return jsonify({'result': "Error Creating Prediction. Please try again"})
    

def run_prediction(playerTeam, player, homeAway, playingAgainst, stat, baseline):
    if playerTeam == 'Player': # predict player
        print('Running player prediction...')
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
    else: # predict team
        print('Running team prediction...')
        # Call the stored procedure and get the stat
        team_stat = call_find_team_stat(player)

        if team_stat is None:
            print("No stat found for team:", player)
            return False
        else:
            print(f"{stat} for {player}: {team_stat[0][0]}")
            return team_stat[0][0]



def call_find_player_stat(first_name, last_name, stat):
    # Database connection parameters
    cnxn = get_db_connection();

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

def call_find_team_stat(team_name):
    # Database connection parameters
    cnxn = get_db_connection()

    cursor = cnxn.cursor()
    try:
        # Calling the stored procedure
        cursor.execute("EXEC dbo.FindTeamStat ?", team_name)
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