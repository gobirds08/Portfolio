import psycopg2
import json
from datetime import datetime 
from copy import deepcopy
from tabulate import tabulate
from colorama import Fore, Style


def connect():
    with open('config.json', 'r') as file:
        config = json.load(file)

    db_name = config['db']['name']
    host = config['db']['host']
    user = config['db']['user']
    password = config['db']['password']
    port = config['db']['port']

    connection = psycopg2.connect(database=db_name, user=user, password=password, host=host, port=port)

    return connection


def create_or_end_season(end):
    connection = connect()
    cursor = connection.cursor()
    if end:
        season = input("What is the season you want to set to inactive? (YYYY-YYYY) ")
        query = """
                UPDATE season
                SET status = %s
                WHERE year = %s
                """
        values = (season, 'inactive')
    else:
        season = input("What is the season? (YYYY-YYYY) ")
        query = """
                INSERT INTO season (year, status)
                VALUES(%s, %s)
                """
        values = (season, 'active')
    
    try:
        cursor.execute(query, values)
        connection.commit()
        print(Fore.LIGHTGREEN_EX + "Success!", Style.RESET_ALL)
    except:
        if end:
            print(Fore.RED + "Failure! Issue stopped season from being set to inactive.", Style.RESET_ALL)
        else:
            print(Fore.RED + "Failure! Issue stopped season from being created.", Style.RESET_ALL)
    finally:
        cursor.close()
        connection.close()
    return


def create_team():
    connection = connect()
    cursor = connection.cursor()

    valid_divs = ["north", "south", "east", "west"]

    team_name = input("What is the team name? ")
    city = input("What city are they located in? ")
    while True:
        in_nfc = input("Are they in the NFC? (y / n) ")
        if in_nfc.lower() == "y" or in_nfc.lower() == "n":
            break
        print(Fore.RED + "Not a valid input!!!", Style.RESET_ALL)

    in_nfc = True if in_nfc.lower() == "y" else False

    while True:
        division = input("What division are they in? (North / South / East / West) ")
        if division.lower() in valid_divs:
            break
        print(Fore.RED + "Not a valid input!!!", Style.RESET_ALL)

    tid = get_max_id("tid", "team") + 1
    
    values = (tid, city, team_name, in_nfc, division.lower())


    query = """
    INSERT INTO team (tid, city, name, in_nfc, division)
    VALUES (%s, %s, %s, %s, %s);
    """
    try:
        cursor.execute(query, values)
        connection.commit()
        print(Fore.LIGHTGREEN_EX + "Success!", Style.RESET_ALL)
    except:
        print(Fore.RED + "Failure! Issue stopped team from being created.", Style.RESET_ALL)
    finally:
        cursor.close()
        connection.close()
    return


def draft_player():
    connection = connect()
    cursor = connection.cursor()
    # may have to update ddl to use VARCHAR(2) instead of CHAR(2)
    positions = ["QB", "RB", "WR", "TE", "OT", "OG", "C", "DE", "DT", "LB", "DB", "K", "P"]

    pid = get_max_id("pid", "player") + 1
    first_name = input("What is the player's first name? ")
    last_name = input("What is the player's last name? ")
    
    while True:
        birthdate = input("What is the player's birthdate? (YYYY-MM-DD) ")
        try:
            birthdate = datetime.strptime(birthdate, "%Y-%m-%d").date()
            break
        except:
            print(Fore.RED + "Invalid Date Provided!!!", Style.RESET_ALL)
    
    while True:
        position = input("What position does the player play? (QB / DB / etc.) ")
        if position.upper() in positions:
            break
        print(Fore.RED + "Not a valid position!!!", Style.RESET_ALL)

    tid, retired = get_team_id("What team was the player drafted to? (team id number)", False, False)

    transaction_id = get_max_id("transaction_id", "transaction") + 1

    draft_date = get_date("What date was the player drafted? (YYYY-MM-DD) ")

    season = str(draft_date.year) + "-" + str(draft_date.year + 1)

    while True:
        number = int(input("What is the player's number? "))
        if number >= 0 or number <= 99:
            break
        print(Fore.RED + "Invalid Number", Style.RESET_ALL)

    try:
        cursor.execute("BEGIN;")

        query = """
                INSERT INTO player (pid, fname, lname, birthdate, position, number, tid, retired)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
                """
        values = (pid, first_name, last_name, birthdate, position, number, tid, False)
        cursor.execute(query, values)

        query = """
                INSERT INTO transaction (transaction_id, pid, new_tid, type, date, year)
                VALUES (%s, %s, %s, %s, %s, %s);
                """
        values = (transaction_id, pid, tid, "drafted", draft_date, season)
        cursor.execute(query, values)
    
        connection.commit()
        print(Fore.LIGHTGREEN_EX + "Success!", Style.RESET_ALL)
    except Exception as e:
        connection.rollback()
        print(Fore.RED + f"Transaction failed: {e}", Style.RESET_ALL)

    finally:
        cursor.close()
        connection.close()
    return


def sign_player():
    connection = connect()
    cursor = connection.cursor()

    transaction_id = get_max_id("transaction_id", "transaction") + 1
    new_tid, placeholder = get_team_id("What team did the player sign to? (team id number)", False, False)
    prev_tid, retired = get_team_id("What team was the player previously on? (team id number)", True, False)
    pid = get_player_id(prev_tid, retired)
    if pid == None:
        return
    sign_date = get_date("What date did the player sign? (YYYY-MM-DD) ")
    season = input("What season does the transaction belong to? (YYYY-YYYY) ")


    try:
        cursor.execute("BEGIN;")

        query = """
                INSERT INTO transaction (transaction_id, pid, prev_tid, new_tid, type, date, year)
                VALUES (%s, %s, %s, %s, %s, %s, %s);
                """
        values = (transaction_id, pid, prev_tid, new_tid, "signed", sign_date, season)

        cursor.execute(query, values)

        query = """
                UPDATE player
                SET tid= %s
                WHERE pid = %s;
                """
        cursor.execute(query, (new_tid, pid))

        connection.commit()
        print(Fore.LIGHTGREEN_EX + "Success!", Style.RESET_ALL)
    except Exception as e:
        connection.rollback()
        print(Fore.RED + "FAILURE! Issue encountered. No changes to data.")
        print(e, Style.RESET_ALL)
    finally:
        cursor.close()
        connection.close()
    return


def play_game():
    connection = connect()
    cursor = connection.cursor()

    choices = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"}

    gid = get_max_id("gid", "game") + 1
    home_tid, placeholder = get_team_id("What is the home team? ", False, False)
    away_tid, placeholder = get_team_id("What is the away team? ", False, False)
    game_date = get_date("What is the game date? (YYYY-MM-DD)")
    season = input("What season is the game? (YYYY-YYYY)")

    # Loop through home player stats
    #        points, takeaways, yards
    total_stats = [0, 0, 0]
    total_stats = {"home": [0, 0, 0], "away": [0, 0, 0]}
    player_stats_dict = {}
    tid = home_tid
    points_checked = False
    while tid != -1:
        if not points_checked:
            while True:
                points = input("How many points did the " + ("home" if tid == home_tid else "away") +  " team score?")
                try:
                    if int(points) >= 0:
                        total_stats["home" if tid == home_tid else "away"][0] += int(points)
                        points_checked = True
                        break
                    print(Fore.RED + "Points must be greater than or equal to 0!", Style.RESET_ALL)
                except:
                    print(Fore.RED + "Invalid points entered! Must be a whole number.", Style.RESET_ALL)

        print("================== Begin Entering Player Stats ==================")
        pid = get_player_id(tid)
        if pid == None:
            continue
        # Gather stats here
        player_stats = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        while True:
            print("================== Enter Stats ==================")
            print("1:  Pass Yards")
            print("2:  Rush Yards")
            print("3:  Receiving Yards")
            print("4:  Receptions")
            print("5:  Pass TDS")
            print("6:  Rush TDS")
            print("7:  Receiving TDS")
            print("8:  INTs Thrown")
            print("9:  Fumbles")
            print("10: Sacks")
            print("11: INTs")
            print("12: Tackles")
            print("0:  Done")
            user_choice = input("Select an action: ")
            if user_choice not in choices:
                continue
            if int(user_choice) == 0:
                total_stats["home" if tid == home_tid else "away"][2] += player_stats[1] + player_stats[2]
                total_stats["home" if tid == home_tid else "away"][1] += player_stats[9] + player_stats[10]
                break
            # method deals with stat accumulation: hold stats with list
            player_stats = update_stat_list(int(user_choice), player_stats)

        # Ask if done with team
        while True:
            print(f"1: Continue Adding Player Stats For " + ("Home" if tid == home_tid else "Away") +  " Team")
            print("2: Refresh Stats For Current Player (If you mistyped previously)")
            print("0: Done")
            user_choice = input("Choose an action: ")
            if int(user_choice) == 0 or int(user_choice) == 1 or int(user_choice) == 2:
                break
        player_stats_dict[pid] = deepcopy(player_stats)
        if int(user_choice) == 1:
            continue
        if int(user_choice) == 2:
            player_stats = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            continue
        points_checked = False
        if tid == home_tid:
            tid = away_tid
        else:
            tid = -1

    # Start query
    connection = connect()
    cursor = connection.cursor()

    try:
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
        
        for player in player_stats_dict:
            values = (player, gid, player_stats_dict[player][0], player_stats_dict[player][1], player_stats_dict[player][2], player_stats_dict[player][3], player_stats_dict[player][10], player_stats_dict[player][8], player_stats_dict[player][7], player_stats_dict[player][6], player_stats_dict[player][5], player_stats_dict[player][4], player_stats_dict[player][11], player_stats_dict[player][9])

            cursor.execute(query, values)

        connection.commit()
        print(Fore.LIGHTGREEN_EX + "Success!", Style.RESET_ALL)
    except Exception as e:
        connection.rollback()
        print(Fore.RED + "FAILURE! Issue encountered. No changes to data.")
        print(e, Style.RESET_ALL)
    finally:
        cursor.close()
        connection.close()
    return




def player_wins_award():
    connection = connect()
    cursor = connection.cursor()

    award = input("What is the name of the award? ")
    tid, retired = get_team_id("What team is the player currently on? ", False, False)
    pid = get_player_id(tid, retired)
    if pid == None:
        return
    season = input("What is the season the award was won? (YYYY-YYYY) ")

    query = """
            INSERT INTO award (award_name, year, pid, tid)
            VALUES (%s, %s, %s, %s);
            """
    try:
        cursor.execute(query, (award, season, pid, tid))
        connection.commit()
        print(Fore.LIGHTGREEN_EX + "Success!", Style.RESET_ALL)
    except Exception as e:
        print(Fore.RED + "Failure! Issue stopped player from having reward added.", Style.RESET_ALL)
        print(e)
    finally:
        cursor.close()
        connection.close()
    return


def switch_position():
    connection = connect()
    cursor = connection.cursor()

    positions = ["QB", "RB", "WR", "TE", "OT", "OG", "C", "DE", "DT", "LB", "DB", "K", "P"]

    tid, retired = get_team_id("What team is the player currently on? ", False, True)
    pid = get_player_id(tid, retired)
    if pid == None:
        return
    
    while True:
        position = input("What position is the player changin to? (QB / RB / DB / etc.) ")
        if position.upper() in positions:
            break
        print(Fore.RED + "Not a valid position!!!", Style.RESET_ALL)
        print("These are valid positions")
        for position in positions:
            print(position)
    
    query = """
            UPDATE player
            SET position = %s
            WHERE pid = %s;
            """
    try:
        cursor.execute(query, (position, pid))
        connection.commit()
        print(Fore.LIGHTGREEN_EX + "Success!", Style.RESET_ALL)
    except:
        print(Fore.RED + "Failure! Issue stopped player from switching positions", Style.RESET_ALL)
    finally:
        cursor.close()
        connection.close()
    return


def player_retires():
    connection = connect()
    cursor = connection.cursor()

    tid, placeholder = get_team_id("What team is the player currently on? ", False, True)
    pid = get_player_id(tid, False)
    if pid == None:
        return

    query = """
            UPDATE player 
            SET retired = TRUE, tid = NULL
            WHERE pid = %s
            """
    
    try:
        cursor.execute(query, (pid,))
        connection.commit()
        print(Fore.LIGHTGREEN_EX + "Success!", Style.RESET_ALL)
    except:
        print(Fore.RED + "Failure! Issue stopped player from having reward added.", Style.RESET_ALL)
    finally:
        cursor.close()
        connection.close()
    return



def transaction_reverted():
    connection = connect()
    cursor = connection.cursor()

    tid, retired = get_team_id("What team is the player currently on? ", False, True)
    pid = get_player_id(tid, retired)
    if pid == None:
        return

    try:
        cursor.execute("BEGIN;")

        query = """
                SELECT transaction_id, prev_tid
                FROM transaction
                WHERE (pid, date, prev_tid) IN (
                    SELECT pid, date, prev_tid
                    FROM transaction
                    WHERE pid = %s AND type != 'drafted'
                    ORDER BY date DESC
                    LIMIT 1
                    );
                """
        
        cursor.execute(query, (pid,))
        row = cursor.fetchone()
        if row[0] == None:
            print(Fore.RED + "No transaction found!", Style.RESET_ALL)
            return
        
        transact_id = row[0]
        prev_tid = row[1]

        query = """
                DELETE FROM transaction
                WHERE transaction_id = %s
                """
        
        cursor.execute(query, (transact_id,))

        query = """
                UPDATE player 
                SET tid = %s
                WHERE pid = %s
                """
        
        cursor.execute(query, (prev_tid, pid))

        connection.commit()
        print(Fore.LIGHTGREEN_EX + "Success!", Style.RESET_ALL) 
    except:
        connection.rollback()
        print(Fore.RED + "FAILURE! Issue encountered. No changes to data.", Style.RESET_ALL)
    finally:
        cursor.close()
        connection.close()
    return




# Helper queries / methods

def get_max_id(attribute, table):
    connection = connect()
    cursor = connection.cursor()

    query = f"""
        SELECT MAX({attribute})
        FROM {table}
    """

    cursor.execute(query, (attribute, table))

    max_id = cursor.fetchone()
    if max_id[0] == None:
        return 0

    cursor.close()
    connection.close()
    return max_id[0]

def get_tid_from_team_name(team_name):
    connection = connect()
    cursor = connection.cursor()

    query = """
        SELECT tid
        FROM team
        WHERE name = %s
        """
    
    cursor.execute(query, (team_name,))

    tid = cursor.fetchone()

    cursor.close()
    connection.close()
    if tid == None:
        return tid
    
    return tid[0]

def get_pid_from_name(fname, lname, tid, retired):
    connection = connect()
    cursor = connection.cursor()
    if tid != None:
        query = """
            SELECT pid
            FROM player
            WHERE fname = %s AND lname = %s AND tid = %s
            """
    else:
        query = """
                SELECT pid
                FROM player
                WHERE fname = %s AND lname = %s""" + ("""AND retired = %s""" if retired == True else "")

    if tid != None:
        cursor.execute(query, (fname, lname, tid))
    else:
        if retired:
            cursor.execute(query, (fname, lname, retired))
        else:
            cursor.execute(query, (fname, lname))

    pids = cursor.fetchall()

    cursor.close()
    connection.close()

    if len(pids) == 0:
        return None
    if len(pids) == 1:
        return pids[0][0]
    
    i = 1
    for pid in pids:
        print(str(i) + ": " + str(pid))
        i += 1
    print("0: None of these")

    while True:
        user_choice = input("Which is the correct player? ")
        if int(user_choice) == 0:
            return None
        elif int(user_choice) >= 1 and int(user_choice) <= len(pids):
            return pids[int(user_choice) - 1]
        else:
            print(Fore.RED + "Invalid Action!", Style.RESET_ALL)


def get_team_id(message, prev, for_player):
    while True:
        try:
            print(message)
            print("1: Get team by name")
            print("2: Manually enter team id")
            if for_player:
                print("3: Don't Know Team")
                print("4: Player is retired")
            if prev:
                print("5: No former team")
            user_choice = input("How would you like to input the team? ")
        
            if prev and int(user_choice) == 5:
                return (None, False)
            while int(user_choice) != 1 and int(user_choice) != 2 and int(user_choice) !=3 and int(user_choice) != 4:
                print(Fore.RED + "Not a valid action", Style.RESET_ALL)
                user_choice = input("How would you like to input the team? ")
            if (int(user_choice) == 4 and for_player) or int(user_choice) == 3:
                # tid = get_tid_from_team_name(None)
                return (None, False) if int(user_choice) == 3 else (None, True)
            elif int(user_choice) == 2:
                tid = int(input("What is team id number? "))
            elif int(user_choice) == 1:
                tid = None
                while tid == None:
                    team_name = input("What is the team name? ")
                    tid = get_tid_from_team_name(team_name)
                    if tid == None:
                        print(Fore.RED + "Invalid Team Name!", Style.RESET_ALL)
            else:
                print(Fore.RED + "Invalid Action", Style.RESET_ALL)
                continue
        except:
            print(Fore.RED + "Invalid Action", Style.RESET_ALL)
            continue
        # get the team from either tid or team name
        return (tid, False)
    
def get_player_id(tid, retired):
    while True:
        print("Who is the player? ")
        print("1: Get player by name")
        print("2: Manually enter player id")

        user_choice = input("How would you like to input the player? ")
        try:
            while int(user_choice) != 1 and int(user_choice) != 2:
                print(Fore.RED + "Not a valid action", Style.RESET_ALL)
                user_choice = input("How would you like to input the player? ")
            if int(user_choice) == 2:
                pid = int(input("What is player id number? "))
            else:
                pid = None
                while True:
                    fname = input("What is the player's first name? ")
                    lname = input("What is the player's last name? ")
                    pid = get_pid_from_name(fname, lname, tid, retired)
                    if pid != None:
                        break
                    while True:
                        print("1: Try Another Name")
                        print("0: Back Out of Query")
                        user_choice = input("What action would you like to continue forward? ")
                        if int(user_choice) == 0 or int(user_choice) == 1:
                            break
                        print(Fore.RED + "Invalid Action!", Style.RESET_ALL)

                    if int(user_choice) == 0:
                        return None
        except:
            print(Fore.RED + "Invalid Action!", Style.RESET_ALL)
            continue

        # get the team from either tid or team name
        return pid

def get_date(message):
    while True:
        t_date = input(message)

        try:
            t_date = datetime.strptime(t_date, "%Y-%m-%d").date()
            return t_date
        except:
            print(Fore.RED + "Invalid Date Provided!!!", Style.RESET_ALL)


def update_stat_list(stat_choice, stats):
    if stat_choice == 1:
        stats[0] = get_and_validate_stat("How many pass yards did they get? ")
    elif stat_choice == 2:
        stats[1] = get_and_validate_stat("How many rush yards did they get? ")
    elif stat_choice == 3:
        stats[2] = get_and_validate_stat("How many receiving yards did they get? ")
    elif stat_choice == 4:
        stats[3] = get_and_validate_stat("How many receptions did they get? ")
    elif stat_choice == 5:
        stats[4] = get_and_validate_stat("How many passing tds did they throw? ")
    elif stat_choice == 6:
        stats[5] = get_and_validate_stat("How many rushing tds did they get? ")
    elif stat_choice == 7:
        stats[6] = get_and_validate_stat("How many receiving tds did they get? ")
    elif stat_choice == 8:
        stats[7] = get_and_validate_stat("How many interceptions did they throw? ")
    elif stat_choice == 9:
        stats[8] = get_and_validate_stat("How many fumbles did they lose? ")
    elif stat_choice == 10:
        stats[9] = get_and_validate_stat("How many sacks did they get? ")
    elif stat_choice == 11:
        stats[10] = get_and_validate_stat("How many interceptions did they get? ")
    elif stat_choice == 12:
        stats[11] = get_and_validate_stat("How many tackles did they get? ")
    
    return stats

def get_and_validate_stat(message):
    while True:
        points = input(message)
        try:
            if int(points) >= 0:
                return int(points)
            print(Fore.RED + "Points must be greater than or equal to 0!", Style.RESET_ALL)
        except:
            print(Fore.RED + "Invalid points entered! Must be a whole number.", Style.RESET_ALL)


def output_rows(rows, col_names):
    print(tabulate(rows, headers = col_names, tablefmt = "grid"))

