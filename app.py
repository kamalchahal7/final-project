import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session, jsonify, send_from_directory
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

from datetime import datetime
import pytz
utc_time = datetime.now(pytz.timezone('UTC'))
est_time = utc_time.astimezone(pytz.timezone('US/Eastern'))

from functions import lookup, search, find

# Configure application
app = Flask(__name__)

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///pokedex.db")

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
        
        print(pokecard[9])
        # pokecard = serialize(pokecard)
        return jsonify(pokecard), 200
    else: 
        return jsonify({}), 200

