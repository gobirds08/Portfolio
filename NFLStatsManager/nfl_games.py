import requests
from datetime import datetime
import psycopg2

season = "2024-2025"

DB_CONFIG = {
    "database": "nfl_stats_manager",
    "host": "localhost",
    "user": "postgres",
    "password": "cmpsc431w08!",
    "port": "5432"
}

def fetch_nfl_games(api_key):
    headers = {"Ocp-Apim-Subscription-Key": api_key}
    response = requests.get("https://api.sportsdata.io/v3/nfl/stats/json/ScoresFinal/2024", headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        print("Error fetching data:", response.status_code, response.text)
        return []
    
def fetch_player_stats_from_game(api_key, week, hometeam):
    headers = {"Ocp-Apim-Subscription-Key": api_key}
    response = requests.get(f"https://api.sportsdata.io/v3/nfl/stats/json/BoxScoreByTeamFinal/2024/{week}/{hometeam}", headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        print("Error fetching data:", response.status_code, response.text)
        return []
    
    
def process_game(data):
    games = []
    for game in data:
        week = game["Week"]
        if int(week) > 13:
            continue
        gid = int(game["GameKey"])
        game_date = datetime.strptime(game["Date"].split("T")[0], "%Y-%m-%d")
        home_team = game["HomeTeam"]
        home_tid = map_team_to_int(game["HomeTeam"])
        away_tid = map_team_to_int(game["AwayTeam"])
        home_score = int(game["HomeScore"])
        away_score = int(game["AwayScore"])
        games.append([gid, week, game_date, home_team, home_tid, away_tid, home_score, away_score])
    return games



def process_game_stats(game_data, hometeam, home_points, away_points, gid, home_tid, away_tid, game_date):
    all_player_stats = {}
    #        points, takeaways, yards
    total_stats = {"home": [home_points, 0, 0], "away": [away_points, 0, 0]}
    player_data = game_data["PlayerGames"]
    for player in player_data:
        pid = player["PlayerID"]
        team = player["Team"]
        pass_yds = int(player["PassingYards"])
        rush_yds = int(player["RushingYards"])
        rec_yds = int(player["ReceivingYards"])
        receptions = int(player["Receptions"])
        ints = int(player["Interceptions"])
        fumbles = int(player["FumblesLost"])
        ints_thrown = int(player["PassingInterceptions"])
        rec_tds = int(player["ReceivingTouchdowns"])
        rush_tds = int(player["RushingTouchdowns"])
        pass_tds = int(player["PassingTouchdowns"])
        tackles = int(player["SoloTackles"])
        sacks = int(player["Sacks"])
        if pass_yds + rec_yds + rush_yds + receptions + ints + fumbles + ints_thrown + rec_tds + rush_tds + pass_tds + tackles + sacks == 0:
            continue
        total_stats["home" if team == hometeam else "away"][2] += rush_yds + rec_yds
        total_stats["home" if team == hometeam else "away"][1] += fumbles + ints_thrown
        all_player_stats[pid] = [pass_yds, rush_yds, rec_yds, receptions, ints, fumbles, ints_thrown, rec_tds, rush_tds, pass_tds, tackles, sacks]
    

    connection = psycopg2.connect(**DB_CONFIG)
    cursor = connection.cursor()

    cursor.execute("BEGIN;")
    # add game 

    query = """
            INSERT INTO game (gid, home_tid, away_tid, date, season)
            VALUES (%s, %s, %s, %s, %s);
            """
    values = (gid, home_tid, away_tid, game_date, season)

    cursor.execute(query, values)

    # add team stats for both teams
    query = """
            INSERT INTO team_stats (tid, gid, yds, points, takeaways)
            VALUES (%s, %s, %s, %s, %s);
            """
    values = (home_tid, gid, total_stats["home"][2], total_stats["home"][0], total_stats["home"][1])

    cursor.execute(query, values)

    values = (away_tid, gid, total_stats["away"][2], total_stats["away"][0], total_stats["away"][1])

    cursor.execute(query, values)

    # loop through player stats dict
    query = """
            INSERT INTO player_stats (pid, gid, pass_yds, rush_yds, rec_yds, receptions, ints, fumbles, ints_thrown, rec_tds, rush_tds, pass_tds, tackles, sacks)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
            """
  
    for player in all_player_stats:
        query = "SELECT EXISTS (SELECT 1 FROM player WHERE pid = %s);"

        cursor.execute(query, (player,))

        exists = cursor.fetchone()[0]
        if not exists:
            continue

        query = """
            INSERT INTO player_stats (pid, gid, pass_yds, rush_yds, rec_yds, receptions, ints, fumbles, ints_thrown, rec_tds, rush_tds, pass_tds, tackles, sacks)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
            """

        values = (player, gid, all_player_stats[player][0], all_player_stats[player][1], all_player_stats[player][2], all_player_stats[player][3], all_player_stats[player][4], all_player_stats[player][5], all_player_stats[player][6], all_player_stats[player][7], all_player_stats[player][8], all_player_stats[player][9], all_player_stats[player][10], all_player_stats[player][11])
        
        cursor.execute(query, values)



    connection.commit()
    print("Success")

    return

API_KEY = "c9e12e5c8b8c44ef8ee8e1af6a79613a"



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


if __name__ == '__main__':
    games_data = fetch_nfl_games(API_KEY)
    games = process_game(games_data)
    for game in games:
        print("Week: " + str(game[1]))
        game_data = fetch_player_stats_from_game(API_KEY, game[1], game[3])
        process_game_stats(game_data, game[3], game[6], game[7], game[0], game[4], game[5], game[2])
    print("Success")