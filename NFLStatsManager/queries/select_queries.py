from queries.change_queries import connect, get_player_id, get_team_id, output_rows
from colorama import Fore, Style



def get_teams():

    connection = connect()
    cursor = connection.cursor()

    query = """
        SELECT tid, city, name
        FROM team
        """

    cursor.execute(query)

    rows = cursor.fetchall()
    output_rows(rows, ["Team ID", "City", "Name"])

    cursor.close()
    connection.close()
    return


def see_player_awards(team_lookup):
    connection = connect()
    cursor = connection.cursor()

    if team_lookup:
        tid, placeholder = get_team_id("What team do you want to see player awards for? ", False, False)

        query = """
                SELECT fname, lname, award_name, year
                FROM award a, player p
                WHERE a.pid = p.pid AND p.tid = %s
                GROUP BY p.pid, fname, lname, award_name, year
                ORDER BY a.award_name
                """
        cursor.execute(query, (tid,))
    else:
        tid, retired = get_team_id("What team is the player currently on? ", False, True)
        pid = get_player_id(tid, retired)
        query = """
                SELECT award_name, year
                FROM award
                WHERE pid = %s;
                """
        cursor.execute(query, (pid,))

    rows = cursor.fetchall()
    if team_lookup:
        output_rows(rows, ["First Name", "Last Name", "Award", "Season"])
    else:
        output_rows(rows, ["Award", "Season"])

    cursor.close()
    connection.close()
    return
    

def see_player_stats_season():
    connection = connect()
    cursor = connection.cursor()

    print("What type of stats would you like to see? ")
    print("1: Passing")
    print("2: Rushing")
    print("3: Receiving")
    print("4: Defensive")
    user_choice = input("Select Type: ")
    while int(user_choice) > 4 and int(user_choice) < 1:
        print(Fore.RED + "Invalid Action!!!", Style.RESET_ALL)
        user_choice = input("Select Type: ")
    
    tid, retired = get_team_id("What team is the player on? ", False, True)
    pid = get_player_id(tid, retired)
    season = input("What season do you want for the player's stats? (YYYY-YYYY) ")
    
    query, col_names = get_player_stat_query(int(user_choice))
    cursor.execute(query, (pid, season))

    rows = cursor.fetchall()
    output_rows(rows, col_names)

    cursor.close()
    connection.close()
    return


def team_games_report():
    connection = connect()
    cursor = connection.cursor()    

    tid, placeholder = get_team_id("What team do you want to look at? ", False, False)
    season = input("What season do you want for the team? (YYYY-YYYY) ")

    query = """
            SELECT DISTINCT points, yds, takeaways, g.date
            FROM team_stats ts, game g
            WHERE ts.tid = %s AND g.season = %s AND ts.gid = g.gid
            ORDER BY g.date;
            """
    
    cursor.execute(query, (tid, season))
    rows = cursor.fetchall()
    print(len(rows))
    output_rows(rows, ["Points", "Total Yards", "Turnovers", "Date"])

    cursor.close()
    connection.close()
    return


def see_standings():
    connection = connect()
    cursor = connection.cursor() 

    season = input("What season do you want to see the standings for? (YYYY-YYYY) ")

    query = """
            SELECT t.name, 
            SUM(CASE WHEN ts.points > (SELECT opp.points FROM team_stats opp WHERE opp.gid = ts.gid AND opp.tid != ts.tid) THEN 1 ELSE 0 END) AS wins,
            SUM(CASE WHEN ts.points < (SELECT opp.points FROM team_stats opp WHERE opp.gid = ts.gid AND opp.tid != ts.tid) THEN 1 ELSE 0 END) AS losses,
            SUM(CASE WHEN ts.points = (SELECT opp.points FROM team_stats opp WHERE opp.gid = ts.gid AND opp.tid != ts.tid) THEN 1 ELSE 0 END) AS ties
            FROM team t, team_stats ts, game g
            WHERE g.season = %s AND t.tid = ts.tid AND ts.gid = g.gid
            GROUP BY t.tid
            ORDER BY wins DESC, losses ASC;
            """
    
    cursor.execute(query, (season,))
    rows = cursor.fetchall()
    output_rows(rows, ["Name", "Wins", "Losses", "Ties"])

    cursor.close()
    connection.close()
    return


def transactions_season():
    # team or whole league
    connection = connect()
    cursor = connection.cursor() 

    season = input("What season do you want to see the transactions for? (YYYY-YYYY) ")
    while True:
        just_team = input("Do you want to see transactions for just one team? (y / n) ")
        if (just_team.lower() == "y" or just_team.lower() == "n"):
            just_team = True if just_team.lower() == "y" else False
            break
    if just_team:
        tid, placeholder = get_team_id("What team do you want to look at? ", False, False)
        query = """
                SELECT new.name, prev.name, p.fname, p.lname, t.type, t.date
                FROM transaction t, team new, team prev, player p
                WHERE t.new_tid = %s AND t.prev_tid = prev.tid AND t.new_tid = new.tid AND t.pid = p.pid AND t.year = %s
                UNION
                SELECT new.name, NULL, p.fname, p.lname, t.type, t.date
                FROM transaction t, team new, player p
                WHERE t.type = 'drafted' AND t.new_tid = %s AND t.new_tid = new.tid AND t.pid = p.pid AND t.year = %s
                ORDER BY date;
                """
        values = (tid, season, tid, season)
    else:
        query = """
                SELECT new.name, prev.name, p.fname, p.lname, t.type, t.date
                FROM transaction t, team new, team prev, player p
                WHERE t.prev_tid = prev.tid AND t.new_tid = new.tid AND t.pid = p.pid AND t.year = %s
                UNION
                SELECT new.name, NULL, p.fname, p.lname, t.type, t.date
                FROM transaction t, team new, player p
                WHERE t.type = 'drafted' AND t.new_tid = new.tid AND t.pid = p.pid AND t.year = %s
                ORDER BY date;
                """
        values = (season, season)

    cursor.execute(query, values)
    rows = cursor.fetchall()
    output_rows(rows, ["New Team", "Prev Team", "First Name", "Last Name", "Transaction Type", "Date"])

    cursor.close()
    connection.close()
    return


def player_transaction_career():
    connection = connect()
    cursor = connection.cursor() 

    tid, retired = get_team_id("What team is the player on? ", False, True)
    pid = get_player_id(tid, retired)

    query = """
            SELECT new.name, prev.name, t.type, t.date
            FROM transaction t, team new, team prev
            WHERE t.pid = %s AND t.prev_tid = prev.tid AND t.new_tid = new.tid
            UNION
            SELECT new.name, NULL, t.type, t.date
            FROM transaction t, team new
            WHERE t.pid = %s AND t.type = 'drafted' AND t.new_tid = new.tid
            ORDER BY date;
            """
    
    cursor.execute(query, (pid, pid))
    rows = cursor.fetchall()
    output_rows(rows, ["New Team", "Prev Team", "Transaction Type", "Date"])

    cursor.close()
    connection.close()
    return


def see_team_roster():
    connection = connect()
    cursor = connection.cursor() 

    print("Sorting Options:")
    print("1: Last Name")
    print("2: Number")
    print("3: Position")
    print("4: Age")
    while True:
        user_choice = input("Select sorting option: ")
        if int(user_choice) >= 1 and int(user_choice) <= 4:
            break
        print(Fore.RED + "Invalid Action!!!", Style.RESET_ALL)

    tid, placeholder = get_team_id("What team do you want the roster for? ", False, False)
    if tid != None:
        print("Team ID: " + str(tid))
    
    query = """
            SELECT p.pid, p.fname, p.lname, p.number, p.position, EXTRACT(YEAR FROM AGE(birthdate)) AS age
            FROM player p, team t
            WHERE t.tid = %s AND p.tid = t.tid
            """ + get_player_transaction_order_by(int(user_choice))
    
    cursor.execute(query, (tid,))
    rows = cursor.fetchall()
    output_rows(rows, ["Player ID", "First Name", "Last Name", "Number", "Position", "Age"])

    cursor.close()
    connection.close()
    return



def see_team_schedule():
    connection = connect()
    cursor = connection.cursor()

    tid, placeholder = get_team_id("What team do you want the schedule for? ", False, False)
    season = input("What season do you want to see the schedule for? (YYYY-YYYY) ")

    query = """
            SELECT opp.name, usstats.points, oppstats.points
            FROM team opp, team_stats oppstats, team_stats usstats, game g, team us
            WHERE oppstats.tid = opp.tid AND usstats.gid = oppstats.gid AND usstats.tid != oppstats.tid AND g.gid = usstats.gid AND us.tid = usstats.tid AND g.season = %s AND us.tid = %s
            ORDER BY g.date;
            """
    
    cursor.execute(query, (season, tid))
    rows = cursor.fetchall()
    output_rows(rows, ["Opponent Team", "Team Points", "Opponent Points"])

    cursor.close()
    connection.close()
    return


def get_award_winner_stats():
    connection = connect()
    cursor = connection.cursor()

    season = input("What season do you want to see the award winner stats for? (YYYY-YYYY) ")

    allowed_awards = get_all_awards(season)
    try:
        allowed_awards.remove("mvp")
    except:
        pass

    i = 1
    for allow_award in allowed_awards:
        print(str(i) + ": " + str(allow_award))
        i += 1

    while True:
        try:
            award_num = int(input("What award do you want to see? (Number) "))
            if award_num >= 1 and award_num <= len(allowed_awards):
                break
            print(Fore.RED + "Not a valid award!", Style.RESET_ALL)
        except:
            print(Fore.RED + "Invalid Input", Style.RESET_ALL)
            continue
    
    order_by, select_section, additional_col_names = get_award_winner_stats_order_by(allowed_awards[award_num - 1].lower())
    col_names = ["First Name", "Last Name", "Team Name", "City"] + additional_col_names


    query =  (   """
    SELECT p.fname, p.lname, t.name, loc.city, """ + select_section + """
    FROM player p, award a, game g, team t, team loc, player_stats ps
    WHERE a.award_name = %s AND a.year = %s AND a.pid = p.pid AND p.pid = ps.pid 
          AND ps.gid = g.gid AND g.home_tid = loc.tid AND p.tid = t.tid
    """
    + order_by
    + """
    LIMIT 1;
    """ )
    
    cursor.execute(query, (allowed_awards[award_num - 1], season))
    rows = cursor.fetchall()
    output_rows(rows, col_names)

    cursor.close()
    connection.close()
    return






# Helper methods / queries

def get_player_stat_query(choice):
    if choice == 1:
        return ("""
            SELECT year, SUM(pass_yds), SUM(pass_tds), SUM(ints_thrown), SUM(fumbles)
            FROM player_stats ps, season g
            WHERE ps.pid = %s AND g.year = %s
            GROUP BY g.year, ps.pid;
            """, ["Season", "Pass Yards", "Pass TDs", "INTs Thrown", "Fumbles Lost"])
    elif choice == 2:
        return ("""
            SELECT year, SUM(rush_yds), SUM(rush_tds), SUM(fumbles)
            FROM player_stats ps, season g
            WHERE ps.pid = %s AND g.year = %s
            GROUP BY g.year, ps.pid;
            """, ["Season", "Rush Yards", "Rush TDs", "Fumbles Lost"])
    elif choice == 3:
        return ("""
            SELECT year, SUM(rec_yds), SUM(rec_tds), SUM(receptions), SUM(fumbles)
            FROM player_stats ps, season g
            WHERE ps.pid = %s AND g.year = %s
            GROUP BY g.year, ps.pid;
            """, ["Season", "Receiving Yards", "Receiving TDs", "Receptions", "Fumbles Lost"])
    elif choice == 4:
        return ("""
            SELECT year, SUM(tackles), SUM(sacks), SUM(ints)
            FROM player_stats ps, season g
            WHERE ps.pid = %s AND g.year = %s
            GROUP BY g.year, ps.pid;
            """, ["Season", "Tackles", "Sacks", "INTs"])
    
def get_player_transaction_order_by(choice):
    if choice == 1:
        return """
            ORDER BY p.lname;
            """
    elif choice == 2:
        return """
            ORDER BY p.number;
            """
    elif choice == 3:
        return """
            ORDER BY p.position;
            """
    elif choice == 4:
        return """
            ORDER BY age;
            """


def get_award_winner_stats_order_by(award):
    if award == "best receiver":
        return ("""ORDER BY ps.rec_yds DESC""", "ps.rec_yds, ps.rec_tds, ps.receptions", ["Receiving Yards", "Receiving TDs", "Receptions"])
    elif award == "best qb":
        return ("""ORDER BY ps.pass_yds DESC""", "ps.pass_yds, ps.pass_tds", ["Passing Yards", "Passing TDs"])
    elif award == "best rb":
        return ("""ORDER BY ps.rush_yds DESC""", "ps.rush_yds, ps.rush_tds", ["Rushing Yards", "Rushing TDs"])
    elif award == "best dl":
        return ("""ORDER BY ps.sacks DESC""", "ps.sacks, ps.tackles, ps.ints", ["Sacks", "Tackles", "INTs"])
    elif award == "best lb":
        return ("""ORDER BY ps.tackles DESC""", "ps.tackles, ps.sacks, ps.ints", ["Tackles", "Sacks", "INTs"])
    elif award == "best db":
        return ("""ORDER BY ps.ints DESC""", "ps.ints, tackles, ps.sacks", ["INTs", "Tackles", "Sacks"])
    return


def get_all_awards(season):
    connection = connect()
    cursor = connection.cursor()

    query = """
            SELECT DISTINCT award_name
            FROM award
            WHERE award.year = %s
            """
    
    cursor.execute(query, (season,))
    awards = []
    rows = cursor.fetchall()
    for row in rows:
        awards.append(row[0])

    cursor.close()
    connection.close()
    return awards
    