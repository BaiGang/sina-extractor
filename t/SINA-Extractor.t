# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl SINA-Extractor.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;
use Data::Dumper;
use FindBin qw($Bin);
use Test::More tests => 5;
BEGIN { use_ok('SINA::Extractor') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $conf = "$Bin/test1.config";
my $html_file = "$Bin/test1.html";

my $extractor = SINA::Extractor->new;
$extractor->init($conf);
my $result_hash = $extractor->extract_from_file($html_file);

print Dumper($result_hash);
is $result_hash->{vp_value}, 'width=device-width, initial-scale=1', 'viewport meta values';
is $result_hash->{charset}, 'utf-8', 'charset meta value';
is $result_hash->{Title}, 'Thinking Insightfully.', 'title in html';
ok 1, 'ok';
print Dumper($result_hash);

