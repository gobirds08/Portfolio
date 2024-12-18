import requests
import psycopg2
from psycopg2.extras import execute_values
from queries.change_queries import get_max_id

API_URL = "https://api.sportsdata.io/v3/nfl/scores/json/PlayersByAvailable"
API_KEY = "c9e12e5c8b8c44ef8ee8e1af6a79613a"

DB_CONFIG = {
    "database": "nfl_stats_manager",
    "host": "localhost",
    "user": "postgres",
    "password": "cmpsc431w08!",
    "port": "5432"
}

def fetch_players():
    headers = {"Ocp-Apim-Subscription-Key": API_KEY}
    response = requests.get(API_URL, headers=headers)
    response.raise_for_status()
    return response.json()


def insert_players(players):
    connection = psycopg2.connect(**DB_CONFIG)
    cursor = connection.cursor()
    
    query = """
    INSERT INTO player (pid, fname, lname, birthdate, position, number, tid, retired)
    VALUES %s
    ON CONFLICT (pid) DO NOTHING;  -- Avoid duplicate inserts
    """
    
    values = []
    for player in players:
        pid = player.get("PlayerID")
        fname, lname = player["FirstName"], player["LastName"]
        birthdate = player["BirthDate"]
        position = map_position(player["Position"])
        number = player.get("Number") 
        tid = map_team_to_int(player["Team"]) 
        retired = False
        if number != None and position != "NA":
            if tid == -1:
                tid = None
            values.append((pid, fname, lname, birthdate, position, number, tid, retired))
    
    execute_values(cursor, query, values)
    connection.commit()
    cursor.close()
    connection.close()
    print(f"Inserted {len(values)} players into the database.")


def map_position(position):
    position_mapping = {
        "QB": "QB",
        "RB": "RB",
        "WR": "WR",
        "TE": "TE",
        "OT": "OT",
        "T": "OT",
        "OG": "OG",
        "G": "OG",
        "C": "C",
        "DE": "DE",
        "DL": "DE", 
        "DT": "DT",
        "NT": "DT", 
        "DE/LB": "DE",
        "LB": "LB",
        "OLB": "LB",
        "ILB": "LB",
        "DB": "DB",
        "CB": "DB",
        "FS": "DB",  
        "SS": "DB", 
        "K": "K",
        "P": "P",
        "KR": "NA",  
        "FB": "NA",  
        "LS": "NA",   
        "OL": "OT",
        "Unknown": "NA" 
    }
    return position_mapping.get(position.strip(), "NA")


def map_team_to_int(team):
    team_mapped = {
        "BUF": 1,
        "MIA": 2,
        "NE": 3,
        "NYJ": 4,
        "BAL": 5,
        "CIN": 6,
        "CLE": 7,
        "PIT": 8,
        "HOU": 9,
        "IND": 10,
        "JAX": 11,
        "TEN": 12,
        "DEN": 13,
        "KC": 14,
        "LV": 15,
        "LAC": 16,
        "DAL": 17,
        "NYG": 18,
        "PHI": 19,
        "WAS": 20,
        "CHI": 21,
        "DET": 22,
        "GB": 23,
        "MIN": 24,
        "ATL": 25,
        "CAR": 26,
        "NO": 27,
        "TB": 28,
        "ARI": 29,
        "LAR": 30,
        "SF": 31,
        "SEA": 32
    }

    return team_mapped.get(team, -1)


if __name__ == "__main__":
    try:
        print("Fetching player data from the API...")
        players = fetch_players()
        print("Inserting players into the database...")
        insert_players(players)
        print("Done!")
    except Exception as e:
        print(f"An error occurred: {e}")
