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

# switch version here

# use base_version::Tournament;
# my $tournament = new Tournament();

use advanced_version::AdvancedTournament;
my $tournament = new AdvancedTournament();

$tournament -> play_game();