use strict; use warnings;

package Hook::Guard;

sub new {
	my ( $class, $glob ) = @_;
	local $@;
	my $code = eval { *$glob{'CODE'} }
		or die sprintf "Cannot hook a %s at %s line %d.\n", (
			( $@ ? 'non-glob' : 'glob with an empty CODE slot' ),
			( caller )[1,2],
		);
	bless [ $glob, $code ], $class;
}

sub glob     { $_[0][0] }
sub original { $_[0][1] }
sub current  { *{ $_[0][0] }{'CODE'} }

sub hook   { no warnings 'redefine'; *{ $_[0][0] } = \&{ $_[1] }; $_[0] }
sub unhook { no warnings 'redefine'; *{ $_[0][0] } = $_[0][1];    $_[0] }

sub DESTROY { shift->unhook }

1;
