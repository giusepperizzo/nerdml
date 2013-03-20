#!/usr/bin/perl -w 

use strict ;

open FILE, $ARGV[0] ; 

while(my $input = <FILE>)
	{
	chomp $input ; 
	$input =~ s/^\s+//g ; 
	$input =~ s/\s+/\t/g ; 
	next if($input !~ /^[0-9]/) ;
	#print $input."\n"  ;  
	my @parts = split/\t/, $input ; 
	my $gs = $parts[1] ; 
#  	for(my $x = 0 ; $x < @parts ; $x++)
#  		{
#  		print $x." ".$parts[$x]."\t" ; 
#  		}
#  	print "\n" ;
# 	exit ; 
	$gs =~ s/.://g ; 
#	print $gs."\n" ;
	my $predicted = $parts[2] ;
	$predicted =~ s/.://g ;  
	my $token = substr($parts[scalar(@parts)-1],1,length($parts[scalar(@parts)-1])-2);
	print $token." ".$gs." ".$predicted."\n" ; 
	}