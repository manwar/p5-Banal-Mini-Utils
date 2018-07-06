use 5.014;
use strict;
use warnings;

package Banal::Mini::Utils::MungeHas;
# vim: set ts=8 sts=4 sw=4 tw=115 et :
# ABSTRACT: Provide several MUNGER functions that may be use in conjunction with C<MooseX::MungeHas>.
# KEYWORDS: Munge Has has MungeHas MooseX::MungeHas Moose MooseX Moo MooX

our $VERSION = '0.001';
# AUTHORITY

use Data::Printer;    # DEBUG purposes.
use Banal::Mini::Utils qw(peek tidy_arrayify);

use namespace::autoclean;

use Exporter::Shiny qw(
  mhs_dict
  mhs_dictionary

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

#######################################
sub mhs_dict { &mhs_dictionary }
sub mhs_dictionary {
# - Lookup meta specs for attributes from a given (src) dictonary;
#     * Parameters destined to this routine (dict, src/src_dict, dest/dest_dict) will be removed from the context.
#     * Remaining parameters will win over the values looked up from the src dictionnary.
#     * Current munge context (%_) wins over all of the above
# - [OPTIONALLY] : merge the resulting specs onto a given (dest) dictionary, which may the same as (serc)
#######################################
  # ATTENTION : Special calling convention and interface defined by MooseX::MungeHas.
  my $name    = $_;         # $_ contains the attribute NAME
  %_          = (@_, %_);   # %_ contains the attribute SPECS or params for mungers (including ourselves),
                            # @_ contains defaults.
  #say STDERR 'Dictionnary access!';

  my @dict    = tidy_arrayify( delete $_{dict}  );
  my @src     = tidy_arrayify( delete $_{src},  delete $_{src_dict},  @dict);
  my @dest    = tidy_arrayify( delete $_{dest}, delete $_{dest_dict}, @dict);
  my $entry;

  # multiple source dictionaries are supported.
  foreach my $src (@src) {
    #say STDERR '  Dictionnary : SOURCE lookup : ...';
    next unless defined( $entry = exists $src->{$name} ? $src->{$name} : undef);
    do { $_{$_} = $entry->{$_} unless exists $_{$_}  } for (keys %$entry);
  }

  # multiple destination dictionaries are supported.
  foreach my $dest (@dest) {
    #say STDERR '  Dictionnary : Updating DESTINATION : ...';
    my $entry = $dest->{$name} //= +{};
    $entry->{$_} = $_{$_} for (keys %_);
  }

  #say STDERR 'Dictionnary : about to return : ...';
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
