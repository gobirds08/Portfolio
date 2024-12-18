import displays
import queries.change_queries as change_queries
import queries.select_queries as select_queries
from colorama import Fore, Style

def main_menu_choice(choice):
    if choice == 1:
        return displays.query_menu
    elif choice == 2:
        return displays.instructions
    elif choice == 3:
        return displays.about_section
    elif choice == 0:
        return 0
    else:
        print(Fore.RED + "Invalid Action!", Style.RESET_ALL)
        return displays.main_menu

def instructions_choice(choice):
    if choice == 0:
        return displays.main_menu
    else:
        return displays.instructions
    
def about_choice(choice):
    if choice == 0:
        return displays.main_menu
    else:
        return displays.about_section
    
def middle_choice(choice):
    if choice == 0:
        return displays.query_menu
    else:
        return displays.middle_menu
    
def query_choice(choice):
    if choice == 0:
        return displays.main_menu
    elif choice == 1:
        select_queries.get_teams()
    elif choice == 2:
        change_queries.create_team()
    elif choice == 3:
        change_queries.draft_player()
    elif choice == 4:
        change_queries.sign_player()
    elif choice == 5:
        change_queries.play_game()
    elif choice == 6:
        select_queries.team_games_report()
    elif choice == 7:
        select_queries.see_player_stats_season()
    elif choice == 8:
        select_queries.see_player_awards(False)
    elif choice == 9:
        select_queries.see_player_awards(True)
    elif choice == 10:
        change_queries.player_wins_award()
    elif choice == 11:
        change_queries.switch_position()
    elif choice == 12:
        select_queries.see_standings()
    elif choice == 13:
        select_queries.transactions_season()
    elif choice == 14:
        select_queries.player_transaction_career()
    elif choice == 15:
        select_queries.see_team_roster() 
    elif choice == 16:
        select_queries.see_team_schedule()
    elif choice == 17:
        change_queries.player_retires()
    elif choice == 18:
        select_queries.get_award_winner_stats()
    elif choice == 19:
        change_queries.create_or_end_season(False)
    elif choice == 20:
        change_queries.create_or_end_season(True)
    elif choice == 21:
        change_queries.transaction_reverted()
    
    return displays.middle_menu