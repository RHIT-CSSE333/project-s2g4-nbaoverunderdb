from flask import Flask, render_template, request, redirect, session, url_for, flash, jsonify
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user
import pyodbc
import bcrypt
import os
secret_key = os.urandom(24)

# Flask application setup
app = Flask(__name__)
app.secret_key = secret_key

# Flask-Login setup
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

# Database configuration
config = {
    'server': 'golem.csse.rose-hulman.edu',
    'database': 'NBAOverUnderDB',
    'username': 'nbaoverunderuser',
    'password': 'NBAPassword123'
}

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
        config['server'] + ';DATABASE=' + config['database'] + 
        ';UID=' + config['username'] + ';PWD=' + config['password'])

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
        cnxn.commit()
        return jsonify({'success': True, 'message': 'Player deleted successfully'})
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
    # Fetch picks data from your database or data source
    # For demonstration, using a static list of picks
    picks = [
        # {'player': 'LeBron James', 'team': 'Lakers', 'playingAgainst': 'Warriors', 'overUnder': 'Over', 'baseline': 25}, use this format
        # Add more picks as needed
    ]
    return render_template('picks.html', picks=picks)

@app.route('/save-pick', methods=['POST'])
def save_pick():
    data = request.json
    # Implement logic to save the data to the database
    # For example:
    # save_to_database(data)
    success = True  # Set to False if saving fails
    return jsonify({'success': success})

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