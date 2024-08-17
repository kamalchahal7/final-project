from cs50 import SQL
from pokemontcgsdk import Card, Set, Type, Supertype, Subtype, Rarity, RestClient
# import pokemontcgsdk

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///pokedex.db")

# Configure Pokemon TCG API
RestClient.configure('caf82b57-d30e-4832-a51b-0476d920d363')

def lookup(value):
    if value is None:
        return False
    try: 
        value = int(value)
    except ValueError:
        pokemon = db.execute("SELECT * FROM pokemon WHERE REPLACE(REPLACE(name, '(', ''), ')', '') LIKE '%' || REPLACE(REPLACE(?, '(', ''), ')', '') || '%' COLLATE NOCASE", (value,))
        pokemon = sorted(pokemon, key=lambda x: x['name'].lower().find(value.lower()))
        return pokemon
    pokemon = db.execute("SELECT * FROM pokemon WHERE pokedex_num = ?", (value,))
    return pokemon

def search():
    pokelist = db.execute("SELECT id, pokedex_num, name FROM pokemon")
    return pokelist

def find(value):
    if value is None: 
        return False
    names = []
    cards = Card.where(q=f'*name:{value}* supertype:pokemon')
    for card in cards:
        names.append(card.id)
        names.append(card.name)
        names.append(card.set.name)
    return names

# export POKEMONTCG_IO_API_KEY='caf82b57-d30e-4832-a51b-0476d920d363'


# def lookup(symbol):
#     """Look up quote for symbol."""

#     # Prepare API request
#     symbol = symbol.upper()
#     end = datetime.datetime.now(pytz.timezone("US/Eastern"))
#     start = end - datetime.timedelta(days=7)

#     # Yahoo Finance API
#     url = (
#         f"https://query1.finance.yahoo.com/v7/finance/download/{urllib.parse.quote_plus(symbol)}"
#         f"?period1={int(start.timestamp())}"
#         f"&period2={int(end.timestamp())}"
#         f"&interval=1d&events=history&includeAdjustedClose=true"
#     )

#     # Query API
#     try:
#         response = requests.get(
#             url,
#             cookies={"session": str(uuid.uuid4())},
#             headers={"Accept": "*/*", "User-Agent": request.headers.get("User-Agent")},
#         )
#         response.raise_for_status()

#         # CSV header: Date,Open,High,Low,Close,Adj Close,Volume
#         quotes = list(csv.DictReader(response.content.decode("utf-8").splitlines()))
#         price = round(float(quotes[-1]["Adj Close"]), 2)
#         return {"price": price, "symbol": symbol}
#     except (KeyError, IndexError, requests.RequestException, ValueError):
#         return None