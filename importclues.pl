#!/usr/bin/perl
use JSON 'encode_json';
use List::Util qw(max);


$json = JSON->new;
$json = $json->pretty([1]);
#$json = $json->canonical([1]);
my $file = '/home/jonron/dev/crosswordswithdoug/crosswordimporter/puzzles/Aug2816.txt';

#open my $fh, '<', $file or die qq{Can't open "$file" for input: $!};
open(FH, '<', $file) or die $!;

my %clues = ('ACROSS' => {},
    'DOWN' => {}
);

my @across;
my @down;

my @clueArray;
my @acrossArray;
my @downArray;

my $currentClueNum = 1;
my $currentClueText = "";
my $puzzleTitles = 

my $index = 0;

my $acrossdown = "";
while (<FH>) {
    $line = $_;
    $line =~ s/\R//g;
    if($index == 1) {
        $puzzleTitle = $line;
    }
    ++$index;
    if($line =~ /^ACROSS|DOWN$/) {
        $acrossdown = $line;
        next;
    }
    $acrossdown eq "" and next;
    if($line =~ /^(\d+) (.+)$/) {
        $currentClueNum = $1;

        if($acrossdown eq "ACROSS") {
            $acrossArray[$currentClueNum] = "$line";
        }else{
            $downArray[$currentClueNum] = "$line";
        }
        $clues{$acrossdown}->{$currentClueNum} = $2;
    } else {
        if($acrossdown eq "ACROSS") {
            $acrossArray[$currentClueNum] = join " ", $acrossArray[$currentClueNum], $line;
        }else{
            $downArray[$currentClueNum] = join " ", $downArray[$currentClueNum], $line;
        }
        $clues{$acrossdown}->{$currentClueNum} = join " ", $clues{$acrossdown}{$currentClueNum}, $line;
    }

        
        #print $line;
}


close(FH);

#print "\nDown array\n";
#print "$_\n" for @downArray;
#print "Across array\n";
#print "$_\n" for @acrossArray;

#my %downHash = %{$clues{'DOWN'}};
#my %acrossHash = %{$clues{'ACROSS'}};
#my @temp = %downHash;
#print "@temp";
#my @temp = %acrossHash;
#print "@temp";
#my $highestAcross = max keys %acrossHash;
#my $highestDown = max keys %downHash;

my %acrossDownHash = ('TITLE' => $puzzleTitle,
    'ACROSS' => \@acrossArray,
    'DOWN' => \@downArray
);

#print "@{[ %acrossDownHash ]}\n";

#print "MAXDOWN: $highestDown\n\n\n";
#print "MAXACROSS $highestAcross\n\n\n";

#$clues = sort(keys(cr


$jsonstring = $json->utf8->encode(\%acrossDownHash);
print "$jsonstring\n";
