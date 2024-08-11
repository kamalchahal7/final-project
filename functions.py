from cs50 import SQL

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///pokedex.db")

def lookup(value):
    pokemon = db.execute("SELECT * FROM pokemon WHERE name LIKE '%' || ? || '%' COLLATE NOCASE", (value,))
    if not pokemon:
        try: 
            value = int(value)
        except ValueError:
            return False
        pokemon = db.execute("SELECT * FROM pokemon WHERE pokedex_num = ?", (value,))
        if not pokemon:
            return False
    return pokemon

def search():
    pokelist = db.execute("SELECT id, pokedex_num, name FROM pokemon")
    return pokelist