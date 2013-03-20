#!/usr/bin/perl -w 

use strict ; 

open FILE, $ARGV[0] ; 

my @elements ; 
my @NEs ; 
my $prev = 0 ; 
my $ne = "" ;

while(my $input = <FILE>)
	{
	chomp $input ;  
	if($input !~ /^_ENDOFTWEET/)
		{ 	
		@elements = split/ /,$input ;
		my $token = $elements[0] ;
		my $answer = $elements[scalar(@elements)-1] ;
	#	print $token."\t".$answer."\n" ;
		if($answer ne $prev && length($ne) > 0)
			{
			$ne =~ s/I-//g ; 
			push @NEs, $ne ;  
			$ne = "" ; 
			}
		if($answer =~ /I-/ && $answer ne $prev)
			{
			$ne = $answer."/".$token ; 
			}
		elsif($answer =~ /I-/ && $answer =~ $prev)
			{
			$ne = $ne." ".$token ;
			}	
		$prev = $answer ; 
		}
	else
		{
		if(length($ne) > 0)
			{
			$ne =~ s/I-//g ; 
			push @NEs, $ne ; 
			$ne = "" ; 
			}
		$prev = 0 ; 
		$input =~ s/_ENDOFTWEET_//g ;
		print $input."\t" ;  
		if(scalar(@NEs) > 0)
			{
			for(my $x = 0 ; $x < @NEs ; $x++)
				{
				print $NEs[$x].";" ;
				}
			}
		print "\t\n" ; 
		@NEs = () ; 
		@elements = () ;
		}
	}