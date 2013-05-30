# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl SINA-Extractor.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;
use Data::Dumper;
use FindBin qw($Bin);
use Test::More tests => 28;
BEGIN { use_ok('SINA::Extractor') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $conf = "$Bin/test1.config";
my $html_file = "$Bin/test1.html";

my $extractor = SINA::Extractor->new;
$extractor->init($conf);
my $result_hash = $extractor->extract_from_file($html_file);

# single fields
is $result_hash->{vp_value}, 'width=device-width, initial-scale=1', 'viewport meta values';
is $result_hash->{charset}, 'utf-8', 'charset meta value';
is $result_hash->{Title}, 'Thinking Insightfully.', 'title in html';
is $result_hash->{favicon_url}, '/favicon.png', 'favicon url';

#repeated fields
my $rep_fields = $result_hash->{script_type_list};
my @rf_expected = (
  "text/javascript",
  "text/x-mathjax-config",
  "text/x-mathjax-config",
  "text/x-mathjax-config",
  "text/javascript",
  "text/javascript",
  "text/javascript",
  "text/javascript",
  "text/javascript",
  "text/javascript",
);

my @sorted_rep_fields = sort @$rep_fields;
my @sorted_rf_expected = sort @rf_expected;

# checking sorted data
ok scalar @sorted_rep_fields == scalar @sorted_rf_expected, "equal sizes";
# the `is` will be called 10 times
for (my $i = 0; $i < scalar @sorted_rep_fields; ++$i) {
  is $sorted_rep_fields[$i], $sorted_rf_expected[$i], "same value at index $i";
}

# checking unsorted data
ok scalar @$rep_fields == scalar @rf_expected, "equal sizes";
# the `is` will be called 10 times
for (my $i = 0; $i < scalar @rf_expected; ++$i) {
  is $rep_fields->[$i], $rf_expected[$i], "raw extracted data - same value at index $i";
}

ok 1, 'ok';
print "The results:\n".Dumper($result_hash);

