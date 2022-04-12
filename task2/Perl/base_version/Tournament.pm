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

use strict;
use warnings;

package Tournament;
use base_version::Team;
use base_version::Fighter;
use List::Util qw( min max ); 

sub new{
    my $class = shift;
    my $self = {
        _team1 => undef,
        _team2 => undef,
        _round_cnt => 1, 
    };
    return bless $self, $class; 
}

sub input_fighters{
    my $self = shift;
    my $team_NO = shift;
    print "Please input properties for fighters in Team $team_NO\n";
    my @fighter_list_team = ();
    for my $fighter_idx (4 * ($team_NO - 1) + 1..4 * ($team_NO - 1) + 4){
        while (1){
            my $properties = <STDIN>;
            my @properties = split(' ', $properties);

            my $HP = int($properties[0]);
            my $attack = int($properties[1]);
            my $defence = int($properties[2]);
            my $speed = int($properties[3]);

            if ($HP + 10 * ($attack + $defence + $speed) <= 500){
                my $fighter = new Fighter($fighter_idx, $HP, $attack, $defence, $speed);
                push (@fighter_list_team, $fighter);
                last;
            }
            print "Properties violate the constraint\n";
        }
    }
    return @fighter_list_team;
}

sub set_teams{
    my $self = shift;
    my $team1 = shift;
    my $team2 = shift;
    $self->{_team1} = $team1;
    $self->{_team2} = $team2;
}

sub play_one_round{
    my $self = shift;
    my $fight_cnt = 1;
    print "Round $self->{_round_cnt}\n";
    my $team1_fighter;
    my $team2_fighter;
    while (1){
        $team1_fighter = $self->{_team1}->get_next_fighter();
        $team2_fighter = $self->{_team2}->get_next_fighter();

        if (defined($team1_fighter) == 0 or defined($team2_fighter) == 0){
            last;
        }

        my $fighter_first = $team1_fighter;
        my $fighter_second = $team2_fighter; 
        if ($team1_fighter->{_speed} < $team2_fighter->{_speed}){
            $fighter_first = $team2_fighter;
            $fighter_second = $team1_fighter;
        }

        my $damage_first = max($fighter_first->{_attack}-$fighter_second->{_defense},1);
        $fighter_second->reduce_HP($damage_first);
        my $damage_second = undef;
        if ($fighter_second->{_defeated} == 0){
            $damage_second = max($fighter_second->{_attack}-$fighter_first->{_defense},1);
            $fighter_first->reduce_HP($damage_second);
        }

        my $winner_info = "tie";
        if (defined($damage_second) == 0){
            $winner_info = join "Fighter", $fighter_first->{_NO}, "wins";
        }
        else{
            if($damage_first > $damage_second){
                $winner_info = "Fighter $fighter_first->{_NO} wins";
            }
            elsif($damage_second > $damage_first){
                $winner_info = "Fighter $fighter_second->{_NO} wins";
            }
        }

        print "Duel $fight_cnt: Fighter $team1_fighter->{_NO} VS Fighter $team2_fighter->{_NO}, $winner_info\n";
        $team1_fighter->print_info();
        $team2_fighter->print_info();
        $fight_cnt += 1;
    }

    print "Fighters at rest:\n";
    for my $team_no (1..2){
        my $team_fighter;
        if ($team_no == 1){
            $team_fighter = $team1_fighter;
        }
        else{
            $team_fighter = $team2_fighter;
        }

        while(1){
            if (defined($team_fighter) == 1) {
                $team_fighter->print_info();
            }
            else{
                last;
            }
            if ($team_no == 1){
                $team_fighter = $self->{_team1}->get_next_fighter();
                last;
            }
            else{
                $team_fighter = $self->{_team2}->get_next_fighter();
                last;
            } 
        }
    }

    $self->{_round_cnt} += 1;
}

sub check_winner(){
    my $self = shift;
    my $team1_defeated = 1; 
    my $team2_defeated = 1; 
    my $fighter_list1 = $self->{_team1}->{_fighter_list};
    my $fighter_list2 = $self->{_team2}->{_fighter_list};

    for my $i (0..scalar(@{$fighter_list1})-1){
        if (@{$fighter_list1}[$i]->{_defeated} == 0){
            $team1_defeated = 0;
            last;
        }
    }

    for my $j (0..scalar(@{$fighter_list2})-1){
        if (@{$fighter_list2}[$j]->{_defeated} == 0){
            $team2_defeated = 0;
            last;
        }
    }

    my $stop = 0;
    my $winner = 0; 
    if ($team1_defeated){
        $stop = 1;
        $winner = 2;
    }
    elsif ($team2_defeated){
        $stop = 1;
        $winner =1 ;
    }

    return $stop, $winner;
    
}



sub play_game{
    my $self = shift;

    my @fighter_list_team1 = $self->input_fighters(1);
    my @fighter_list_team2 = $self->input_fighters(2);
    
    my $team1 = new Team(1);
    my $team2 = new Team(2);
    
    $team1->set_fighter_list(\@fighter_list_team1);
    $team2->set_fighter_list(\@fighter_list_team2);
    
    $self->set_teams($team1, $team2);
    
    print("===========\n");
    print("Game Begins\n");
    print("===========\n\n");

    my $stop;
    my $winner; 

    while (1){
        print("Team 1: please input order\n");
        my $order1;
        my @order1 = ();
        while(1){
            $order1 = <STDIN>;
            my @order1_str = split(' ', $order1);
            my $flag_valid = 1; 
            my $undefeated_number = 0;
            for my $order1_str_ (@order1_str){
                push(@order1, int($order1_str_));
            }
            for my $order (@order1){
                if ($order < 1 or $order > 4){
                    print("order size wrong\n");
                    $flag_valid = 0;
                }
                elsif (@{$self->{_team1}->{_fighter_list}}[$order-1]->{_defeated}){
                    print("given order defeated\n");
                    $flag_valid = 0;
                }
            }

            my %seen=();
            my @unique = grep { ! $seen{$_} ++ } @order1;
            if (scalar(@order1) != scalar(@unique)){
                $flag_valid = 0;
            }
 
            for my $i (0..3){  
                if (@{$self->{_team1}->{_fighter_list}}[$i]->{_defeated} == 0){
                    $undefeated_number += 1;
                }    
            }

            if ($undefeated_number != scalar(@order1)){
                print("undefeated_number != scalar\n");
                $flag_valid = 0;
            }
            if ($flag_valid == 1){
                last;
            }
            else{
                print "Invalid input order\n";
            }
        }


        print("Team 2: please input order\n");
        my $order2;
        my @order2 = ();
        while(1){
            $order2 = <STDIN>;
            my @order2_str = split(' ', $order2);
            my $flag_valid = 1; 
            my $undefeated_number = 0;
            for my $order2_str_ (@order2_str){
                push(@order2, int($order2_str_));
            }
            for my $order (@order2){
                if ($order < 5 or $order > 8){
                    print("order size wrong\n");
                    $flag_valid = 0;
                }
                elsif (@{$self->{_team2}->{_fighter_list}}[$order-5]->{_defeated}){
                    print("given order defeated\n");
                    $flag_valid = 0;
                }
            }

            my %seen=();
            my @unique = grep { ! $seen{$_} ++ } @order2;
            if (scalar(@order2) != scalar(@unique)){
                $flag_valid = 0;
            }
 
            for my $i (0..3){  
                if (@{$self->{_team2}->{_fighter_list}}[$i]->{_defeated} == 0){
                    $undefeated_number += 1;
                }    
            }

            if ($undefeated_number != scalar(@order2)){
                print("undefeated_number != scalar\n");
                $flag_valid = 0;
            }
            if ($flag_valid == 1){
                last;
            }
            else{
                print "Invalid input order\n";
            }
        }
        
        $self->{_team1}->set_order(\@order1);
        $self->{_team2}->set_order(\@order2);
        $self->play_one_round();
        ($stop, $winner) = $self->check_winner();
        if ($stop == 1){
            last;
        }
    }

    print "Team $winner wins"
 
}
1;