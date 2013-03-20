#!/usr/bin/perl -w 

# script to align gold standard with _ENDOFTWEET_ lines to NERD output without _ENDOFTWEET_ lines 

use strict ; 

my @gs ; 
my @nerd ; 

open GS, $ARGV[0] ; 
while(my $input = <GS>)
	{
	chomp $input ; 
	next if($input =~ /^\s/) ; 
	push @gs, $input ; 
	}
close(GS) ; 

open NERD, $ARGV[1] ;
while(my $input = <NERD>)
	{
	chomp $input ; 
	next if($input =~ /^\s/) ; 
	push @nerd, $input ;
	}
close(NERD) ; 

for(my $y = 0 ; $y < scalar(@gs) ; $y++)
	{
	
	}

for(my $x = 0 ; $x < scalar(@gs) ; $x++)
	{
	my @parts = split/\t/,$gs[$x] ;
	my $insert = $parts[0]."\t".$parts[1] ; 
	if($parts[0] =~ /_ENDOFTWEET_/)
		{
		@nerd = arrayInsertAfterPosition(\@nerd, $x-1, $insert)  
		}
	print $gs[$x]."\t".$nerd[$x]."\n" ; 
	}

#for(my $y = 0 ; $y < @gs ; $y++)
#	{
#	print $gs[$y]."\t".$nerd[$y]."\n" ; 
#	}	
	
sub arrayInsertAfterPosition
{
  my ($inArray, $inPosition, $inElement) = @_;
  my @res         = ();
  my @after       = ();
  my $arrayLength = int @{$inArray};

  if ($inPosition < 0) { @after = @{$inArray}; }
  else {
         if ($inPosition >= $arrayLength)    { $inPosition = $arrayLength - 1; }
         if ($inPosition < $arrayLength - 1) { @after = @{$inArray}[($inPosition+1)..($arrayLength-1)]; }
       }

  push (@res, @{$inArray}[0..$inPosition],
              $inElement,
              @after);

  return @res;
}	