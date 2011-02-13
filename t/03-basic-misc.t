use strict;
use warnings;
use utf8;
no warnings 'utf8';

use Test::More tests => 15;

use Biber;
use Biber::Output::BBL;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
chdir("t/tdata");

# Set up Biber object
my $biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile("general2.bcf");
$biber->set_output_obj(Biber::Output::BBL->new());

# Options - we could set these in the control file but it's nice to see what we're
# relying on here for tests

# Biber options
Biber::Config->setoption('fastsort', 1);

# Now generate the information
$biber->prepare;
my $out = $biber->get_output_obj;
my $section = $biber->sections->get_section(0);
my $main = $section->get_list('MAIN');
my @keys = sort $section->get_citekeys;
my @citedkeys = sort qw{ murray t1 kant:ku kant:kpv t2 shore};

my @allkeys = sort qw{ stdmodel aristotle:poetics vazques-de-parga t1
gonzalez averroes/bland laufenberg westfahl:frontier knuth:ct:a kastenholz
averroes/hannes iliad luzzatto malinowski sorace knuth:ct:d britannica
nietzsche:historie stdmodel:weinberg knuth:ct:b baez/article knuth:ct:e itzhaki
jaffe padhye cicero stdmodel:salam reese averroes/hercz murray shore
aristotle:physics massa aristotle:anima gillies set kowalik gaonkar springer
geer hammond wormanx westfahl:space worman set:herrmann augustine gerhardt
piccato hasan hyman stdmodel:glashow stdmodel:ps_sc kant:kpv companion almendro
sigfridsson ctan baez/online aristotle:rhetoric pimentel00 pines knuth:ct:c moraux cms
angenendt angenendtsk loh markey cotton vangennepx kant:ku nussbaum nietzsche:ksa1
vangennep knuth:ct angenendtsa spiegelberg bertram brandt set:aksin chiu nietzsche:ksa
set:yoon maron coleridge tvonb t2 } ;

is_deeply( \@keys, \@citedkeys, 'citekeys 1') ;
is_deeply( [ $section->get_list('SHORTHANDS')->get_keys ], [ 'kant:kpv', 'kant:ku' ], 'shorthands' ) ;

# reset some options and re-generate information

# Have to do a citekey deletion as we are not re-reading the .bcf which would do it for us
# Otherwise, we have citekeys and allkeys which confuses fetch_data()
$section->del_citekeys;
$section->allkeys;
$biber->prepare;
$section = $biber->sections->get_section(0);
my $bibentries = $section->bibentries;

$out = $biber->get_output_obj;

@keys = sort $section->get_citekeys;

is_deeply( \@keys, \@allkeys, 'citekeys 2') ;

my $murray1 = q|  \entry{murray}{article}{}
    \name{labelname}{14}{}{%
      {{uniquename=0}{Hostetler}{H}{Michael~J.}{MJ}{}{}{}{}}%
      {{uniquename=0}{Wingate}{W}{Julia~E.}{JE}{}{}{}{}}%
      {{uniquename=0}{Zhong}{Z}{Chuan-Jian}{CJ}{}{}{}{}}%
      {{uniquename=0}{Harris}{H}{Jay~E.}{JE}{}{}{}{}}%
      {{uniquename=0}{Vachet}{V}{Richard~W.}{RW}{}{}{}{}}%
      {{uniquename=0}{Clark}{C}{Michael~R.}{MR}{}{}{}{}}%
      {{uniquename=0}{Londono}{L}{J.~David}{JD}{}{}{}{}}%
      {{uniquename=0}{Green}{G}{Stephen~J.}{SJ}{}{}{}{}}%
      {{uniquename=0}{Stokes}{S}{Jennifer~J.}{JJ}{}{}{}{}}%
      {{uniquename=0}{Wignall}{W}{George~D.}{GD}{}{}{}{}}%
      {{uniquename=0}{Glish}{G}{Gary~L.}{GL}{}{}{}{}}%
      {{uniquename=0}{Porter}{P}{Marc~D.}{MD}{}{}{}{}}%
      {{uniquename=0}{Evans}{E}{Neal~D.}{ND}{}{}{}{}}%
      {{uniquename=0}{Murray}{M}{Royce~W.}{RW}{}{}{}{}}%
    }
    \name{author}{14}{}{%
      {{}{Hostetler}{H}{Michael~J.}{MJ}{}{}{}{}}%
      {{}{Wingate}{W}{Julia~E.}{JE}{}{}{}{}}%
      {{}{Zhong}{Z}{Chuan-Jian}{CJ}{}{}{}{}}%
      {{}{Harris}{H}{Jay~E.}{JE}{}{}{}{}}%
      {{}{Vachet}{V}{Richard~W.}{RW}{}{}{}{}}%
      {{}{Clark}{C}{Michael~R.}{MR}{}{}{}{}}%
      {{}{Londono}{L}{J.~David}{JD}{}{}{}{}}%
      {{}{Green}{G}{Stephen~J.}{SJ}{}{}{}{}}%
      {{}{Stokes}{S}{Jennifer~J.}{JJ}{}{}{}{}}%
      {{}{Wignall}{W}{George~D.}{GD}{}{}{}{}}%
      {{}{Glish}{G}{Gary~L.}{GL}{}{}{}{}}%
      {{}{Porter}{P}{Marc~D.}{MD}{}{}{}{}}%
      {{}{Evans}{E}{Neal~D.}{ND}{}{}{}{}}%
      {{}{Murray}{M}{Royce~W.}{RW}{}{}{}{}}%
    }
    \strng{namehash}{HMJ+1}
    \strng{fullhash}{HMJWJEZCJHJEVRWCMRLJDGSJSJJWGDGGLPMDENDMRW1}
    \field{labelalpha}{Hos\textbf{+}98}
    \field{sortinit}{H}
    \true{singletitle}
    \field{annotation}{An \texttt{article} entry with \arabic{author} authors. By default, long author and editor lists are automatically truncated. This is configurable}
    \field{hyphenation}{american}
    \field{indextitle}{Alkanethiolate gold cluster molecules}
    \field{journaltitle}{Langmuir}
    \field{number}{1}
    \field{shorttitle}{Alkanethiolate gold cluster molecules}
    \field{subtitle}{Core and monolayer properties as a function of core size}
    \field{title}{Alkanethiolate gold cluster molecules with core diameters from 1.5 to 5.2~nm}
    \field{volume}{14}
    \field{year}{1998}
    \field{pages}{17\bibrangedash 30}
  \endentry

|;

my $murray2 = q|  \entry{murray}{article}{}
    \name{labelname}{14}{}{%
      {{uniquename=0}{Hostetler}{H}{Michael~J.}{MJ}{}{}{}{}}%
      {{uniquename=0}{Wingate}{W}{Julia~E.}{JE}{}{}{}{}}%
      {{uniquename=0}{Zhong}{Z}{Chuan-Jian}{CJ}{}{}{}{}}%
      {{uniquename=0}{Harris}{H}{Jay~E.}{JE}{}{}{}{}}%
      {{uniquename=0}{Vachet}{V}{Richard~W.}{RW}{}{}{}{}}%
      {{uniquename=0}{Clark}{C}{Michael~R.}{MR}{}{}{}{}}%
      {{uniquename=0}{Londono}{L}{J.~David}{JD}{}{}{}{}}%
      {{uniquename=0}{Green}{G}{Stephen~J.}{SJ}{}{}{}{}}%
      {{uniquename=0}{Stokes}{S}{Jennifer~J.}{JJ}{}{}{}{}}%
      {{uniquename=0}{Wignall}{W}{George~D.}{GD}{}{}{}{}}%
      {{uniquename=0}{Glish}{G}{Gary~L.}{GL}{}{}{}{}}%
      {{uniquename=0}{Porter}{P}{Marc~D.}{MD}{}{}{}{}}%
      {{uniquename=0}{Evans}{E}{Neal~D.}{ND}{}{}{}{}}%
      {{uniquename=0}{Murray}{M}{Royce~W.}{RW}{}{}{}{}}%
    }
    \name{author}{14}{}{%
      {{}{Hostetler}{H}{Michael~J.}{MJ}{}{}{}{}}%
      {{}{Wingate}{W}{Julia~E.}{JE}{}{}{}{}}%
      {{}{Zhong}{Z}{Chuan-Jian}{CJ}{}{}{}{}}%
      {{}{Harris}{H}{Jay~E.}{JE}{}{}{}{}}%
      {{}{Vachet}{V}{Richard~W.}{RW}{}{}{}{}}%
      {{}{Clark}{C}{Michael~R.}{MR}{}{}{}{}}%
      {{}{Londono}{L}{J.~David}{JD}{}{}{}{}}%
      {{}{Green}{G}{Stephen~J.}{SJ}{}{}{}{}}%
      {{}{Stokes}{S}{Jennifer~J.}{JJ}{}{}{}{}}%
      {{}{Wignall}{W}{George~D.}{GD}{}{}{}{}}%
      {{}{Glish}{G}{Gary~L.}{GL}{}{}{}{}}%
      {{}{Porter}{P}{Marc~D.}{MD}{}{}{}{}}%
      {{}{Evans}{E}{Neal~D.}{ND}{}{}{}{}}%
      {{}{Murray}{M}{Royce~W.}{RW}{}{}{}{}}%
    }
    \strng{namehash}{HMJ+1}
    \strng{fullhash}{HMJWJEZCJHJEVRWCMRLJDGSJSJJWGDGGLPMDENDMRW1}
    \field{labelalpha}{Hos98}
    \field{sortinit}{H}
    \true{singletitle}
    \field{annotation}{An \texttt{article} entry with \arabic{author} authors. By default, long author and editor lists are automatically truncated. This is configurable}
    \field{hyphenation}{american}
    \field{indextitle}{Alkanethiolate gold cluster molecules}
    \field{journaltitle}{Langmuir}
    \field{number}{1}
    \field{shorttitle}{Alkanethiolate gold cluster molecules}
    \field{subtitle}{Core and monolayer properties as a function of core size}
    \field{title}{Alkanethiolate gold cluster molecules with core diameters from 1.5 to 5.2~nm}
    \field{volume}{14}
    \field{year}{1998}
    \field{pages}{17\bibrangedash 30}
  \endentry

|;

my $t1 = q|  \entry{t1}{misc}{}
    \name{labelname}{1}{}{%
      {{uniquename=0}{Brown}{B}{Bill}{B}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Brown}{B}{Bill}{B}{}{}{}{}}%
    }
    \strng{namehash}{BB1}
    \strng{fullhash}{BB1}
    \field{labelalpha}{Bro92}
    \field{sortinit}{B}
    \field{title}{Normal things {$^{3}$}}
    \field{year}{1992}
    \field{pages}{100\bibrangedash}
    \keyw{primary, something,somethingelse}
  \endentry

|;

my $t2 = q|  \entry{t2}{misc}{}
    \name{labelname}{1}{}{%
      {{uniquename=0}{Brown}{B}{Bill}{B}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Brown}{B}{Bill}{B}{}{}{}{}}%
    }
    \strng{namehash}{BB1}
    \strng{fullhash}{BB1}
    \field{labelalpha}{Bro94}
    \field{sortinit}{B}
    \field{title}{Signs of W$\frac{o}{a}$nder}
    \field{year}{1994}
    \field{pages}{100}
  \endentry

|;

my $Worman_N = [ 'Worman, Nana', 'Worman, Nancy' ] ;
my $Gennep = [ 'van Gennep, Arnold', 'van Gennep, Jean' ] ;

is( $out->get_output_entry($main,'t1'), $t1, 'bbl entry with maths in title 1' ) ;
is( $bibentries->entry('shore')->get_field('month'), '03', 'default bib month macros' ) ;
ok( $bibentries->entry('t1')->has_keyword('primary'), 'Keywords test - 1' ) ;
ok( $bibentries->entry('t1')->has_keyword('something'), 'Keywords test - 2' ) ;
ok( $bibentries->entry('t1')->has_keyword('somethingelse'), 'Keywords test - 3' ) ;
is( $out->get_output_entry($main,'t2'), $t2, 'bbl entry with maths in title 2' ) ;
is_deeply( Biber::Config->_get_uniquename('Worman_N'), $Worman_N, 'uniquename count 1') ;
is_deeply( Biber::Config->_get_uniquename('Gennep'), $Gennep, 'uniquename count 2') ;
is( $out->get_output_entry($main,'murray'), $murray1, 'bbl with > maxnames' ) ;
is( $out->get_output_entry($main,'missing1'), "  \\missing{missing1}\n", 'missing citekey 1' ) ;
is( $out->get_output_entry($main,'missing2'), "  \\missing{missing2}\n", 'missing citekey 2' ) ;

Biber::Config->setblxoption('alphaothers', '');
Biber::Config->setblxoption('sortalphaothers', '');

# Have to do a citekey deletion as we are not re-reading the .bcf which would do it for us
# Otherwise, we have citekeys and allkeys which confuses fetch_data()
$section->del_citekeys;
$biber->prepare ;
$section = $biber->sections->get_section(0);
$main = $section->get_list('MAIN');
$out = $biber->get_output_obj;

is( $out->get_output_entry($main,'murray'), $murray2, 'bbl with > maxnames, empty alphaothers' ) ;

unlink <*.utf8>;
