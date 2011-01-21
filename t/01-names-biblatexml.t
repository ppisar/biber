use strict;
use warnings;
use utf8;
no warnings 'utf8';

use Test::More skip_all => 'bltxml not working yet';

use Biber;
use Biber::Input::file::bibtex;
use Biber::Output::BBL;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
chdir("t/tdata");

# Set up Biber object
my $biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('names-biblatexml.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());

# Options - we could set these in the control file but it's nice to see what we're
# relying on here for tests

# Biber options
Biber::Config->setoption('fastsort', 1);
Biber::Config->setoption('sortlocale', 'C');

# Now generate the information
$biber->prepare;
my $out = $biber->get_output_obj;
my $section = $biber->sections->get_section(0);
my $bibentries = $section->bibentries;

my $l1 = q||;

is( $out->get_output_entry('bulgakovrozenfeld:1983'), $l1, 'Basic BibLaTeXML test - 1') ;

unlink <*.utf8>;