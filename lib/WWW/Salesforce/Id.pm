#!/usr/bin/perl
package WWW::Salesforce::Id;

use strict;
use warnings;
use Data::Dumper;

my @_31 = ('A' .. 'Z', '0' .. '5');
my $debug = 0;

print Dumper(@_31)
	if $debug;

sub new {
	my ($class, $id) = @_;

	die "Invalid Id. Id String must be 15 or 18 characters. Is ".length($id)."."
		if _validate($id) == 0;

	my @id = split('', $id);
	my $is18 = scalar @id == 18 ? 1 : 0;

	my $self = {
		id => $id,
		is18 => $is18,
		object_type => [ @id[0 .. 2] ],
		checksum => ($is18 ? join('', @id[15 .. 17]) : undef),
		id_parts => [ @id ],
	};

	if ($is18) {
		my $cs = _compute_checksum($self);
		if ($cs ne $self->{checksum}) {
			die "Invalid Id checksum for '$id'. Computed '$cs' does not match '$self->{checksum}'";
		}
	}
	else {
		$self->{checksum} = _compute_checksum($self);
		$self->{id} .= $self->{checksum};
	}

	return bless $self, $class;
};

sub _validate {
	my ($id) = @_;

	return 15
		if $id =~ /^[0-9a-zA-Z]{15}$/;

	return 18
		if $id =~ /^[0-9a-zA-Z]{18}$/;

	return 0;
};

sub _compute_checksum {
	my ($self) = @_;

	my @id = @{$self->{id_parts}};
	my @computed_checksum = ();
	my @nimbles = ();

	for (my $i = 0; $i < ($#id - 3); $i += 5) {
		# the MSB is on the right.
		my @nimble = reverse @id[$i .. $i + 4];
		my $checksum = 0;
		my $cs = '';
		for my $char (@nimble) {
			$checksum |= 1
				if ($char =~ /[A-Z]/);
			if ($char =~ /[A-Z]/) {
				$cs .= '1';
			}
			else {
				$cs .= '0';
			}

			$checksum <<= 1;
		}
		# we shift after each character. but that would shift off by 
		# one, out of boundary, after last pass.
		$checksum >>= 1;
		if ($debug) {
			print "CS: $cs\n";
			print "NM: ".join('', @nimble)."\n";
			print "31: $checksum\n";
		}

		push @nimbles, join('', @nimble);
		push @computed_checksum, $_31[$checksum];
	}

	return join('', @computed_checksum);
};

sub object {
	return shift->{object_type};
};
sub id {
	return shift->{id};
};

sub id15 {
	my $self = shift;
	return $self->{id15} 
		if $self->{id15};
	$self->{id15} = join('', @{$shift->{id_parts}}[0 .. 14]);
	return $self->{id15};
};

1;
