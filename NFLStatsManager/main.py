import displays

    

def run():
    displays.title()
    menu = displays.main_menu

    while True:
        user_choice = menu()
        menu = user_choice[1]((user_choice[0]))
        if menu == 0:
            break
 
    return


if __name__ == '__main__':
    run()