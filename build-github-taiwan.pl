#!/usr/bin/env perl
use warnings;
use strict;
use LWP::Simple;
use JSON::XS;

my @list =  qw(
        audreyt clkao c9s gugod hlb Dannvix mrmoneyc freehaha BlueT shelling
        gslin xdite CindyLinz RJKing dryman keitheis drbean bobchao matrixneo
        gdxhsw darkhero pct zx1986 toomore oobe monoceroi hcchien medicalwei
        aminzai acelan othree EragonJ penk cclien alicekey zonble PCMan
        billy3321 chihchun fourdollars hychen yurenju appleboy lukhnos clsung
        kanru handlino gaod yrchen ajneok jeffhung MLChen tsung ihower ericsk
        chiehwen itszero tsechingho hypo tzangms julian9 shepjeng dlackty deduce yllan
        kcliu timdream pixnet drakeguan lightlycat mose wmh spin
);


$|++;
my @result = ();

@list = sort @list;
print "Found " . scalar(@list) . " developers\n";
print "Gathering information...\n";
for my $id ( @list ) {
    print $id , " ";
    my $data;

    eval {
        my $response = get('http://github.com/api/v2/json/user/show/' . $id );
        my $retry = 10 unless $response;
        while( ! $response && $retry-- ) {
            print ".";
            $response = get('http://github.com/api/v2/json/user/show/' . $id );
        }
        $data = decode_json( $response );
        $data = $data->{user};
    };

    if ( $@ ) {
        warn "ERROR!  " . $id . "  :  " . $@;
    }
    push @result , $data if $data;

=pod

    user:
        id: 23
        login: defunkt
        name: Kristopher Walken Wanstrath
        company: LA
        location: SF
        email: me@email.com
        blog: http://myblog.com
        following_count: 13
        followers_count: 63
        public_gist_count: 0
        public_repo_count: 2

=cut

}

print "DONE\n";

@result = sort { $b->{followers_count} <=> $a->{followers_count} } @result;

open FH , ">" , "github-users.json";
print FH encode_json( \@result );
close FH;
