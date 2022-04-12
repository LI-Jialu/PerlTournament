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

from tkinter.messagebox import NO
from base_version.Fighter import Fighter

coins_to_obtain = 20
delta_attack = -1
delta_defense = -1
delta_speed = -1


class AdvancedFighter(Fighter):
    def __init__(self, NO, HP, attack, defense, speed):
        super(AdvancedFighter, self).__init__(NO, HP, attack, defense, speed)
        self.coins = 0
        self.history_record = []

    def obtain_coins(self):
        global coins_to_obtain
        global delta_attack
        global delta_defense
        global delta_speed
        # take a rest 
        if (self.history_record[-1] == '*'):
            # print("take a rest")
            coins_to_obtain =  10 
            delta_attack = 1 
            delta_defense = 1 
            delta_speed = 1 

        # fight, and win 3 times 
        elif (len([i for i in self.history_record if i > 0])==3):
            # print("fight, and win 3 times");
            coins_to_obtain =  int(coins_to_obtain * 1.1)
            delta_attack = 1 
            delta_defense = -2 
            delta_speed = 1
            self.history_record = [] 

        # fight, and lose 3 times 
        elif (len([i for i in self.history_record if i < 0])==3):
            # print("fight, and lose 3 times");
            coins_to_obtain =  int(coins_to_obtain * 1.1)
            delta_attack = -2 
            delta_defense = 2
            delta_speed = 2
            self.history_record = [] 
        
        # fight, and defeat someone in the last round 
        elif (self.history_record[-1] == 2):
            # print("fight, and defeat someone in the last round ")
            # print("fight, and defeat someone in the last round ")
            coins_to_obtain = 40 
            delta_attack += 1 
            
        # fight, not win and lose 3 times, not kill anyone in the last fight 
        else: 
            # print("normal situation")
            coins_to_obtain = 20 
        
        self.coins += coins_to_obtain
        coins_to_obtain = 20

    def buy_prop_upgrade(self):
        while(self.coins >= 50): 
            upgd = input("Do you want to upgrade properties for Fighter %d? A for attack. D for defense. S for speed. N for no\n" % self.NO)
            if upgd == "N":
                break
            else: 
                self.coins -= 50 
                if upgd == "A":
                    self.attack += 1 
                elif upgd == "D":
                    self.defense += 1
                elif upgd == "S":
                    self.speed += 1
            
        
    def update_properties(self):
        
        global delta_attack
        global delta_defense
        global delta_speed
        
        self.attack = max(self.attack+delta_attack,1)
        self.defense = max(self.defense+delta_defense,1)
        self.speed = max(self.speed+delta_speed,1)
        
        delta_attack = -1
        delta_defense = -1
        delta_speed = -1

    def record_fight(self, fight_result):
        if len(self.history_record) >= 3: 
            self.history_record.pop(0)    
        # fight result:
        # rest: *
        # 0: tie
        # 1: win, 2: win and defeate the opponent
        # -1: lose, -2: lose and get defeated
        self.history_record.append(fight_result)
