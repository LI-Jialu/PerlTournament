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

package AdvancedTournament;
use base_version::Team;
use advanced_version::AdvancedFighter;
use base_version::Tournament;
use List::Util qw(sum);
use List::Util qw( min max ); 

our @ISA = qw(Tournament); 


sub new{
    my $class = shift;
    my @defeat_record = ();
    my $self = {
        _team1 => undef,
        _team2 => undef,
        _round_cnt => 1, 
        _defeat_record => \@defeat_record,
    };
    return bless $self, $class; 
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

        $team1_fighter->buy_prop_upgrade();
        $team2_fighter->buy_prop_upgrade();

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
            $fighter_first->record_fight(2);
            $fighter_second->record_fight(-2);
            $fighter_second->{_defeated} = 1;
        }
        else{
            if($damage_first > $damage_second){
                $winner_info = "Fighter $fighter_first->{_NO} wins";
                $fighter_first->record_fight(1);
                $fighter_second->record_fight(-1);
            }
            elsif($damage_second > $damage_first){
                $winner_info = "Fighter $fighter_second->{_NO} wins";
                $fighter_first->record_fight(-1);
                $fighter_second->record_fight(1);
            }
            else{
                $fighter_first->record_fight(0);
                $fighter_second->record_fight(0);
            }
        }

        print "Duel $fight_cnt: Fighter $team1_fighter->{_NO} VS Fighter $team2_fighter->{_NO}, $winner_info\n";
        
        $team1_fighter->print_info();
        $team2_fighter->print_info();
        
        $self->update_fighter_properties_and_award_coins($team1_fighter);
        $self->update_fighter_properties_and_award_coins($team2_fighter);

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
                $team_fighter->record_fight('*');
                $self->update_fighter_properties_and_award_coins($team_fighter);
           
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

sub update_fighter_properties_and_award_coins{
    my $self = shift;
    my $fighter = shift;
    $fighter->obtain_coins();
    $fighter->update_properties();
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
                my $fighter = new AdvancedFighter($fighter_idx, $HP, $attack, $defence, $speed);
                push (@fighter_list_team, $fighter);
                last;
            }
            print "Properties violate the constraint\n";
        }
    }
    return @fighter_list_team;
}


1;