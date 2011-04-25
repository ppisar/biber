use strict;
use warnings;
use utf8;
no warnings 'utf8';

use Test::More tests => 70;

use Biber;
use Biber::Utils;
use Biber::Output::BBL;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
chdir("t/tdata");

# Set up Biber object
my $biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('labelalpha.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());

# Options - we could set these in the control file but it's nice to see what we're
# relying on here for tests

# Biber options
Biber::Config->setoption('fastsort', 1);
Biber::Config->setoption('sortlocale', 'C');

# Biblatex options
Biber::Config->setblxoption('labelalpha', 1);
Biber::Config->setblxoption('maxnames', 1);
Biber::Config->setblxoption('labelyear', undef);

# Now generate the information
$biber->prepare;
my $section = $biber->sections->get_section(0);
my $main = $section->get_list('MAIN');
my $bibentries = $section->bibentries;

is($bibentries->entry('l1')->get_field('sortlabelalpha'), 'Doe95', 'maxnames=1 minnames=1 entry L1 labelalpha');
ok(is_undef($main->get_extraalphadata('l1')), 'maxnames=1 minnames=1 entry L1 extraalpha');
is($bibentries->entry('l2')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=1 minnames=1 entry L2 labelalpha');
is($main->get_extraalphadata('l2'), '1', 'maxnames=1 minnames=1 entry L2 extraalpha');
is($bibentries->entry('l3')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=1 minnames=1 entry L3 labelalpha');
is($main->get_extraalphadata('l3'), '2', 'maxnames=1 minnames=1 entry L3 extraalpha');
is($bibentries->entry('l4')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=1 minnames=1 entry L4 labelalpha');
is($main->get_extraalphadata('l4'), '3', 'maxnames=1 minnames=1 entry L4 extraalpha');
is($bibentries->entry('l5')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=1 minnames=1 entry L5 labelalpha');
is($main->get_extraalphadata('l5'), '4', 'maxnames=1 minnames=1 entry L5 extraalpha');
is($bibentries->entry('l6')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=1 minnames=1 entry L6 labelalpha');
is($main->get_extraalphadata('l6'), '5', 'maxnames=1 minnames=1 entry L6 extraalpha');
is($bibentries->entry('l7')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=1 minnames=1 entry L7 labelalpha');
is($main->get_extraalphadata('l7'), '6', 'maxnames=1 minnames=1 entry L7 extraalpha');
is($bibentries->entry('l8')->get_field('sortlabelalpha'), 'Sha85', 'maxnames=1 minnames=1 entry L8 labelalpha');
ok(is_undef($main->get_extraalphadata('l8')), 'maxnames=1 minnames=1 entry L8 extraalpha');
ok(is_undef($main->get_extraalphadata('l9')), 'L9 extraalpha unset due to shorthand');
ok(is_undef($main->get_extraalphadata('l10')), 'L10 extraalpha unset due to shorthand');
is($main->get_extraalphadata('knuth:ct'), '1', 'YEAR with range needs label differentiating from individual volumes - 1');
is($main->get_extraalphadata('knuth:ct:a'), '2', 'YEAR with range needs label differentiating from individual volumes - 2');
is($main->get_extraalphadata('knuth:ct:b'), '1', 'YEAR with range needs label differentiating from individual volumes - 3');
is($main->get_extraalphadata('knuth:ct:c'), '2', 'YEAR with range needs label differentiating from individual volumes - 4');

# reset options and regenerate information
Biber::Config->setblxoption('maxnames', 2);
Biber::Config->setblxoption('minnames', 1);

for (my $i=1; $i<9; $i++) {
  $bibentries->entry("l$i")->del_field('sortlabelalpha');
  $bibentries->entry("l$i")->del_field('labelalpha');
  $main->set_extraalphadata("l$i",undef);
}

$biber->prepare;
$section = $biber->sections->get_section(0);
$main = $section->get_list('MAIN');
$bibentries = $section->bibentries;

is($bibentries->entry('l1')->get_field('sortlabelalpha'), 'Doe95', 'maxnames=2 minnames=1 entry L1 labelalpha');
ok(is_undef($main->get_extraalphadata('l1')), 'maxnames=2 minnames=1 entry L1 extraalpha');
is($bibentries->entry('l2')->get_field('sortlabelalpha'), 'DA95', 'maxnames=2 minnames=1 entry L2 labelalpha');
is($main->get_extraalphadata('l2'), '1', 'maxnames=2 minnames=1 entry L2 extraalpha');
is($bibentries->entry('l3')->get_field('sortlabelalpha'), 'DA95', 'maxnames=2 minnames=1 entry L3 labelalpha');
is($main->get_extraalphadata('l3'), '2', 'maxnames=2 minnames=1 entry L3 extraalpha');
is($bibentries->entry('l4')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=2 minnames=1 entry L4 labelalpha');
is($main->get_extraalphadata('l4'), '1', 'maxnames=2 minnames=1 entry L4 extraalpha');
is($bibentries->entry('l5')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=2 minnames=1 entry L5 labelalpha');
is($main->get_extraalphadata('l5'), '2', 'maxnames=2 minnames=1 entry L5 extraalpha');
is($bibentries->entry('l6')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=2 minnames=1 entry L6 labelalpha');
is($main->get_extraalphadata('l6'), '3', 'maxnames=2 minnames=1 entry L6 extraalpha');
is($bibentries->entry('l7')->get_field('sortlabelalpha'), 'Doe+95', 'maxnames=2 minnames=1 entry L7 labelalpha');
is($main->get_extraalphadata('l7'), '4', 'maxnames=2 minnames=1 entry L7 extraalpha');
is($bibentries->entry('l8')->get_field('sortlabelalpha'), 'Sha85', 'maxnames=2 minnames=1 entry L8 labelalpha');
ok(is_undef($main->get_extraalphadata('l8')), 'maxnames=2 minnames=1 entry L8 extraalpha');

# reset options and regenerate information
Biber::Config->setblxoption('maxnames', 2);
Biber::Config->setblxoption('minnames', 2);

for (my $i=1; $i<9; $i++) {
  $bibentries->entry("l$i")->del_field('sortlabelalpha');
  $bibentries->entry("l$i")->del_field('labelalpha');
  $main->set_extraalphadata("l$i", undef);
}

$biber->prepare;
$section = $biber->sections->get_section(0);
$main = $section->get_list('MAIN');
$bibentries = $section->bibentries;

is($bibentries->entry('l1')->get_field('sortlabelalpha'), 'Doe95', 'maxnames=2 minnames=2 entry L1 labelalpha');
ok(is_undef($main->get_extraalphadata('l1')), 'maxnames=2 minnames=2 entry L1 extraalpha');
is($bibentries->entry('l2')->get_field('sortlabelalpha'), 'DA95', 'maxnames=2 minnames=2 entry L2 labelalpha');
is($main->get_extraalphadata('l2'), '1', 'maxnames=2 minnames=2 entry L2 extraalpha');
is($bibentries->entry('l3')->get_field('sortlabelalpha'), 'DA95', 'maxnames=2 minnames=2 entry L3 labelalpha');
is($main->get_extraalphadata('l3'), '2', 'maxnames=2 minnames=2 entry L3 extraalpha');
is($bibentries->entry('l4')->get_field('sortlabelalpha'), 'DA+95', 'maxnames=2 minnames=2 entry L4 labelalpha');
is($main->get_extraalphadata('l4'), '1', 'maxnames=2 minnames=2 entry L4 extraalpha');
is($bibentries->entry('l5')->get_field('sortlabelalpha'), 'DA+95', 'maxnames=2 minnames=2 entry L5 labelalpha');
is($main->get_extraalphadata('l5'), '2', 'maxnames=2 minnames=2 entry L5 extraalpha');
is($bibentries->entry('l6')->get_field('sortlabelalpha'), 'DS+95', 'maxnames=2 minnames=2 entry L6 labelalpha');
is($main->get_extraalphadata('l6'), '1', 'maxnames=2 minnames=2 entry L6 extraalpha');
is($bibentries->entry('l7')->get_field('sortlabelalpha'), 'DS+95', 'maxnames=2 minnames=2 entry L7 labelalpha');
is($main->get_extraalphadata('l7'), '2', 'maxnames=2 minnames=2 entry L7 extraalpha');
is($bibentries->entry('l8')->get_field('sortlabelalpha'), 'Sha85', 'maxnames=2 minnames=2 entry L8 labelalpha');
ok(is_undef($main->get_extraalphadata('l8')), 'maxnames=2 minnames=2 entry L8 extraalpha');

# reset options and regenerate information
Biber::Config->setblxoption('maxnames', 3);
Biber::Config->setblxoption('minnames', 1);

for (my $i=1; $i<9; $i++) {
  $bibentries->entry("l$i")->del_field('sortlabelalpha');
  $bibentries->entry("l$i")->del_field('labelalpha');
  $main->set_extraalphadata("l$i", undef);
}

$biber->prepare;
$section = $biber->sections->get_section(0);
$main = $section->get_list('MAIN');
$bibentries = $section->bibentries;

is($bibentries->entry('l1')->get_field('sortlabelalpha'), 'Doe95', 'maxnames=3 minnames=1 entry L1 labelalpha');
ok(is_undef($main->get_extraalphadata('l1')), 'maxnames=3 minnames=1 entry L1 extraalpha');
is($bibentries->entry('l2')->get_field('sortlabelalpha'), 'DA95', 'maxnames=3 minnames=1 entry L2 labelalpha');
is($main->get_extraalphadata('l2'), '1', 'maxnames=3 minnames=1 entry L2 extraalpha');
is($bibentries->entry('l3')->get_field('sortlabelalpha'), 'DA95', 'maxnames=3 minnames=1 entry L3 labelalpha');
is($main->get_extraalphadata('l3'), '2', 'maxnames=3 minnames=1 entry L3 extraalpha');
is($bibentries->entry('l4')->get_field('sortlabelalpha'), 'DAE95', 'maxnames=3 minnames=1 entry L4 labelalpha');
is($main->get_extraalphadata('l4'), '1', 'maxnames=3 minnames=1 entry L4 extraalpha');
is($bibentries->entry('l5')->get_field('sortlabelalpha'), 'DAE95', 'maxnames=3 minnames=1 entry L5 labelalpha');
is($main->get_extraalphadata('l5'), '2', 'maxnames=3 minnames=1 entry L5 extraalpha');
is($bibentries->entry('l6')->get_field('sortlabelalpha'), 'DSE95', 'maxnames=3 minnames=1 entry L6 labelalpha');
ok(is_undef($main->get_extraalphadata('l6')), 'maxnames=3 minnames=1 entry L6 extraalpha');
is($bibentries->entry('l7')->get_field('sortlabelalpha'), 'DSJ95', 'maxnames=3 minnames=1 entry L7 labelalpha');
ok(is_undef($main->get_extraalphadata('l7')), 'maxnames=3 minnames=1 entry L7 extraalpha');
is($bibentries->entry('l8')->get_field('sortlabelalpha'), 'Sha85', 'maxnames=3 minnames=1 entry L8 labelalpha');
ok(is_undef($main->get_extraalphadata('l8')), 'maxnames=3 minnames=1 entry L8 extraalpha');
