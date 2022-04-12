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

package AdvancedFighter;

use base_version::Fighter;
use List::Util qw(sum);
use List::Util qw(all);
use List::Util qw( min max ); 


our @ISA = qw(Fighter); 

our $coins_to_obtain = 20;
our $delta_attack = -1;
our $delta_defense = -1;
our $delta_speed = -1;


sub new{
    my $class = shift;
    my @history_record = ();
    my $self = {
        _NO => int(shift), 
        _HP => int(shift), 
        _attack => int(shift), 
        _defense => int(shift),
        _speed => int(shift),
        _defeated => 0, 
        _coins => 0,
        _history_record => \@history_record,
    };
    return bless $self, $class;
}

sub obtain_coins{
    my $self = shift;
    
    local $coins_to_obtain;
    
    # take a rest
    if(@{$self->{_history_record}}[-1] eq '*'){
        # print("take a rest\n");
        $coins_to_obtain =  10;
    }

    # fight, and win 3 times 
    elsif((all { $_ > 0 } @{$self->{_history_record}}) and (scalar(@{$self->{_history_record}}) == 3)) {
        # print("fight, and win 3 times\n");
        $coins_to_obtain =  int(20 * 1.1);
    }

    # fight, and lose 3 times 
    elsif((all { $_ < 0 } @{$self->{_history_record}})and (scalar(@{$self->{_history_record}}) == 3)){
        # print("fight, and lose 3 times\n");
        $coins_to_obtain =  int(20 * 1.1);
    }

    # fight, and defeat someone in the last round 
    elsif (@{$self->{_history_record}}[-1] == 2){
        # print("fight, and defeat someone in the last round \n");
        $coins_to_obtain = 40;
    }

    # fight, not win and lose 3 times, not kill anyone in the last fight 
    else{
        # print("normal situation\n");
        $coins_to_obtain = 20;
    }
    $self->{_coins} += $coins_to_obtain;
    
}

sub buy_prop_upgrade{
    my $self = shift;
    
    while($self->{_coins} >= 50){
        print("Do you want to upgrade properties for Fighter $self->{_NO}? A for attack. D for defense. S for speed. N for no\n");
        my $upgd = <STDIN>;
        chomp $upgd;
        if ($upgd eq "N"){
            last;
        }
        else{
            $self->{_coins} -= 50;
            if ($upgd eq "A"){
                print("attack increase");
                $self->{_attack} += 1;
            }
            elsif ($upgd eq "D"){
                $self->{_defense} += 1;
            }
            elsif ($upgd eq "S"){
                $self->{_speed} += 1;
            }
        }
    }
}

sub update_properties{
    my $self = shift;

    local $delta_attack;
    local $delta_defense; 
    local $delta_speed;
    
    # take a rest
    if(@{$self->{_history_record}}[-1] eq '*'){
        $delta_attack = 1;
        $delta_defense = 1; 
        $delta_speed = 1;
    }

    # fight, and win 3 times 
    elsif((all { $_ > 0 } @{$self->{_history_record}}) and (scalar(@{$self->{_history_record}}) == 3)) {
        $delta_attack = 1;
        $delta_defense = -2; 
        $delta_speed = 1;
        my @history_record_emp = ();
        $self->{_history_record} = \@history_record_emp;
    }

    # fight, and lose 3 times 
    elsif((all { $_ < 0 } @{$self->{_history_record}})and (scalar(@{$self->{_history_record}}) == 3)){
        $delta_attack = -2;
        $delta_defense = 2; 
        $delta_speed = 2;
        my @history_record_emp = ();
        $self->{_history_record} = \@history_record_emp;
    }

    # fight, and defeat someone in the last round 
    elsif (@{$self->{_history_record}}[-1] == 2){
        $delta_attack += 1;
        $delta_defense = -1;
        $delta_speed = -1;
    }

    # fight, not win and lose 3 times, not kill anyone in the last fight 
    else{
        $delta_attack = -1;
        $delta_defense = -1;
        $delta_speed = -1;
    }

    $self->{_attack} = max($self->{_attack}+$delta_attack,1);
    $self->{_defense} = max($self->{_defense}+$delta_defense,1);
    $self->{_speed} = max($self->{_speed}+$delta_speed,1);
}


sub record_fight{
    my $self = shift;
    my $fight_result = shift;
    if (scalar(@{$self->{_history_record}}) >= 3){
        shift @{$self->{_history_record}}; 
        # fight result:
        # rest: *
        # 0: tie
        # 1: win, 2: win and defeate the opponent
        # -1: lose, -2: lose and get defeated   
    }
    push(@{$self->{_history_record}},$fight_result);
    
}



