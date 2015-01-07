#!/usr/bin/perl -w

BEGIN {
	chdir 't';
	push @INC, qw(../ ../lib);
}
use Test::More 'no_plan';
require_ok 'WWW::Salesforce::Id';
use WWW::Salesforce::Id;

while (<DATA>) {
	next 
		unless (/^(?<not_ok>\d)\s+(?<id>\S+)/);

	my $test_id = $+{id};
	my $not_ok = $+{not_ok};
	my $id;
	eval {
		chomp;
		$id = WWW::Salesforce::Id->new($test_id);
	};
	if ($@) {
		ok(($not_ok ? 1 : 0), $@);
	}
	else {
		ok(($not_ok ? 0 : 1), "$test_id ->".$id->id);
	}
}

done_testing;
__DATA__
1 af434fd
1 320000013mFVbAAM
0 320000013mFVbAA
0 0032000000U8KuMAAV
0 00320000013mFVbAAM
1 003konskykokotKAAB
0 0012000001CFuL3
0 a0M2000000tIZJc
0 a0o20000007INBN
0 0032000000IfxqqAAB
0 0032000000IfyavAAB
1 00320CG000IfyavAAB
0 0032000000IfyLUAAZ
0 0032000000IfyRpAAJ
0 0032000001AAHAuAAP
1 0032000001AAHAuAAC
