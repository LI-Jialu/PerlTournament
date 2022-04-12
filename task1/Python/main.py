from base_version.Tournament import Tournament
# import sys 


if __name__ == "__main__":
    
    
    '''if len(sys.argv) > 1:
        if sys.argv[1] == 'basic':
            print("Here is the basic version")
            tournament = Tournament()
            tournament.play_game()
        if sys.argv[1] == 'advanced':
            print("Here is the advanced version")
            advTournament = AdvancedTournament()
            advTournament.play_game()
        else:
            print('sys argv len < 1')'''


    tournament = Tournament()
    tournament.play_game()
