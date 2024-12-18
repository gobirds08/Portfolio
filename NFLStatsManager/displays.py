from colorama import Fore, Style
import user_choices as user_choices


def main_menu():
    # print statements
    fore_color = Fore.LIGHTCYAN_EX

    print(fore_color + "1: Query")
    print("2: Instructions")
    print("3: About")
    print("0: Quit", Style.RESET_ALL)
    choice = input("Enter your action: ")
    try:
        return int(choice), user_choices.main_menu_choice
    except:
        return -1, user_choices.main_menu_choice

def query_menu():
    fore_color = Fore.LIGHTCYAN_EX

    choices_allowed = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21"}
    
    print(fore_color + "1:  View Teams")
    print("2:  Add Team")
    print("3:  Draft Player")
    print("4:  Sign Player")
    print("5:  Enter Game Stats")
    print("6:  Team Season Report")
    print("7:  Player Season Stats")
    print("8:  Player Awards")
    print("9:  Team Player Awards")
    print("10: Player Wins Award")
    print("11: Player Switches Position")
    print("12: View Standings")
    print("13: Season Transactions")
    print("14: Player Career Transactions")
    print("15: View Team Roster")
    print("16: View Team Schedule")
    print("17: Player Retires")
    print("18: Award Winner Best Game Stats")
    print("19: Create A New Season")
    print("20: End A Season")
    print("21: Revert Transaction")
    print("0:  Return to Main Menu", Style.RESET_ALL)
    choice = input("Enter your action: ")
    if choice in choices_allowed:
        return int(choice), user_choices.query_choice
    else:
        print("Invalid Action!")
        return -1, user_choices.query_choice


def instructions():
    fore_color = Fore.LIGHTCYAN_EX
    
    choices_allowed = {"0"}

    # print instructions here
    print(fore_color + "=================== Instructions ===================")
    print("Welcome to NFL Stats Manager!")
    print("Here are a few instructions / tips to help you use the program: ")
    print("*  You will be prompted to enter numbers which allows you to navigate")
    print("   throughout the application. A menu display will be provided at each")
    print("   decision point. Only enter a number which reflects and action.")
    print("*  When performing a query, make sure you are inputting the data in the")
    print("   correct format. A example format will be provided when it is needed")
    print("   such as (YYYY-YYYY) which means a 4 digit year with a 4 digit year")
    print("   represented as 2024-2025.")
    print("*  Be careful how you enter the data when prompted t. The instructions")
    print("   at each step will tell you what format the data needs to be in.")
    print("====================================================")
    print("0: Return to Main Menu", Style.RESET_ALL)
    choice = input("Enter your action: ")
    if choice in choices_allowed:
        return int(choice), user_choices.instructions_choice
    else:
        print("Invalid Action!")
        return -1, user_choices.instructions_choice

def about_section():
    fore_color = Fore.LIGHTCYAN_EX
    print(fore_color + "=================== About ===================")
    print("This application was created by Brendan Kenney.")
    print("Credit for most of the data is sportsdataio.")
    print("https://sportsdata.io/")
    print("=============================================")
    print("0: Return to Main Menu", Style.RESET_ALL)
    choice = input("Enter your action: ")
    return int(choice), user_choices.about_choice

def middle_menu():
    fore_color = Fore.LIGHTCYAN_EX

    choices_allowed = {"0"}
    
    print(fore_color + "0: Exit", Style.RESET_ALL)
    choice = input("Enter your action: ")
    if choice in choices_allowed:
        return int(choice), user_choices.middle_choice
    else:
        print("Invalid Action!")
        return -1, user_choices.middle_choice


def title():
    title = f"""{Fore.LIGHTCYAN_EX}
========================================================================
========================================================================

███╗   ██╗███████╗██╗         ███████╗████████╗ █████╗ ████████╗███████╗
████╗  ██║██╔════╝██║         ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██╔════╝
██╔██╗ ██║█████╗  ██║         ███████╗   ██║   ███████║   ██║   ███████╗
██║╚██╗██║██╔══╝  ██║         ╚════██║   ██║   ██╔══██║   ██║   ╚════██║
██║ ╚████║██║     ███████╗    ███████║   ██║   ██║  ██║   ██║   ███████║
╚═╝  ╚═══╝╚═╝     ╚══════╝    ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝

███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗██████╗ 
████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔════╝██╔══██╗
██╔████╔██║███████║██╔██╗ ██║███████║██║  ███╗█████╗  ██████╔╝
██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══╝  ██╔══██╗
██║ ╚═╝ ██║██║  ██║██║ ╚████║██║  ██║╚██████╔╝███████╗██║  ██║
╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝

========================================================================
========================================================================
"""
    print(title, Style.RESET_ALL)


if __name__ == "__main__":
    title()
    main_menu()