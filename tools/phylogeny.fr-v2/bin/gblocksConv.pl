#!/usr/bin/perl

use strict;
use warnings;
use Bio::AlignIO;

my $id=0;
open (FILE,$ARGV[0]) || die "impossible d'ouvrir le fichier";
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
close FILE;
