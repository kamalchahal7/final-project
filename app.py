import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session, jsonify, send_from_directory
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

from datetime import datetime, date
import pytz
utc_time = datetime.now(pytz.timezone('UTC'))
est_time = utc_time.astimezone(pytz.timezone('US/Eastern'))

from functions import lookup, search, find, date_formatter, date_shift, timezone

import re
pattern = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'

# Configure application
app = Flask(__name__)

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///accounts.db")

# Configure Images in a File Directory
image_folder = 'archive_new/'
images = os.listdir(image_folder)

@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "nocache no-store must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response

@app.route("/", methods = ["GET", "POST"])
def index():
    """ Shows Pokedex Info on Pokemon """
    if request.method == "POST":
        pokedata = request.form.get("pokedata")

        if not pokedata:
            return jsonify("No Results Found")
        
        pokedata = lookup(pokedata)

        print(pokedata)
        if not pokedata:
            return "Oops! Please Enter a Valid Pokemon Name or Pokedex #", 400
        return jsonify(pokedata), 200
    else: 
        return jsonify({}), 200

@app.route("/images/<filename>", methods = ["GET"])
def serve_image(filename):
    print(f"Serving file: {filename} from {image_folder}")
    return send_from_directory(image_folder, filename), 200

@app.route("/cards", methods = ["GET", "POST"])
def tcg():
    """ Shows Info/Pricing on Pokemon Cards """
    if request.method == "POST":
        pokecard = request.form.get("pokecard")

        if not pokecard:
            return "Oops! Please enter the name/id of a Valid Pokemon Card", 400
        pokecard = find(pokecard)
        if not pokecard:
            return "Oops! Please enter the name/id of a Valid Pokemon Card", 400
        
        print(pokecard[1])
        # pokecard = serialize(pokecard)
        return jsonify(pokecard), 200
    else: 
        return jsonify({}), 200
    
@app.route("/register", methods = ["GET", "POST"])
def register(): 
    """ Register User """
    if request.method == "POST":
        first_name = request.form.get("firstName")
        last_name = request.form.get("lastName")
        date_of_birth = request.form.get("birthDate")
        email = request.form.get("email")
        username = request.form.get("username")
        password = request.form.get("password")
        confirmation = request.form.get("confirmPassword")

        # MORE ENHANCED ERROR CHECKING (DO THE SAME AS THE FRONTEND)
        # also if you want add a gender option to the registration
        # checks if all has been provided or not
        if not first_name and last_name and date_of_birth and email and username and password and confirmation:
            print("Data Missing")
            return "Registration Incomplete", 400
        else: 
            print("Data Received Successfully")

        # checks that password and confirmation password are the same
        print(password)
        print(confirmation)
        print(date_of_birth)
        if not password == confirmation:
            return "Passwords don't match", 400
        
        # checks if email inputted is a valid email
        if not re.match(pattern, email):
            return "Invalid Email", 400
        
        # Check if username or email already exists
        print(username)
        print(email)
        users = db.execute("SELECT username, email FROM users")

        for user in users:
            if user['username'] == username:
                return "Username Already Taken", 400
            if user['email'] == email:
                return "Email is already Registered With an Existing Account", 400
        
        # register new user
        db.execute("INSERT INTO users (username, password_hash, email, first_name, last_name, date_of_birth) VALUES(?, ?, ?, ?, ?, ?)",
                   username, generate_password_hash(password), email, first_name, last_name, date_formatter(date_of_birth))
        # check 
        usernames = db.execute("SELECT username FROM users")
        emails = db.execute("SELECT email FROM users")

        return jsonify({}), 200

    else:
        usernames = [row['username'] for row in db.execute("SELECT username FROM users")]
        emails = [row['email'] for row in db.execute("SELECT email FROM users")]

        data = {
            "username": usernames,
            "email": emails
        }

        return jsonify(data), 200
    
@app.route("/login", methods = ["GET", "POST"])
def login(): 
    """ Login User """
    if request.method == "POST":
        account = request.form.get("account")
        password = request.form.get("password")
        
        # BUFF UP ERROR CHECKING (look at /change for more info)
        # checks if all has been provided or not
        if not account and password:
            return "Login Incomplete", 400
        else: 
            print("Data Received Successfully")

        # query database for username
        result = db.execute("SELECT id, password_hash FROM users WHERE email = ? OR username = ?", account, account)

        # checks if password matches password_hash
        if len(result) != 1 or not check_password_hash(
            result[0]["password_hash"], password):
            return "Password Incorrect", 400
        
        # assigns found user_id
        user_id = result[0]["id"]

        return jsonify(user_id), 200

    else:
        usernames = [row['username'] for row in db.execute("SELECT username FROM users")]
        emails = [row['email'] for row in db.execute("SELECT email FROM users")]

        data = {
            "username": usernames,
            "email": emails
        }

        return jsonify(data), 200
    
@app.route("/profile", methods = ["GET"])
def fetch(): 
    if request.method == "GET":
        user_id = request.args.get('user_id')

        data = db.execute("SELECT id, username, email, first_name, last_name, date_of_birth, registration_time_EST, collection FROM users WHERE id = ?", user_id)

        data[0]["date_of_birth"] = date_shift(data[0]["date_of_birth"])
        if not data:
            return "Invalid ID. Cannot fetch data", 400
        else:
            print(data)
            return jsonify(data), 200

@app.route("/change", methods = ["GET", "POST"])
def change(): 
    if request.method == "POST":
        user_id = request.form.get('user_id')
        email = request.form.get("email")
        password = request.form.get("password")
        new_password = request.form.get("newPassword")
        confirmation = request.form.get("confirmNewPassword")

        if not user_id:
            return "Invalid ID", 400
        
        if not email:
            return "Missing email", 400
        if not re.match(pattern, email):
            return "Invalid Email", 400
        emails = db.execute("SELECT email FROM users WHERE id = ?", user_id)
        if len(emails) != 1 or email != emails[0]["email"]:
            return "Incorrect email provided", 400
            
        if not password:
            return "Missing password", 400
        else:
            data = db.execute("SELECT * FROM users WHERE email = ? AND id = ?", email, user_id)
            if len(data) != 1 or not check_password_hash(
                data[0]["password_hash"], password):
                return "Password Incorrect", 400
        
        if not new_password:
            return "Missing new password", 400
        if password == new_password:
            return "New password must be different from orginal", 400
        
        if not confirmation:
            return "New password confirmation missing", 400
        if new_password != confirmation:
            return "New passwords don't match", 400
        
        db.execute("UPDATE users SET password_hash = ? WHERE email = ? AND id = ?", generate_password_hash(new_password), email, user_id)
        
        return jsonify({}), 200
    else:
        return jsonify({}), 200


@app.route("/personal", methods = ["GET", "POST"])
def personal_change(): 
    if request.method == "POST":
        user_id = request.form.get('user_id')
        print(user_id)
        password = request.form.get("password")
        first_name = request.form.get("firstName")
        last_name = request.form.get("lastName")
        date_of_birth = request.form.get("birthDate")
        email = request.form.get("email")
        username = request.form.get("username")

        initial_view = not (first_name or last_name or date_of_birth or email or username)
        if not user_id:
            return "Invalid ID", 400
        
        user_id = int(user_id)

        if not password and initial_view:
            return "Missing password", 400
        elif password and initial_view:
            data = db.execute("SELECT * FROM users WHERE id = ?", user_id)
            if len(data) != 1 or not check_password_hash(
                data[0]["password_hash"], password):
                return "Password Incorrect", 400
        if not initial_view:
            values = {}
            if first_name:
                values["first_name"] = first_name
            if last_name: 
                values["last_name"] = last_name
            if date_of_birth:
                date_of_birth = date_formatter(date_of_birth)
                if date_of_birth == str(timezone(date.today())):
                    date_of_birth = None
                values["date_of_birth"] = date_of_birth
            if email:
                if not re.match(pattern, email):
                    return "Invalid Email", 400
                emails = db.execute("SELECT email FROM users")
                for user in emails:
                    if user['email'] == email:
                        return "Email is already Registered With an Existing Account", 400
                    
                values["email"] = email
            if username: 
                usernames = db.execute("SELECT username FROM users")
                for user in usernames:
                    if user['username'] == username:
                            return "Username Already Taken", 400
                values["username"] = username

            for key, value in values.items():
                if value is not None and value != "":
                    db.execute("UPDATE users SET ? = ? WHERE id = ?", key, value, user_id)

        return jsonify ({}), 200
    else:
        usernames = [row['username'] for row in db.execute("SELECT username FROM users")]
        emails = [row['email'] for row in db.execute("SELECT email FROM users")]

        data = {
            "username": usernames,
            "email": emails
        }

        return jsonify(data), 200







