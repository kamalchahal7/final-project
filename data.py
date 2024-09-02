import sqlite3
import csv

csv_file = 'pokemon.csv'
sql_file = 'accounts.db'

conn = sqlite3.connect(sql_file)
cursor = conn.cursor()

cursor.execute("""
CREATE TABLE IF NOT EXISTS pokemon (
    id INTEGER PRIMARY KEY UNIQUE NOT NULL,
    pokedex_num INTEGER NOT NULL,
    name TEXT NOT NULL, 
    jap_name TEXT NOT NULL,
    generation INTEGER NOT NULL,       
    status TEXT NOT NULL,
    species TEXT NOT NULL,
    type_num INTEGER NOT NULL,
    type_1 TEXT NOT NULL,
    type_2 TEXT,
    height_m NUMERIC NOT NULL,
    weight_kg NUMERIC,
    abilities_num INTEGER NOT NULL,
    ability_1 TEXT NOT NULL,
    ability_2 TEXT,
    ability_hidden TEXT,
    stat_total INTEGER NOT NULL,
    hp INTEGER NOT NULL,
    attack INTEGER NOT NULL,
    defense INTEGER NOT NULL,
    sp_attack INTEGER NOT NULL,
    sp_defense INTEGER NOT NULL,
    speed INTEGER NOT NULL,
    catch_rate INTEGER,
    base_friendship INTEGER,
    base_exp INTEGER,
    growth_rate TEXT,
    egg_type_num INTEGER NOT NULL,
    egg_type_1 TEXT,
    egg_type_2 TEXT,
    percent_male NUMERIC,
    egg_cycles INTEGER,
    against_normal NUMERIC NOT NULL,
    against_fire NUMERIC NOT NULL,
    against_water NUMERIC NOT NULL,
    against_electric NUMERIC NOT NULL,
    against_grass NUMERIC NOT NULL,
    against_ice NUMERIC NOT NULL,   
    against_fight NUMERIC NOT NULL,
    against_poison NUMERIC NOT NULL,
    against_ground NUMERIC NOT NULL,
    against_flying NUMERIC NOT NULL,
    against_psychic NUMERIC NOT NULL,
    against_bug NUMERIC NOT NULL,
    against_rock NUMERIC NOT NULL,
    against_ghost NUMERIC NOT NULL,
    against_dragon NUMERIC NOT NULL,
    against_dark NUMERIC NOT NULL,
    against_steel NUMERIC NOT NULL,
    against_fairy NUMERIC NOT NULL
);
               """)

with open(csv_file, 'r') as file:
    reader = csv.DictReader(file)
    rows = [(int(row['id']), int(row['pokedex_num']), row['name'], row['jap_name'], int(row['generation']), 
             row['status'], row['species'], int(row['type_num']), row['type_1'], row.get('type_2'), 
             float(row['height_m']), float(row['weight_kg']) if row['weight_kg'] else None, int(row['abilities_num']), row['ability_1'], 
             row.get('ability_2'), row['ability_hidden'], int(row['stat_total']), int(row['hp']), int(row['attack']), 
             int(row['defense']), int(row['sp_attack']), int(row['sp_defense']), int(row['speed']), 
             int(row['catch_rate']) if row['catch_rate'] else None, int(row['base_friendship']) if row['base_friendship'] else None, int(row['base_exp']) if row['base_exp'] else None, row.get('growth_rate'), 
             int(row['egg_type_num']), row.get('egg_type_1'), row.get('egg_type_2'), 
             float(row['percent_male']) if row['percent_male'] else None, int(row['egg_cycles']) if row['egg_cycles'] else None, float(row['against_normal']), 
             float(row['against_fire']), float(row['against_water']), float(row['against_electric']), 
             float(row['against_grass']), float(row['against_ice']), float(row['against_fight']), float(row['against_poison']), 
             float(row['against_ground']), float(row['against_flying']), float(row['against_psychic']), 
             float(row['against_bug']), float(row['against_rock']), float(row['against_ghost']), float(row['against_dragon']), 
             float(row['against_dark']), float(row['against_steel']), float(row['against_fairy'])) for row in reader]
    # if you want to change the types then 

cursor.executemany("""
                    INSERT INTO pokemon (id, pokedex_num, name, jap_name, generation, status, species, type_num, type_1, type_2, height_m, weight_kg, abilities_num, ability_1, ability_2, ability_hidden, stat_total, hp, attack, defense, sp_attack, sp_defense, speed, catch_rate, 
                    base_friendship, base_exp, growth_rate, egg_type_num, egg_type_1, egg_type_2, percent_male, egg_cycles, against_normal, against_fire, against_water, against_electric, against_grass, against_ice, against_fight, against_poison, against_ground, 
                    against_flying, against_psychic, against_bug, against_rock, against_ghost, against_dragon, against_dark, against_steel, against_fairy) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
                    , ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                   """, rows)

conn.commit()
conn.close() 

print('Data Imported Sucessfully')