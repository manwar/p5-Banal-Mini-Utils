use 5.014;
use strict;
use warnings;

package Banal::Mini::Utils::MungeHas;
# vim: set ts=8 sts=4 sw=4 tw=115 et :
# ABSTRACT: Provide several MUNGER functions that may be use in conjunction with C<MooseX::MungeHas>.
# KEYWORDS: Munge Has has MungeHas MooseX::MungeHas Moose MooseX Moo MooX

our $VERSION = '0.198';
# AUTHORITY

use Data::Printer;    # DEBUG purposes.
use Banal::Mini::Utils qw(peek tidy_arrayify);

use namespace::autoclean;

use Exporter::Shiny qw(
  mhs_lazy_ro
  mhs_specs

  std_haz_mungers
);

#######################################
sub std_haz_mungers {
#######################################
  our %mungers = (
    haz       => [  sub {; mhs_lazy_ro() }             ],
    haz_bool  => [  sub {; mhs_lazy_ro(isa=>'Bool') }  ],
    haz_int   => [  sub {; mhs_lazy_ro(isa=>'Int') }   ],
    haz_str   => [  sub {; mhs_lazy_ro(isa=>'Str') }   ],
    haz_strs  => [  sub {; mhs_lazy_ro(isa=>'ArrayRef[Str]', traits=>['Array'] ) }  ],
    haz_hash  => [  sub {; mhs_lazy_ro(isa=>'HashRef',       traits=>['Hash']  ) }  ],
  );
  %mungers;
}

#######################################
sub mhs_lazy_ro {
#######################################
  mhs_specs( is => 'ro', init_arg => undef, lazy => 1, @_ );
}


#######################################
sub mhs_specs { # Define meta specs for attributes (is, isa, lazy, ...)
#######################################
  # ATTENTION : Special calling convention and interface defined by MooseX::MungeHas.
  my $name    = $_;         # $_ contains the attribute NAME
  %_          = (@_, %_);   # %_ contains the attribute SPECS, whereas @_ contains defaults (prefs) for those specs.
  wantarray ? (%_) : +{%_}
}



1;


__END__

#region pod

=pod


=head1 SYNOPSIS

=for stopwords haz ro

use Banal::Mini::Utils::MungeHas  qw(mhs_specs);
use Moose;
use MooseX::MungeHas {
    haz =>  [  sub {; mhs_specs( is => 'ro', init_arg => undef, lazy => 1 ) },
            ]
  };

=head1 DESCRIPTION

=for stopwords TABULO

This module provides several mungers that may be use in conjunction with C<MooseX::MungeHas>.

=head2 EXPORT_OK



=begin :list

* mhs_lazy_ro
* mhs_specs


=end :list


=cut
