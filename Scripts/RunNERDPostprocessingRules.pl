#!/usr/bin/perl -w 

use strict ;

open FILE, $ARGV[0] ; 

while (my $input = <FILE>)
	{
	if($input =~ /_URL_/)
		{
		$input =~ s/I-ORG/O/g ;
		$input =~ s/I-PER/O/g ;
		$input =~ s/I-MISC/O/g ;
		$input =~ s/I-LOC/O/g ;
		}
	if($input =~ /_Mention_/)
		{
		$input =~ s/I-ORG/O/g ;
		$input =~ s/I-PER/O/g ;
		$input =~ s/I-MISC/O/g ;
		$input =~ s/I-LOC/O/g ;
		}
	if($input =~ /_HASHTAG_/)
		{
		$input =~ s/I-ORG/O/g ;
		$input =~ s/I-PER/O/g ;
		$input =~ s/I-MISC/O/g ;
		$input =~ s/I-LOC/O/g ;
		}
	print $input ;
	}