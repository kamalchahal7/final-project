import sqlite3
import csv

csv_file = 'pokemon.csv'
sql_file = 'pokedex.db'

conn = sqlite3.connect(sql_file)
cursor = conn.cursor()

with open(csv_file, 'r') as file:
    reader = csv.DictReader(file)

cursor.execute("""
    CREATE TABLE pokemon (
        abilities TEXT NOT NULL,
        against_bug NUMERIC NOT NULL,
        against_dark NUMERIC NOT NULL,
        against_dragon NUMERIC NOT NULL,
        against_electric NUMERIC NOT NULL,
        against_fairy NUMERIC NOT NULL,
        against_flight NUMERIC NOT NULL,
        against_fire NUMERIC NOT NULL,
        against_flying NUMERIC NOT NULL,
        against_ghost NUMERIC NOT NULL,
        against_grass NUMERIC NOT NULL,
        against_ground NUMERIC NOT NULL,
        against_ice NUMERIC NOT NULL,
        against_normal NUMERIC NOT NULL,
        against_poison NUMERIC NOT NULL,
        against_psychic NUMERIC NOT NULL,
        against_rock NUMERIC NOT NULL,
        against_steel NUMERIC NOT NULL,
        against_water NUMERIC NOT NULL,
        attack INTEGER NOT NULL,
        base_egg_steps INTEGER NOT NULL,
        base_happiness INTEGER NOT NULL,
        base_total INTEGER NOT NULL,
        capture_rate INTEGER NOT NULL, 
        classification TEXT NOT NULL,
        defense INTEGER NOT NULL,
        exp_growth INTEGER NOT NULL,
        height_m NUMERIC,
        hp INTEGER NOT NULL,
        jap_name TEXT NOT NULL,
        name TEXT NOT NULL,
        percent_male NUMERIC, 
        id INTEGER PRIMARY KEY,
        sp_attack INTEGER NOT NULL,
        sp_defense INTEGER NOT NULL,
        speed INTEGER NOT NULL,
        type1 TEXT NOT NULL,
        type2 TEXT,
        weight_kg NUMERIC,
        generation INTEGER NOT NULL,
        is_legendary INTEGER
    );
""")

print(reader)


