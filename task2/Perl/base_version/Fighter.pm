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

package Fighter;


sub new{
  my $class = shift;
  my $self = {
    _NO => int(shift), 
    _HP => int(shift), 
    _attack => int(shift), 
    _defense => int(shift),
    _speed => int(shift),
    _defeated => 0, 
  };
  return bless $self, $class; 
}

sub get_properties{
  my $self = @_;
  my %properties = (
    "NO" => $self->{_NO},
    "HP" => $self->{_HP},
    "attack" => $self->{_attack},
    "defense" => $self->{_defense},
    "speed" => $self->{_speed},
    "defeated" => $self->{_defeated},
  );
  return %properties;
}

sub reduce_HP{
  my $self = shift;
  my $damage = shift;
  $self->{_HP}  = $self->{_HP} - $damage;
  if ($self->{_HP} <= 0){
    $self->{_HP} = 0;
    $self->{_defeated} = 1;
  }
}

sub check_defeated{
  my $self = shift;
  return $self->{_defeated};
}

sub print_info{
  my $self = shift;
  my $defeated_info;
  if ($self->{_defeated}){
    $defeated_info = "defeated";
  }
  else{
    $defeated_info = "undefeated";
  }
  
  print "Fighter $self->{_NO} : HP: $self->{_HP} attack: $self->{_attack} defense: $self->{_defense} speed: $self->{_speed} $defeated_info\n";
}


1;
