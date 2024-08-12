from cs50 import SQL

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///pokedex.db")

def lookup(value):
    if value is None:
        return False
    try: 
        value = int(value)
    except ValueError:
        pokemon = db.execute("SELECT * FROM pokemon WHERE REPLACE(REPLACE(name, '(', ''), ')', '') LIKE '%' || REPLACE(REPLACE(?, '(', ''), ')', '') || '%' COLLATE NOCASE", (value,))
        return pokemon
    pokemon = db.execute("SELECT * FROM pokemon WHERE pokedex_num = ?", (value,))
    return pokemon

def search():
    pokelist = db.execute("SELECT id, pokedex_num, name FROM pokemon")
    return pokelist