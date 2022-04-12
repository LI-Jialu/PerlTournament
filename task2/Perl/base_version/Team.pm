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


package Team;

sub new {
    my $class = shift;
    my @temp_fighter_list = ();
    my @temp_order = ();
    my $self = {
        _NO => shift,
        _fighter_list => \@temp_fighter_list,
        _order => \@temp_order,
        _fight_cnt => 0, 
    };
    return bless $self, $class; 
}

# The input of setter is the reference, instead of array
sub set_fighter_list{
    my $self = shift;
    my $fighter_list_ref = shift;
    $self->{_fighter_list} = $fighter_list_ref;
}

# return the reference, instead of array
sub get_fighter_list{
    my $self = shift;
    return $self->{_fighter_list};
}

sub set_order{
    my $self = shift;
    my $order_ref = shift;
    $self->{_order} = $order_ref;
    $self->{_fight_cnt} = 0;
}

sub get_next_fighter{
    my $self = shift;
    if ($self->{_fight_cnt} >= length($self->{_order})){
        return undef;
    }
    
    my $prev_fighter_idx = @{$self->{_order}}[$self->{_fight_cnt}];
    my $fighter = undef;
   
    for my $fighter_ (@{$self->{_fighter_list}}){ 
        if (defined($prev_fighter_idx) == 0){
            last;
        }
        elsif ($fighter_->{_NO} == $prev_fighter_idx){
            $fighter = $fighter_;
            last;
        }
    }
    $self->{_fight_cnt} += 1;
    return $fighter;
}

1;