package SINA::Extractor;

use 5.012003;
use strict;
use warnings;
use Carp qw/carp croak confess cluck/;
use HTML::TreeBuilder -weak;
use Data::Dumper;
require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use SINA::Extractor ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
 	new
  init
  extract
  extract_from_file
);

our $VERSION = '0.01';

sub new {
  my $class = shift;
  my $self = {
    config => undef,
  };
  bless $self, $class;
}

sub init {
  my ($self, $config_file) = @_;
  
  open CONFIG, "<", $config_file  or croak "Failed opening config: $config_file.\n";
  my @confs = ();
  while (<CONFIG>) {
    chomp;
    my ($tag, $filters, $field, $label) = split '\s';
    
    my %conf = ();
    $conf{'tag'} = $tag;
    
    my %filter_hash = ();
    $filter_hash{'_tag'} = $tag;
    if ($filters ne 'NULL') {
      my @filter_list = split ',', $filters;
      foreach (@filter_list) {
        my ($name, $value) = split ':';
        $filter_hash{$name} = $value;
      }
    }
    $conf{'filters'} = \%filter_hash;
    $conf{'field'} = $field;
    $conf{'label'} = $label;

    push @confs, \%conf;
  }
  $self->{config} = \@confs;
  close CONFIG;
}

sub extract {
  my ($self, $html) = @_;

  my %results = ();

  my $tree = HTML::TreeBuilder->new;
  $tree->parse_content($html);
  
  foreach (@{$self->{config}}) {
    my $conf = $_;
    my @nodes = $tree->look_down(
      sub {
        my $node = $_[0];
        my $success = 1;
        while (my ($key, $value) = each %{$conf->{filters}}) {
          if ($node->attr($key)) {
            if ($node->attr($key) =~ m#$value#) {
              # cluck $node->attr($key)"";
            } else {
              $success = 0;
            }
          } else {
            $success = 0;
          }
        }
        $success;
      }
#=pod=
#      _tag => $conf->{tag},
#      sub {
#        my $node = $_[0];
#        my $success = 1;
#        while(my ($key, $value) = each %{$conf->{filters}}) {
#          $success = $success and $node->attr($key) and ($node->attr($key) eq $value);
#        }
#        $success;
#      }
#=cut=
      #$conf->{filters}
    );
   
    carp "Failed parsing for ".$conf->{label} unless @nodes;
 
    foreach (@nodes) {
      my $node = $_;
      if ($conf->{field} eq 'content') {
        my ($content_value) = $node->content_list;
        if ($content_value) {
          $results{$conf->{label}} = $content_value;
        } else {
          carp "Content of $conf->{label} not exist.";
        }
      } else {
        my ($attr, $attr_name) = split ':', $conf->{field};
        if (defined $attr and defined $attr_name) {
          my $extracted_value = $_->attr($attr_name);
          $results{$conf->{label}} = $extracted_value;
        } else {
          carp "Failed parsing the field to extract - ".$conf->{field};
        }
      }
    }  # foreach  @nodes
  }  # foreach config 
  $tree->delete;
  return \%results;
}

sub extract_from_file {
  my ($self, $file_name) = @_;
  open my $fn_handle, '<', $file_name or croak "Not able to open HTML file $file_name: $!";
  my $html_content = "";
  while (<$fn_handle>) {
    chomp;
    $html_content = $html_content.$_;
  }
  return extract($self, $html_content);
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

SINA::Extractor - Perl extension for configurable html content extraction.

=head1 SYNOPSIS

  use SINA::Extractor;
  my $extractor = SINA::Extractor->new;
  $extractor->init($path_to_conf);
  my $result_hash = $extractor->parse($html_content);

=head1 DESCRIPTION

This is a tiny extractor for obtaining pre-configured fields in a html file.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Nowhere else.

=head1 AUTHOR

Bai Gang, E<lt>baigang@staff.sina.com.cnE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Bai Gang

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
