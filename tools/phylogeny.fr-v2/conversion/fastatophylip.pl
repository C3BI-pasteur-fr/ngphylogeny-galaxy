#!/usr/bin/perl

# This a shell wrapper to convert MSA format: FASTA <-> PHYLIP
#
# Author: C. Vernette, V. Lefort
# Date: June 2014
# Version: 1.0
#

#The arguments are: the input file; the output file; the choice of the user

use strict;
use warnings;
use Bio::AlignIO;

my $id=0;
open (FILE,$ARGV[0]) || die "impossible d'ouvrir le fichier";

#Convert a file from FASTA to PHYLIP

if ($ARGV[2] eq "phylip"){
	my $in=Bio::AlignIO->new(-file=> $ARGV[0] ,-format=>'fasta');
	while (<FILE>){
		if( /^>(.+)/ ){
			my $ide= length($1);
			if($ide>$id){
				$id=$ide;
			}
		}
	}
	$id=$id+5;
	my $out=Bio::AlignIO->new(-file=> ">>$ARGV[1]",-format=>'phylip',-idlength=>$id);
	while(my $aln=$in->next_aln){
		$out->write_aln($aln);
	}
}

#Convert a file from PHYLIP to FASTA

if ($ARGV[2] eq "fasta"){
	open(OUT, ">>$ARGV[1]") || die "Can't open out $ARGV[1]: $!\n";
	while(my $line = <FILE>) {
		chomp $line;
		next if (!$line || $line =~ /\d+\s+\d+/);
		if($line =~ /^(.*)\s+(\S+)\s*$/) {
			my $name = $1;
			my $sequence = $2;
			$name =~ s/\s+$//;
			print OUT ">$name\n$sequence\n";
		}
	
	}
	close OUT;
}

close FILE;
