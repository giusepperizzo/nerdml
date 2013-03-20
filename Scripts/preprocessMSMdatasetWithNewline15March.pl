#!/usr/bin/perl -w 

use Lingua::EN::Tokenizer::Offsets qw/token_offsets get_tokens/;
use strict ; 

open FILE, $ARGV[0] ;

while(my $input = <FILE>)
	{
 	my @PER ;
 	my @LOC ;
 	my @ORG ;
 	my @MISC ; 
 	chomp $input ;
	my @parts = split/\t/,$input ;
	my @NEs = () ; 
	if($parts[1] =~ /;/)
		{
		@NEs = split/;/,$parts[1] ;
		} 
	else
		{
		chomp $parts[1] ;
		push @NEs, $parts[1] ; 
		}
	#print $parts[0]."\t" ;
	for(my $x = 0 ; $x < @NEs; $x++)
		{
		if($NEs[$x] =~ /PER\//)
			{
			$NEs[$x] =~ s/PER\///;
			push @PER, $NEs[$x] ; 
		#	print $NEs[$x]."\n";
			}
		elsif($NEs[$x] =~ /LOC\//)
			{
			$NEs[$x] =~ s/LOC\///;
			push @LOC, $NEs[$x] ; 
			}
		elsif($NEs[$x] =~ /ORG\//)
			{
			$NEs[$x] =~ s/ORG\///;
			push @ORG, $NEs[$x] ; 
			}
		if($NEs[$x] =~ /MISC\//)
			{
			$NEs[$x] =~ s/MISC\///;
			push @MISC, $NEs[$x] ; 
	#		print $NEs[$x] ; 
			}
		}
	for ( my $y = 0 ; $y < @PER ; $y++)
		{
		#print $PER[$y]." " ;
		my $person = $PER[$y] ; 
		$person =~ s/\s$//g ; 
		$person =~ s/ /PER /g ;
		$person =~ s/$/PER/ ; 
		$parts[2] =~ s/$PER[$y]/$person/g ;
		#print $parts[2] ; 
		}
	for ( my $y = 0 ; $y < @LOC ; $y++)
		{
		#print $LOC[$y]." " ; 
		my $location = $LOC[$y] ;
		$location =~ s/\s$//g ; 
		$location =~ s/ /LOC /g ;
		$location =~ s/$/LOC/ ; 
		$parts[2] =~ s/$LOC[$y]/$location/g ;
		#print $parts[2] ; 
		}
	for ( my $y = 0 ; $y < @ORG ; $y++)
		{
		#print $ORG[$y]." " ; 
		my $organisation = $ORG[$y] ; 
		$organisation =~ s/\s$//g ;
		$organisation =~ s/ /ORG /g ;
		$organisation =~ s/$/ORG/ ; 
		$parts[2] =~ s/$ORG[$y]/$organisation/g ;
		#print $parts[2] ;
		}
	for ( my $y = 0 ; $y < @MISC ; $y++)
		{
		#print $MISC[$y]." " ; 
		my $misc = $MISC[$y] ; 
		$misc =~ s/\s$//g ;
		$misc =~ s/ /MISC /g ;
		$misc =~ s/$/MISC/ ; 
		$parts[2] =~ s/$MISC[$y]/$misc/g ;
		#print $parts[2] ;
		}
	#my $tokens = get_tokens($parts[2]);     
	#my @tokens = @$tokens ;
	$parts[2] =~ s/\s+/ /g ; 
	my @tokens = split/ /, $parts[2] ;
	for(my $x = 0 ; $x < @tokens ; $x++)
		{
		#print $tokens[$x]." " ;
		if($tokens[$x] =~ /PER$/)
			{
			$tokens[$x] =~ s/PER$// ; 
			$tokens[$x] =~ s/PER$// ; 
			print $tokens[$x]."\tI-PER\n" ;
			}
		elsif($tokens[$x] =~ /ORG$/)
			{
			$tokens[$x] =~ s/ORG$// ; 
			$tokens[$x] =~ s/ORG$// ; 
			print $tokens[$x]."\tI-ORG\n" ;
			}
		elsif($tokens[$x] =~ /LOC$/)
			{
			$tokens[$x] =~ s/LOC$// ; 
			$tokens[$x] =~ s/LOC$// ; 
			print $tokens[$x]."\tI-LOC\n" ;
			}
		elsif($tokens[$x] =~ /MISC$/)
			{
			$tokens[$x] =~ s/MISC$// ; 
			$tokens[$x] =~ s/MISC$// ; 
			print $tokens[$x]."\tI-MISC\n" ;
			}
		else
			{
			print $tokens[$x]."\tO\n" ; 
			}
		}
	print "_ENDOFTWEET_$parts[0]\tO\n" ;  # This ensures that an empty line is printed after each tweet
	}