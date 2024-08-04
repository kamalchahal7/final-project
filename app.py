import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session, jsonify
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

from datetime import datetime
import pytz
utc_time = datetime.now(pytz.timezone('UTC'))
est_time = utc_time.astimezone(pytz.timezone('US/Eastern'))

from data import lookup

# Configure application
app = Flask(__name__)

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///pokedex.db")

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
            return "Oops! Please Enter a Valid Pokemon Name or Pokedex #", 400
        pokedata = lookup(pokedata)

        if not pokedata:
            return "Oops! Please Enter a Valid Pokemon Name or Pokedex #", 400
        
        return jsonify(pokedata), 200
    else: 
        return jsonify({}), 200
