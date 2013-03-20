#!/usr/bin/perl -w 

use strict ;
use Text::Unidecode ;

open FILE, $ARGV[0] ;

# 10/nerdANDstanford_POStaggedPostProcessedInputForMLFeatureGeneration_aligned.mcoll

#print "1 token,2 pos,3 initcap,4 allcaps,5 prefix,6 suffix,7 capitalisationfrequency,8 start,9 end,10 alchemy,11 spotlight,12 extractiv,13 lupedia, 14 opencalais,15 saplo,16 textrazor,17 wikimeta,18 yahoo,19 zemanta,20 stanford, 21 ritter, 22 class\n"; 
my @elements ;
my @tweet ; 
my @GS ; 
my @POS ; 
my $extractors = "" ; 
my @extractors ; 
my $tweettext = "" ; 

# my @personnames ; 
# open PERSONS, "/Users/marieke/Dropbox/MSM2013/personnames" ;
# while(my $input = <PERSONS>)
# 	{
# 	next if($input !~ /\w/) ;
# 	$input =~ s/[[:cntrl:]]+//g ;
# 	$input = unidecode($input) ;
# 	chomp $input ;
# 	next if(length($input) < 5) ;
# 	$input =~ s/^\s+//g ;  
# 	push @personnames, $input ;
# 	}
# close(PERSONS) ;
# 
# my @noNEs ; 
# open NONES, "/Users/marieke/Dropbox/MSM2013/notnamedentity" ;
# while(my $input = <NONES>)
# 	{
# 	chomp $input ; 
# 	push @noNEs, $input ;
# 	}	
# close(NONES) ;
# 
# my @locationnames ; 
# open LOC, "/Users/marieke/Dropbox/MSM2013/locations" ;
# while(my $input = <LOC>)
# 	{
# 	chomp $input ; 
# 	push @locationnames, $input ;
# 	}
# close(LOC) ;
# 
# my @miscnames ; 
# open MISC, "/Users/marieke/Dropbox/MSM2013/miscellaneous" ;
# while(my $input = <MISC>)
# 	{
# 	chomp $input ; 
# 	push @miscnames, $input ;
# 	}
# close(MISC) ;
# 
# my @organisationnames ; 
# open ORG, "../../../organisations" ;
# while(my $input = <ORG>)
# 	{
# 	chomp $input ; 
# 	push @organisationnames, $input ;
# 	}
# close(ORG) ;

while (my $input = <FILE>)
	{
#	print $input ;
	chomp $input ; 
	if($input !~ /^_ENDOFTWEET/)
		{ 	
		@elements = split/ /,$input ;
		my $token = $elements[0] ;
		$token =~ s/PER$//g ; 
		$token =~ s/ORG$//g ;
		$token =~ s/LOC$//g ; 
		$token =~ s/MISC$//g ;
		$tweettext = $tweettext." ".$token ; 
	#	print $token."\t" ; 
	#	push @tweet, $token ; 
	#	print $elements[scalar(@elements)-1]."\n" ;
		push @GS, $elements[2] ; 
		push @POS, $elements[1] ; 
		for(my $z = 3; $z < @elements ; $z++)
			{
			$extractors = $extractors." ".$elements[$z] ; 
			}
		$extractors =~ s/^\s+//g ; 
		$extractors =~ s/0/O/g ; 	
		push @extractors, $extractors ;
		$extractors = "" ;
		}
	else
		{ 
# 		for(my $a = 0 ; $a < @personnames ; $a++)
# 			{
# 			if($tweettext =~ / \Q$personnames[$a]\E /i)
# 				{
# 				my $matched = $& ;
# 		#		print $matched."\n" ;  
# 				my $annot = $matched ; 
# 				$annot =~ s/ /PERGAZET /g ;
# 				$annot =~ s/$/PERGAZET/g ;
# 				$tweettext =~ s/$matched/$annot/g ; 
# 				$matched = "" ;
# 				$annot = "" ; 
# 				}	
# 			}
		$tweettext =~ s/^\s+//g ; 
		my @tweet = split/ /, $tweettext ; 
		my $initcap = 0 ;
		my $allcaps = 0 ; 
		my $pergazet = 0 ;
		my $locgazet = 0 ;
		my $miscgazet = 0 ;
		my $orggazet = 0 ;
		my $nonegazet = 0 ;   
#		my $ish = 0 ;
#		my $tch = 0 ; 
#		my $an = 0 ;
#		my $ese = 0 ; 
		my $capmeaning = 0 ;   
		my $number_of_caps = 0 ;
		my $cap_important = 0 ; 
		my $capitalisationfreq = 0 ;
		for(my $x = 0 ; $x < @tweet ; $x++)
			{
			if(substr($tweet[$x],0,1) =~ /[A-Z]/)
				{
				$number_of_caps++ ;  
				} 
			}
		unless($number_of_caps == 0 )
			{
			my $unrounded = $number_of_caps / scalar(@tweet) ; 
			$capitalisationfreq = sprintf("%.3f", $unrounded);;
			}
		for(my $y = 0 ; $y < @tweet ; $y++)
			{
			if(substr($tweet[$y],0,1) =~ /[A-Z]/)
				{
				$initcap = 1 ; 
				} 
			if($tweet[$y] =~ /[A-Z]/ && $tweet[$y] !~ /[a-z]/)
				{
				$allcaps = 1 ; 
				}
			# if($tweet[$y] =~ /ish$/)
# 				{
# 				$ish = 1 ; 
# 				}
# 			if($tweet[$y] =~ /tch$/)
# 				{
# 				$tch = 1 ; 
# 				}
# 			if($tweet[$y] =~ /an$/ || $tweet[$y] =~ /ans$/)
# 				{
# 				$an = 1 ; 
# 				}
#			if($tweet[$y] =~ /ese$/)
#				{
#				$ese = 1 ; 
#				}
			my $suffix = substr($tweet[$y],-3) ;
			my $prefix = substr($tweet[$y],0,3) ; 
			my $start = 0 ;
			my $end = 0 ;
			if ($y == 0)
				{
				$start = 1; 
				}
			if($y == scalar(@tweet)-1)
				{
				$end = 1 ; 
				}
			if($tweet[$y] =~ /PERGAZET/)
				{
				$pergazet = 1 ; 
				$tweet[$y] =~ s/PERGAZET//g ; 
				}
			if($tweet[$y] =~ /LOCAZET/)
				{
				$locgazet = 1 ; 
				$tweet[$y] =~ s/LOCGAZET//g ; 
				}
			if($tweet[$y] =~ /ORGGAZET/)
				{
				$orggazet = 1 ; 
				$tweet[$y] =~ s/ORGGAZET//g ; 
				}
			if($tweet[$y] =~ /MISCGAZET/)
				{
				$miscgazet = 1 ; 
				$tweet[$y] =~ s/MISCGAZET//g ; 
				}
			if($tweet[$y] =~ /NONEGAZET/)
				{
				$nonegazet = 1 ; 
				$tweet[$y] =~ s/NONEGAZET//g ; 
				}
			print $tweet[$y]." ".$POS[$y]." ".$initcap." ".$allcaps." ".$prefix." ".$suffix." ".$capitalisationfreq." ".$start." ".$end." ".$extractors[$y]." ".$GS[$y]."\n" ;
			}
		@tweet =() ; 
		@GS = () ; 
		@POS = () ;
		@extractors = () ;
		$tweettext = "" ;
		print "\n" ; 
		}			
	} 