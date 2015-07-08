#!C:\Strawberry\perl\bin
#accepts a CIDER notation IP in the terminal, then outputs the range of IP address to some file. Be careful, it can sometimes take a while. 
use strict;
use warnings;

#converts a length = 8 array of bits into a decimal int
sub convertArray { # @_ is a byte array
	my $sum = 0;
	my @array = @_;
	for(my $i = 7; $i >= 0; $i--) {
		$sum += $array[$i] * (2**(7-$i));
	}
	return $sum;
}

#assuming a byte, changes each bit after cider%8 to a 0
sub setBitsZero { # cider%8, arrayByte
	my $num = shift(@_);
	my @array = @_;
	
	for(my $i = $num; $i < 8; $i++){
		$array[$i] = 0;
	}
	
	return @array;
}

#assuming a byte, changes each bit after cider%8 to a 1
sub setBitsOne { # cider%8, arrayByte
	my $num = shift(@_);
	my @array = @_;
	
	for(my $i = $num; $i < 8; $i++){
		$array[$i] = 1;
	}
	
	return @array;
}

my $FILENAME = "/PATH/TO/OUTPUT/FILE"; #OUTFILE
my @OCTETS = (); #each int from the ip, (w.x.y.z)
my $COUNTER = 0; #with this we count
my $COUNTER2 =0; #and hold track of numbers that are relevant
my $CIDER; #the /x where x is the cider number

print "Processing...\n";

open(my $FH, '>', $FILENAME) or die "There was some error in opening this file\n";

print $FH "The range of $ARGV[0] \n\n";

$CIDER = substr($ARGV[0], index($ARGV[0], "/") +1);
$COUNTER = index($ARGV[0], ".", 0) ; #index of first "."
@OCTETS[0] = substr($ARGV[0], 0, $COUNTER);
$COUNTER2 = index($ARGV[0], ".", $COUNTER +1); #index of second "."

@OCTETS[1] = substr($ARGV[0], $COUNTER +1, ($COUNTER2 - $COUNTER) -1);

$COUNTER = index($ARGV[0], ".", $COUNTER2 +1); #index of third "."

@OCTETS[2] = substr($ARGV[0], $COUNTER2 +1, ($COUNTER - $COUNTER2) -1);

$COUNTER2 = index($ARGV[0], "/"); #index of "/"
@OCTETS[3] = substr($ARGV[0], $COUNTER +1, ($COUNTER2 - $COUNTER) -1);


$OCTETS[0] = int $OCTETS[0];
$OCTETS[1] = int $OCTETS[1];
$OCTETS[2] = int $OCTETS[2];
$OCTETS[3] = int $OCTETS[3];

if($CIDER == 0){
	print "This is every IP address.";
}

elsif($CIDER == 8){
	for(my $i = 0; $i < 256; ++$i){
		for(my $j = 0; $j < 256; ++$j){
			for(my $k = 0; $k < 256; ++$k){
				print $FH "$OCTETS[0].$i.$j.$k\n";
			}
		}
	}
	die "Done.\n";
}

elsif($CIDER == 16){
	for(my $i = 0; $i < 256; ++$i){
		for(my $j = 0; $j < 256; ++$j){
			print $FH "$OCTETS[0].$OCTETS[1].$i.$j\n";
		}
	}
	die "Done.\n";
}

elsif($CIDER == 24){
		for(my $i = 0; $i < 256; ++$i){
			print $FH "$OCTETS[0].$OCTETS[1].$OCTETS[2].$i\n";
		}
	die "done\n";
}

my @BITS = split(//,sprintf("%b",$OCTETS[0]));
my @BITS2 = split(//,sprintf("%b",$OCTETS[1]));
my @BITS3 = split(//,sprintf("%b",$OCTETS[2]));
my @BITS4 = split(//,sprintf("%b",$OCTETS[3]));


#add 0's to front until there are 8 bits in the array
while(!defined($BITS[7])){
	unshift(@BITS, '0');
}

while(!defined($BITS2[7])){
	unshift(@BITS2, '0');
}

while(!defined($BITS3[7])){
	unshift(@BITS3, '0');
}

while(!defined($BITS4[7])){
	unshift(@BITS4, '0');
}

if(0 < $CIDER && $CIDER < 8){
	#first byte
	for(my $i = convertArray(setBitsZero(($CIDER%8), @BITS2)); $i <= convertArray(setBitsOne(($CIDER%8), @BITS2)); ++$i){
		for(my $j = 0; $j < 256; ++$j){
			for(my $k = 0; $k < 256; ++$k){
				for(my $l = 0; $l < 256; ++$l){
					print $FH "$i.j.k.l\n";
				}
			}
		}
	}
	die "Done.\n";
}

elsif(8 < $CIDER && $CIDER < 16){
	#second byte
	for(my $i = convertArray(setBitsZero(($CIDER%8), @BITS2)); $i <= convertArray(setBitsOne(($CIDER%8), @BITS2)); ++$i){
		for(my $j = 0; $j < 256; ++$j){
			for(my $k = 0; $k < 256; ++$k){
				print $FH "$OCTETS[0].$i.j.k\n";
			}
		}
	}
	die "Done.\n";
}

elsif(16 < $CIDER && $CIDER < 24){
	#third byte
	for(my $i = convertArray(setBitsZero(($CIDER%8), @BITS3)); $i <= convertArray(setBitsOne(($CIDER%8), @BITS3)); ++$i){
		for(my $j = 0; $j < 256; ++$j){
			print $FH "$OCTETS[0].$OCTETS[1].$i.$j\n";
		}
	}
	die "Done.\n";
}



elsif(24 < $CIDER && $CIDER < 32){
	#last byte
	for(my $i = convertArray(setBitsZero(($CIDER%8), @BITS3)); $i <= convertArray(setBitsOne(($CIDER%8), @BITS3)); ++$i){
		print $FH "$OCTETS[0].$OCTETS[1].$OCTETS[2].$i\n";
	}
	die "Done.\n";
}

close $FH;
