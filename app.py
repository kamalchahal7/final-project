import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session, jsonify, send_from_directory
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

from datetime import datetime
import pytz
utc_time = datetime.now(pytz.timezone('UTC'))
est_time = utc_time.astimezone(pytz.timezone('US/Eastern'))

from functions import lookup, search, find, date_formatter

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

