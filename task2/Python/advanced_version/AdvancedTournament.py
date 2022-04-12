#
# CSCI3180 Principles of Programming Languages
#
# --- Declaration ---
#
# I declare that the assignment here submitted is original except for source
# material explicitly acknowledged. I also acknowledge that I am aware of
# University policy and regulations on honesty in academic work, and of the
# disciplinary guidelines and procedures applicable to breaches of such policy
# and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/
#
# Assignment 3
# Name : LI Jialu
# Student ID : 11552107895
# Email Addr : 1155107895@link.cuhk.edu.hk
#

from base_version.Team import Team
from base_version.Tournament import Tournament
from .AdvancedFighter import AdvancedFighter
import advanced_version.AdvancedFighter as AdvancedFighterFile


class AdvancedTournament(Tournament):
    def __init__(self):
        super(AdvancedTournament, self).__init__()
        self.team1 = None
        self.team2 = None
        self.round_cnt = 1
        self.defeat_record = []

    def input_fighters(self, team_NO):
        print("Please input properties for fighters in Team {}".format(team_NO))
        fighter_list_team = []
        for fighter_idx in range(4 * (team_NO - 1) + 1, 4 * (team_NO - 1) + 5):
            while True:
                properties = input().split(" ")
                properties = [int(prop) for prop in properties]
                HP, attack, defence, speed = properties
                if HP + 10 * (attack + defence + speed) <= 500:
                    fighter = AdvancedFighter(fighter_idx, HP, attack, defence, speed)
                    fighter_list_team.append(fighter)
                    break
                print("Properties violate the constraint")
        return fighter_list_team

    def update_fighter_properties_and_award_coins(self, fighter, flag_defeat=False, flag_rest=False):
        if flag_defeat == False:
            fighter.obtain_coins()
            #print("*********Currently have coins:",fighter.coins)
            fighter.update_properties()
        else:
            pass
    

    
        
    def play_one_round(self):
        fight_cnt = 1
        print("Round {}:".format(self.round_cnt))

        while True:
            team1_fighter = self.team1.get_next_fighter()
            team2_fighter = self.team2.get_next_fighter()

            if team1_fighter is None or team2_fighter is None:
                break

            team1_fighter.buy_prop_upgrade()
            team2_fighter.buy_prop_upgrade()

            fighter_first = team1_fighter
            fighter_second = team2_fighter
            
            if team1_fighter.properties["speed"] < team2_fighter.properties["speed"]:
                fighter_first = team2_fighter
                fighter_second = team1_fighter

            properties_first = fighter_first.properties
            properties_second = fighter_second.properties

            damage_first = max(properties_first["attack"] - properties_second["defense"], 1)
            fighter_second.reduce_HP(damage_first)

            damage_second = None
            # if fighter2 is not defeated 
            if not fighter_second.check_defeated():
                damage_second = max(properties_second["attack"] - properties_first["defense"], 1)
                fighter_first.reduce_HP(damage_second)
                

            winner_info = "tie"
            # fighter2 is defeated 
            if damage_second is None:
                winner_info = "Fighter {} wins".format(fighter_first.properties["NO"])
                #print("second fighter defeated!!!!!")
                fighter_first.record_fight(2)
                fighter_second.record_fight(-2)
                fighter_second.defeated = True
            else:
                # if fighter1 wins
                if damage_first > damage_second:
                    winner_info = "Fighter {} wins".format(fighter_first.properties["NO"])
                    fighter_first.record_fight(1)
                    fighter_second.record_fight(-1)
                # if fighter2 wins
                elif damage_second > damage_first:
                    winner_info = "Fighter {} wins".format(fighter_second.properties["NO"])
                    fighter_first.record_fight(-1)
                    fighter_second.record_fight(1)
                # if they tie
                else: 
                    fighter_first.record_fight(0)
                    fighter_second.record_fight(0)
            
            print("Duel {}: Fighter {} VS Fighter {}, {}".format(fight_cnt, team1_fighter.properties["NO"],
                    team2_fighter.properties["NO"], winner_info))

            team1_fighter.print_info()
            team2_fighter.print_info()
            self.update_fighter_properties_and_award_coins(team1_fighter)
            self.update_fighter_properties_and_award_coins(team2_fighter)
            fight_cnt += 1
            

        print("Fighters at rest:")
        for team in [self.team1, self.team2]:
            if team is self.team1:
                team_fighter = team1_fighter
            else:
                team_fighter = team2_fighter
            while True:
                if team_fighter is not None:
                    team_fighter.print_info()
                    team_fighter.record_fight('*')
                    self.update_fighter_properties_and_award_coins(team_fighter)
                else:
                    break
                team_fighter = team.get_next_fighter()

        self.round_cnt += 1

