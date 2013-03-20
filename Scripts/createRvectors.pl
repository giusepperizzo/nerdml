#!/usr/bin/perl -w

use strict ; 

open FILE, $ARGV[0] ;

my $extractorname = "" ;
my $prec ;
my $recall ; 
my $f ; 
 
# print filename on first line 
# create  

while (my $input = <FILE>)
	{
	chomp $input ;
	if($input =~ /cross/)
		{
		$extractorname = $input ;
		$extractorname =~ s/_//g ;
		$extractorname =~ s/crossvalidation//g ; 
		$extractorname =~ s/\.conll//g ;
		next ; 
		}
	$input =~ s/^\s+//g ;
	$input =~ s/\s+/ /g ; 
	if($input =~ /LOC/)
		{
		my @parts = split/ /, $input ; 
		$parts[2] =~ s/\%;//g ; 
		$parts[4] =~ s/\%;//g ; 
		$prec = "prec_".$extractorname."<-c(".$parts[2]."," ;
		$recall = "recall_".$extractorname."<-c(".$parts[4]."," ;
		$f = "f_".$extractorname."<-c(".$parts[6]."," ;
		}
	if($input =~ /MISC/)
		{
		my @parts = split/ /, $input ; 
		$parts[2] =~ s/\%;//g ; 
		$parts[4] =~ s/\%;//g ; 
		$prec = $prec.$parts[2]."," ; 
		$recall = $recall.$parts[4]."," ;
		$f = $f.$parts[6]."," ; 
		} 
	if($input =~ /ORG/)
		{
		my @parts = split/ /, $input ; 
		$parts[2] =~ s/\%;//g ; 
		$parts[4] =~ s/\%;//g ; 
		$prec = $prec.$parts[2]."," ; 
		$recall = $recall.$parts[4]."," ;
		$f = $f.$parts[6]."," ;
		}
	if($input =~ /PER/)
		{	
		my @parts = split/ /, $input ; 
		$parts[2] =~ s/\%;//g ; 
		$parts[4] =~ s/\%;//g ; 
		$prec = $prec.$parts[2].")" ; 
		$recall = $recall.$parts[4].")" ;
		$f = $f.$parts[6].")" ;
		print $prec."\n".$recall."\n".$f."\n" ; 
		}
	}