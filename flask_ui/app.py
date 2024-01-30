from flask import Flask, render_template, request, redirect, url_for, flash, jsonify
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

def register_logic(username, email, password):
    try:
        cnxn = get_db_connection()
        cursor = cnxn.cursor()

        salt = bcrypt.gensalt()
        hash = bcrypt.hashpw(password.encode('utf-8'), salt)

        cursor.execute("EXEC Register @Username=?, @Email=?, @PasswordSalt=?, @PasswordHash=?", 
                       username, email, salt.decode('utf-8'), hash.decode('utf-8'))
        cnxn.commit()

        return cursor.rowcount == 0
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