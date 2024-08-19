from cs50 import SQL
from pokemontcgsdk import Card, Set, Type, Supertype, Subtype, Rarity, RestClient, PokemonTcgException
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
        print("No value given")
        return None
    names = []

    try:
        cards = Card.where(q=f'name:{value}* supertype:pokemon')
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
            weaknessesType = []
            weaknessesValue = []
            for weakness in card.weaknesses:
                weaknessesType.append(weakness.type)
                weaknessesValue.append(weakness.value)
        else:
            weaknessesType = None
            weaknessesValue = None

        # Checks if a Card has a Resistance
        if card.resistances:
            resistancesType = []
            resistancesValue = []
            for resistance in card.resistances:
                resistancesType.append(resistance.type)
                resistancesValue.append(resistance.value)
        else:
            resistancesType = None
            resistancesValue = None

        # Checks the various available prices of a card
        if card.tcgplayer:
            priceTypes = []
            pricesLow = {}
            pricesMid = {}
            pricesHigh = {}
            pricesMarket = {}
            pricesDirectLow = {}
            
            priceURL = card.tcgplayer.url
            updatedAt = card.tcgplayer.updatedAt
            normalPrices = card.tcgplayer.prices.normal
            holofoilPrices = card.tcgplayer.prices.holofoil
            reverseHolofoilPrices = card.tcgplayer.prices.reverseHolofoil
            firstEditionHolofoil = card.tcgplayer.prices.firstEditionHolofoil
            firstEditionNormal = card.tcgplayer.prices.firstEditionNormal

            if normalPrices:
                priceTypes.append("normal")
                pricesLow["normal"] = normalPrices.low
                pricesMid["normal"] = normalPrices.mid
                pricesHigh["normal"] = normalPrices.high
                pricesMarket["normal"] = normalPrices.market
                pricesDirectLow["normal"] = normalPrices.directLow

            if holofoilPrices:
                priceTypes.append("holofoil")
                pricesLow["holofoil"] = holofoilPrices.low
                pricesMid["holofoil"] = holofoilPrices.mid
                pricesHigh["holofoil"] = holofoilPrices.high
                pricesMarket["holofoil"] = holofoilPrices.market
                pricesDirectLow["holofoil"] = holofoilPrices.directLow
            
            if reverseHolofoilPrices:
                priceTypes.append("reverseHolofoil")
                pricesLow["reverseHolofoil"] = reverseHolofoilPrices.low
                pricesMid["reverseHolofoil"] = reverseHolofoilPrices.mid
                pricesHigh["reverseHolofoil"] = reverseHolofoilPrices.high
                pricesMarket["reverseHolofoil"] = reverseHolofoilPrices.market
                pricesDirectLow["reverseHolofoil"] = reverseHolofoilPrices.directLow
            
            if firstEditionHolofoil:
                priceTypes.append("firstEditionHolofoil")
                pricesLow["firstEditionHolofoil"] = firstEditionHolofoil.low
                pricesMid["firstEditionHolofoil"] = firstEditionHolofoil.mid
                pricesHigh["firstEditionHolofoil"] = firstEditionHolofoil.high
                pricesMarket["firstEditionHolofoil"] = firstEditionHolofoil.market
                pricesDirectLow["firstEditionHolofoil"] = firstEditionHolofoil.directLow
            
            if firstEditionNormal:
                priceTypes.append("firstEditionNormal")
                pricesLow["firstEditionNormal"] = firstEditionNormal.low
                pricesMid["firstEditionNormal"] = firstEditionNormal.mid
                pricesHigh["firstEditionNormal"] = firstEditionNormal.high
                pricesMarket["firstEditionNormal"] = firstEditionNormal.market
                pricesDirectLow["firstEditionNormal"] = firstEditionNormal.directLow
        
        names.append({
            "id": card.id, "name": card.name, "supertype": card.supertype, "subtypes": card.subtypes, "hp": card.hp, 
            "types": card.types, "evolvesFrom": card.evolvesFrom, "rules": card.rules, "ancientTraitName": ancientTraitName,
            "ancientTraitText": ancientTraitText, 
            "abilitiesName": abilitiesName,
            "abilitiesText": abilitiesText, "abilitiesType": abilitiesType, "attacksCost": attacksCost, 
            "attacksName": attacksName, "attacksText": attacksText, "attacksDamage": attacksDamage, 
            "attacksConvertedEnergyCost": attacksConvertedEnergyCost, "weaknessesType": weaknessesType, 
            "weaknessesValue": weaknessesValue,
            "resistancesType": resistancesType, "resistancesValue": resistancesValue,
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