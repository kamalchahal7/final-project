import uuid
from cs50 import SQL
from pokemontcgsdk import Card, Set, Type, Supertype, Subtype, Rarity, RestClient, PokemonTcgException
from datetime import datetime
from time import time
import pytz
# import pokemontcgsdk


# Configure CS50 Library to use SQLite database
poke_db = SQL("sqlite:///pokedex.db")
db = SQL("sqlite:///accounts.db")

# Configure Pokemon TCG API
RestClient.configure('caf82b57-d30e-4832-a51b-0476d920d363')

def lookup(value):
    if value is None:
        return False
    try: 
        value = int(value)
    except ValueError:
        pokemon = poke_db.execute("SELECT * FROM pokemon WHERE REPLACE(REPLACE(name, '(', ''), ')', '') LIKE '%' || REPLACE(REPLACE(?, '(', ''), ')', '') || '%' COLLATE NOCASE", (value,))
        pokemon = sorted(pokemon, key=lambda x: x['name'].lower().find(value.lower()))
        return pokemon
    pokemon = poke_db.execute("SELECT * FROM pokemon WHERE pokedex_num = ?", (value,))
    return pokemon

def search():
    pokelist = poke_db.execute("SELECT id, pokedex_num, name FROM pokemon")
    return pokelist

def find(value):
    if value is None: 
        print("No value given")
        return None
    names = []

# cards = Card.find(f'{value}')
    try:
        cards = Card.where(q=f'name:{value}*')
        if not cards: 
            cards = Card.where(q=f'id:{value}')
            
    except PokemonTcgException:
        print("Failed to find pokemon card.")
        return None

    for card in cards:

        # Checks if Card has an Ancient Trait
        if card.ancientTrait:
            ancientTraitName = card.ancientTrait.name
            ancientTraitText = card.ancientTrait.text
        else: 
            ancientTraitName = None
            ancientTraitText = None

        # Checks if Card has an Ability
        if card.abilities:
            abilitiesName = []
            abilitiesText = []
            abilitiesType = []
            for ability in card.abilities:
                abilitiesName.append(ability.name)
                abilitiesText.append(ability.text)
                abilitiesType.append(ability.type)
        else:
            abilitiesName = None
            abilitiesText = None
            abilitiesType = None

        # Checks if Card has an Attack
        if card.attacks:
            attacksName = []
            attacksText = []
            attacksDamage = []
            attacksConvertedEnergyCost = []

            for attack in card.attacks:
                attacksCost = attack.cost
                attacksName.append(attack.name)
                attacksText.append(attack.text)
                attacksDamage.append(attack.damage)
                attacksConvertedEnergyCost.append(attack.convertedEnergyCost)
        else:
            attacksCost = None
            attacksName = None
            attacksText = None
            attacksDamage = None
            attacksConvertedEnergyCost = None

        # Checks if a Card has a Weakness
        if card.weaknesses:
            weaknessType = card.weaknesses[0].type
            weaknessValue = card.weaknesses[0].value
        else:
            weaknessType = None
            weaknessValue = None

        # Checks if a Card has a Resistance
        if card.resistances:
            resistanceType = card.resistances[0].type
            resistanceValue = card.resistances[0].value
        else:
            resistanceType = None
            resistanceValue = None

        # Checks the various available prices of a card
        if card.tcgplayer:
            priceTypes = {}
            pricesLow = {}
            pricesMid = {}
            pricesHigh = {}
            pricesMarket = {}
            pricesDirectLow = {}
            
            priceURL = card.tcgplayer.url
            updatedAt = card.tcgplayer.updatedAt

            if card.tcgplayer.prices:
                if card.tcgplayer.prices.normal:
                    x = "normal"
                    normalPrices = card.tcgplayer.prices.normal

                    priceTypes[x] = "Normal" 
                    pricesLow[x] = normalPrices.low
                    pricesMid[x] = normalPrices.mid
                    pricesHigh[x] = normalPrices.high
                    pricesMarket[x] = normalPrices.market
                    pricesDirectLow[x] = normalPrices.directLow

                if card.tcgplayer.prices.holofoil:
                    x = "holofoil"
                    holofoilPrices = card.tcgplayer.prices.holofoil

                    priceTypes[x] = "Holofoil" 
                    pricesLow[x] = holofoilPrices.low
                    pricesMid[x] = holofoilPrices.mid
                    pricesHigh[x] = holofoilPrices.high
                    pricesMarket[x] = holofoilPrices.market
                    pricesDirectLow[x] = holofoilPrices.directLow

                if card.tcgplayer.prices.reverseHolofoil:
                    x = "reverseHolofoil"
                    reverseHolofoilPrices = card.tcgplayer.prices.reverseHolofoil

                    priceTypes[x] = "Reverse Holofoil" 
                    pricesLow[x] = reverseHolofoilPrices.low
                    pricesMid[x] = reverseHolofoilPrices.mid
                    pricesHigh[x] = reverseHolofoilPrices.high
                    pricesMarket[x] = reverseHolofoilPrices.market
                    pricesDirectLow[x] = reverseHolofoilPrices.directLow

                if card.tcgplayer.prices.firstEditionHolofoil:
                    x = "firstEditionHolofoil"
                    firstEditionHolofoil = card.tcgplayer.prices.firstEditionHolofoil

                    priceTypes[x] = "First Edition Holofoil"
                    pricesLow[x] = firstEditionHolofoil.low
                    pricesMid[x] = firstEditionHolofoil.mid
                    pricesHigh[x] = firstEditionHolofoil.high
                    pricesMarket[x] = firstEditionHolofoil.market
                    pricesDirectLow[x] = firstEditionHolofoil.directLow

                if card.tcgplayer.prices.firstEditionNormal:
                    x = "firstEditionNormal"
                    firstEditionNormal = card.tcgplayer.prices.firstEditionNormal

                    priceTypes[x] = "First Edition Normal"
                    pricesLow[x] = firstEditionNormal.low
                    pricesMid[x] = firstEditionNormal.mid
                    pricesHigh[x] = firstEditionNormal.high
                    pricesMarket[x] = firstEditionNormal.market
                    pricesDirectLow[x] = firstEditionNormal.directLow
            
        
        names.append({
            "id": card.id, "name": card.name, "supertype": card.supertype, "subtypes": card.subtypes, "hp": card.hp, 
            "types": card.types, "evolvesFrom": card.evolvesFrom, "rules": card.rules, "ancientTraitName": ancientTraitName,
            "ancientTraitText": ancientTraitText, 
            "abilitiesName": abilitiesName,
            "abilitiesText": abilitiesText, "abilitiesType": abilitiesType, "attacksCost": attacksCost, 
            "attacksName": attacksName, "attacksText": attacksText, "attacksDamage": attacksDamage, 
            "attacksConvertedEnergyCost": attacksConvertedEnergyCost, "weaknessType": weaknessType, 
            "weaknessValue": weaknessValue,
            "resistanceType": resistanceType, "resistanceValue": resistanceValue,
            "retreatCost": card.retreatCost, "convertedRetreatCost": card.convertedRetreatCost, "number": card.number,
            "artist": card.artist, "rarity": card.rarity, "flavorText": card.flavorText, "nationalPokedexNumbers": card.nationalPokedexNumbers,
            "legalitiesStandard": card.legalities.standard, "legalitiesExpanded": card.legalities.expanded, 
            "legalitiesUnlimited": card.legalities.unlimited, "regulationMark": card.regulationMark, "lowImageURL": card.images.small, 
            "highImageURL": card.images.large, "tcgURL": priceURL, 
            "tcgUpdatedAt": updatedAt, "tcgPricesType": priceTypes, "tcgPricesLow": pricesLow, "tcgPricesMid": pricesMid,
            "tcgPricesHigh": pricesHigh, "tcgPricesMarket": pricesMarket, "tcgPricesDirectLow": pricesDirectLow,
            "setId": card.set.id, "setName": card.set.name, "setSeries": card.set.series, "setPrintedTotal": card.set.printedTotal, 
            "setTotal": card.set.total, "setLegalitiesStandard": card.set.legalities.standard, "setLegalitiesExpanded": card.set.legalities.expanded, 
            "setLegalitiesUnlimited": card.set.legalities.unlimited, "setPtcgoCode": card.set.ptcgoCode, "setReleaseDate": card.set.releaseDate, 
            "setUpdatedAt": card.set.updatedAt, "setImagesSymbol": card.set.images.symbol, "setImagesLogo": card.set.images.logo
        })
    return names

def date_formatter(time):
    time = time.strip().split()[0]
    return time

def date_shift(date):
    date_obj = datetime.strptime(date, "%Y-%m-%d")
    new_date_str = date_obj.strftime("%m/%d/%Y")
    return new_date_str

def timezone(time):
    date = datetime.combine(time, datetime.min.time())
    utc_zone = pytz.utc
    utc_time = date.astimezone(utc_zone)
    return utc_time.strftime("%Y-%m-%d")

def current_time():
    # Get the current local time
    current_time = time.localtime()

    # Check if the current time is in daylight savings
    is_dst = current_time.tm_isdst
def generate_uuid():
    full_uuid = uuid.uuid4()  # Generates a 128-bit UUID
    return full_uuid.int >> 64  # Use the upper 64 bits of the UUID

# retrieves all the set info, orders sets and checks whether sets were added or removed from collection
def set_call(valid_sets):
    # if not valid_sets:
    #     return None

    # Retrieve all sets
    set_data = Set.all()

    # Filter the sets to include only those with set_ids in valid_sets
    valid_set_data = [s for s in set_data if s.id in valid_sets]

    # Sort the sets by release date in descending order
    library = sorted(valid_set_data, key=lambda s: s.releaseDate, reverse=True)

    # Extract unique series names while preserving order
    set_series = []
    seen_series = set()
    for s in library:
        if hasattr(s, 'series') and s.series not in seen_series:
            set_series.append(s.series)
            seen_series.add(s.series)

    # Ensure "Other" is moved to the end of the list
    if "Other" in set_series: 
        set_series.remove("Other")
        set_series.append("Other")

    # Extract unique series names while preserving order
    set_series = []
    seen_series = set()

    for s in library:
        if hasattr(s, 'series') and s.series not in seen_series:
            set_series.append(s.series)
            seen_series.add(s.series)

    # Ensure "Other" is moved to the end of the list
    if "Other" in set_series: 
        set_series.remove("Other")
        set_series.append("Other")

    sets = {}
    for serie in set_series:
        set_details = [
            {
                'id': s.id,
                'name': s.name,
                'total': s.total,
                'printedTotal': s.printedTotal,
                'releaseDate': s.releaseDate,
                'logo': s.images.logo,
                'symbol': s.images.symbol
            }
            for s in library if s.series == serie
        ]
        sets[serie] = set_details
    return sets

# finds all the valid set ids that are associated with the user's collection
def find_set(user_id):
    card_ids = db.execute("SELECT card_id FROM collection WHERE user_id = ?", user_id)
    ids = []
    set_ids = []
    for id in card_ids:
        ids.append((id["card_id"]))
    
    for id in ids:
        card = Card.find(id)
        set_ids.append(card.set.id)
    
    # for _ in set_ids:
    #     print(_)
    return set_ids



# def serialize(obj):
#     if hasattr(obj, '__dict__'):
#         return obj.__dict__
#     elif isinstance(obj, list):
#         return [serialize(i) for i in obj]
#     elif isinstance(obj, dict):
#         return {k: serialize(v) for k, v in obj.items()}
#     else:
#         return obj
    
# def find(value):
#     if value is None: 
#         print("No value given")
#         return None
#     try:
#         cards = Card.where(q=f'name:{value}* supertype:pokemon')
#     except PokemonTcgException:
#         print("Failed to find pokemon card.")
#         return None
#     return cards

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