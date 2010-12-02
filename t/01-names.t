use strict;
use warnings;
use utf8;
no warnings 'utf8';

use Test::More tests => 45;

use Biber;
use Biber::Input::BibTeX;
use Biber::Output::BBL;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
chdir("t/tdata");

# Set up Biber object
my $biber = Biber->new(noconf => 1);
$biber->parse_ctrlfile('names.bcf');
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

my $name1 =
    { firstname      => "John",
      firstname_i    => "J.",
      firstname_it   => "J",
      lastname       => "Doe",
      lastname_i     => "D.",
      lastname_it    => "D",
      nameinitstring => "Doe_J",
      namestring     => "Doe, John",
      prefix         => undef,
      prefix_i       => undef,
      prefix_it      => undef,
      strip          => { firstname => 0, lastname => 0, prefix => undef, suffix => undef },
      suffix         => undef,
      suffix_i       => undef,
      suffix_it      => undef};
my $name2 =
    { firstname      => "John",
      firstname_i    => "J.",
      firstname_it   => "J",
      lastname       => "Doe",
      lastname_i     => "D.",
      lastname_it    => "D",
      nameinitstring => "Doe_J_J",
      namestring     => "Doe, Jr, John",
      prefix         => undef,
      prefix_i       => undef,
      prefix_it      => undef,
      strip          => { firstname => 0, lastname => 0, prefix => undef, suffix => 0 },
      suffix         => "Jr",
      suffix_i       => "J.",
      suffix_it      => "J" } ;



my $name3 =
    { firstname      => "Johann~Gottfried",
      firstname_i    => "J.~G.",
      firstname_it   => "JG",
      lastname       => "Berlichingen zu~Hornberg",
      lastname_i     => "B.~z.~H.",
      lastname_it    => "BzH",
      nameinitstring => "v_Berlichingen_zu_Hornberg_JG",
      namestring     => "von Berlichingen zu Hornberg, Johann Gottfried",
      prefix         => "von",
      prefix_i       => "v.",
      prefix_it      => "v",
      strip          => { firstname => 0, lastname => 0, prefix => 0, suffix => undef },
      suffix         => undef,
      suffix_i       => undef,
      suffix_it      => undef};

my $name4 =
    { firstname      => "Johann~Gottfried",
      firstname_i    => "J.~G.",
      firstname_it   => "JG",
      lastname       => "Berlichingen zu~Hornberg",
      lastname_i     => "B.~z.~H.",
      lastname_it    => "BzH",
      nameinitstring => "Berlichingen_zu_Hornberg_JG",
      namestring     => "von Berlichingen zu Hornberg, Johann Gottfried",
      prefix         => "von",
      prefix_i       => "v.",
      prefix_it      => "v",
      strip          => { firstname => 0, lastname => 0, prefix => 0, suffix => undef },
      suffix         => undef,
      suffix_i       => undef,
      suffix_it      => undef};


my $name5 =
   {  firstname      => undef,
      firstname_i    => undef,
      firstname_it   => undef,
      lastname       => "Robert and Sons, Inc.",
      lastname_i     => "R.",
      lastname_it    => "R",
      nameinitstring => "{Robert_and_Sons,_Inc.}",
      namestring     => "Robert and Sons, Inc.",
      prefix         => undef,
      prefix_i       => undef,
      prefix_it      => undef,
      strip          => { firstname => undef, lastname => 1, prefix => undef, suffix => undef },
      suffix         => undef,
      suffix_i       => undef,
      suffix_it      => undef};


my $name6 =
   {  firstname => 'ʿAbdallāh',
      firstname_i => 'A.',
      firstname_it => 'A',
      lastname => 'al-Ṣāliḥ',
      lastname_i => 'Ṣ.',
      lastname_it => 'Ṣ',
      prefix         => undef,
      prefix_i       => undef,
      prefix_it      => undef,
      suffix => undef,
      suffix_i => undef,
      suffix_it => undef,
      strip => { firstname => 0, lastname => 0, prefix => undef, suffix => undef },
      namestring => 'al-Ṣāliḥ, ʿAbdallāh',
      nameinitstring => 'al-Ṣāliḥ_A' } ;


my $name7 =
   {  firstname    => 'Jean Charles~Gabriel',
      firstname_i  => 'J.~C.~G.',
      firstname_it => 'JCG',
      lastname_i   => 'V.~P.',
      lastname_it  => 'VP',
      lastname     => 'Vallée~Poussin',
      prefix       => 'de~la',
      prefix_i     => 'd.~l.',
      prefix_it    => 'dl',
      suffix       => undef,
      suffix_i     => undef,
      suffix_it    => undef,
      strip => { firstname => 0, lastname => 0, prefix => 0, suffix => undef },
      namestring => 'de la Vallée Poussin, Jean Charles Gabriel',
      nameinitstring => 'dl_Vallée_Poussin_JCG' } ;
my $name8 =
   {  firstname    => 'Jean Charles Gabriel',
      firstname_i  => 'J.',
      firstname_it => 'J',
      lastname     => 'Vallée~Poussin',
      lastname_i   => 'V.~P.',
      lastname_it  => 'VP',
      prefix       => 'de~la',
      prefix_i     => 'd.~l.',
      prefix_it    => 'dl',
      suffix       => undef,
      suffix_i     => undef,
      suffix_it    => undef,
      strip => { firstname => 1, lastname => 0, prefix => 0, suffix => undef },
      namestring => 'de la Vallée Poussin, Jean Charles Gabriel',
      nameinitstring => 'Vallée_Poussin_J' } ;
my $name9 =
   {  firstname     => 'Jean Charles Gabriel {de la}~Vallée',
      firstname_i   => 'J.~C. G. d.~V.',
      firstname_it  => 'JCGdV',
      lastname      => 'Poussin',
      lastname_i    => 'P.',
      lastname_it   => 'P',
      prefix       => undef,
      prefix_i     =>  undef,
      prefix_it    => undef,
      suffix        => undef,
      suffix_i      => undef,
      suffix_it     => undef,
      strip => { firstname => 0, lastname => 0, prefix => undef, suffix => undef },
      namestring => 'Poussin, Jean Charles Gabriel {de la} Vallée',
      nameinitstring => 'Poussin_JCGdV' } ;
my $name10 =
   {  firstname    => 'Jean Charles~Gabriel',
      firstname_i  => 'J.~C.~G.',
      firstname_it => 'JCG',
      lastname     => 'Vallée Poussin',
      lastname_i   => 'V.',
      lastname_it  => 'V',
      prefix       => 'de~la',
      prefix_i     => 'd.~l.',
      prefix_it    => 'dl',
      suffix       => undef,
      suffix_i     => undef,
      suffix_it    => undef,
      strip => { firstname => 0, lastname => 1, prefix => 0, suffix => undef },
      namestring => 'de la Vallée Poussin, Jean Charles Gabriel',
      nameinitstring => '{Vallée_Poussin}_JCG' } ;
my $name11 =
   {  firstname    => 'Jean Charles Gabriel',
      firstname_i  => 'J.',
      firstname_it => 'J',
      lastname     => 'Vallée Poussin',
      lastname_i   => 'V.',
      lastname_it  => 'V',
      prefix       => 'de~la',
      prefix_i     => 'd.~l.',
      prefix_it    => 'dl',
      suffix       => undef,
      suffix_i     => undef,
      suffix_it    => undef,
      strip => { firstname => 1, lastname => 1, prefix => 0, suffix => undef },
      namestring => 'de la Vallée Poussin, Jean Charles Gabriel',
      nameinitstring => '{Vallée_Poussin}_J' } ;

my $name12 =
   {  firstname    => 'Jean Charles~Gabriel',
      firstname_i  => 'J.~C.~G.',
      firstname_it => 'JCG',
      lastname      => 'Poussin',
      lastname_i    => 'P.',
      lastname_it   => 'P',
      prefix       => undef,
      prefix_i     => undef,
      prefix_it    => undef,
      suffix       => undef,
      suffix_i     => undef,
      suffix_it    => undef,
      strip => { firstname => 0, lastname => 0, prefix => undef, suffix => undef },
      namestring => 'Poussin, Jean Charles Gabriel',
      nameinitstring => 'Poussin_JCG' } ;
my $name13 =
   {  firstname    => 'Jean~Charles',
      firstname_i  => 'J.~C.',
      firstname_it => 'JC',
      lastname     => 'Poussin Lecoq',
      lastname_i   => 'P.',
      lastname_it  => 'P',
      prefix       => undef,
      prefix_i     => undef,
      prefix_it    => undef,
      suffix       => undef,
      suffix_i     => undef,
      suffix_it    => undef,
      strip => { firstname => 0, lastname => 1, prefix => undef, suffix => undef },
      namestring => 'Poussin Lecoq, Jean Charles',
      nameinitstring => '{Poussin_Lecoq}_JC' } ;
my $name14 =
   {  firstname    => 'J.~C.~G.',
      firstname_i  => 'J.~C.~G.',
      firstname_it => 'JCG',
      lastname     => 'Vallée~Poussin',
      lastname_i   => 'V.~P.',
      lastname_it  => 'VP',
      prefix       => 'de~la',
      prefix_i     => 'd.~l.',
      prefix_it    => 'dl',
      suffix       => undef,
      suffix_i     => undef,
      suffix_it    => undef,
      strip => { firstname => 0, lastname => 0, prefix => 0, suffix => undef },
      namestring => 'de la Vallée Poussin, J. C. G.',
      nameinitstring => 'dl_Vallée_Poussin_JCG' } ;


my $l1 = q|  \entry{L1}{book}{}
    \name{labelname}{1}{}{%
      {{}{Adler}{A.}{Alfred}{A.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Adler}{A.}{Alfred}{A.}{}{}{}{}}%
    }
    \strng{namehash}{AA1}
    \strng{fullhash}{AA1}
    \field{sortinit}{A}
  \endentry

|;

my $l2 = q|  \entry{L2}{book}{}
    \name{labelname}{1}{}{%
      {{}{Bull}{B.}{Bertie~B.}{B.~B.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Bull}{B.}{Bertie~B.}{B.~B.}{}{}{}{}}%
    }
    \strng{namehash}{BBB1}
    \strng{fullhash}{BBB1}
    \field{sortinit}{B}
  \endentry

|;

my $l3 = q|  \entry{L3}{book}{}
    \name{labelname}{1}{}{%
      {{}{Crop}{C.}{C.~Z.}{C.~Z.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Crop}{C.}{C.~Z.}{C.~Z.}{}{}{}{}}%
    }
    \strng{namehash}{CCZ1}
    \strng{fullhash}{CCZ1}
    \field{sortinit}{C}
  \endentry

|;

my $l4 = q|  \entry{L4}{book}{}
    \name{labelname}{1}{}{%
      {{}{Decket}{D.}{Derek~D}{D.~D.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Decket}{D.}{Derek~D}{D.~D.}{}{}{}{}}%
    }
    \strng{namehash}{DDD1}
    \strng{fullhash}{DDD1}
    \field{sortinit}{D}
  \endentry

|;

my $l5 = q|  \entry{L5}{book}{}
    \name{labelname}{1}{}{%
      {{}{Eel}{E.}{Egbert}{E.}{von}{v.}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Eel}{E.}{Egbert}{E.}{von}{v.}{}{}}%
    }
    \strng{namehash}{vEE1}
    \strng{fullhash}{vEE1}
    \field{sortinit}{v}
  \endentry

|;

my $l6 = q|  \entry{L6}{book}{}
    \name{labelname}{1}{}{%
      {{}{Frome}{F.}{Francis}{F.}{van~der~valt}{v.~d.~v.}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Frome}{F.}{Francis}{F.}{van~der~valt}{v.~d.~v.}{}{}}%
    }
    \strng{namehash}{vdvFF1}
    \strng{fullhash}{vdvFF1}
    \field{sortinit}{v}
  \endentry

|;

my $l7 = q|  \entry{L7}{book}{}
    \name{labelname}{1}{}{%
      {{}{Gloom}{G.}{Gregory~R.}{G.~R.}{van}{v.}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Gloom}{G.}{Gregory~R.}{G.~R.}{van}{v.}{}{}}%
    }
    \strng{namehash}{vGGR1}
    \strng{fullhash}{vGGR1}
    \field{sortinit}{v}
  \endentry

|;

my $l8 = q|  \entry{L8}{book}{}
    \name{labelname}{1}{}{%
      {{}{Henkel}{H.}{Henry~F.}{H.~F.}{van}{v.}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Henkel}{H.}{Henry~F.}{H.~F.}{van}{v.}{}{}}%
    }
    \strng{namehash}{vHHF1}
    \strng{fullhash}{vHHF1}
    \field{sortinit}{v}
  \endentry

|;

my $l9 = q|  \entry{L9}{book}{}
    \name{labelname}{1}{}{%
      {{}{{Iliad Ipswich}}{I.}{Ian}{I.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{{Iliad Ipswich}}{I.}{Ian}{I.}{}{}{}{}}%
    }
    \strng{namehash}{II1}
    \strng{fullhash}{II1}
    \field{sortinit}{I}
  \endentry

|;


my $l10 = q|  \entry{L10}{book}{}
    \name{labelname}{1}{}{%
      {{}{Jolly}{J.}{James}{J.}{}{}{III}{I.}}%
    }
    \name{author}{1}{}{%
      {{}{Jolly}{J.}{James}{J.}{}{}{III}{I.}}%
    }
    \strng{namehash}{JIJ1}
    \strng{fullhash}{JIJ1}
    \field{sortinit}{J}
  \endentry

|;


my $l10a = q|  \entry{L10a}{book}{}
    \name{labelname}{1}{}{%
      {{}{Pimentel}{P.}{Joseph~J.}{J.~J.}{}{}{Jr.}{J.}}%
    }
    \name{author}{1}{}{%
      {{}{Pimentel}{P.}{Joseph~J.}{J.~J.}{}{}{Jr.}{J.}}%
    }
    \strng{namehash}{PJJJ1}
    \strng{fullhash}{PJJJ1}
    \field{sortinit}{P}
  \endentry

|;


my $l11 = q|  \entry{L11}{book}{}
    \name{labelname}{1}{}{%
      {{}{Kluster}{K.}{Kevin}{K.}{van}{v.}{Jr.}{J.}}%
    }
    \name{author}{1}{}{%
      {{}{Kluster}{K.}{Kevin}{K.}{van}{v.}{Jr.}{J.}}%
    }
    \strng{namehash}{vKJK1}
    \strng{fullhash}{vKJK1}
    \field{sortinit}{v}
  \endentry

|;

my $l12 = q|  \entry{L12}{book}{}
    \name{labelname}{1}{}{%
      {{}{Vall{\'e}e~Poussin}{V.~P.}{Charles Louis Xavier~Joseph}{C.~L. X.~J.}{de~la}{d.~l.}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Vall{\'e}e~Poussin}{V.~P.}{Charles Louis Xavier~Joseph}{C.~L. X.~J.}{de~la}{d.~l.}{}{}}%
    }
    \strng{namehash}{dlVPCLXJ1}
    \strng{fullhash}{dlVPCLXJ1}
    \field{sortinit}{d}
  \endentry

|;

my $l13 = q|  \entry{L13}{book}{}
    \name{labelname}{1}{}{%
      {{}{Van de~Graaff}{V.~d.~G.}{R.~J.}{R.~J.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Van de~Graaff}{V.~d.~G.}{R.~J.}{R.~J.}{}{}{}{}}%
    }
    \strng{namehash}{VdGRJ1}
    \strng{fullhash}{VdGRJ1}
    \field{sortinit}{V}
  \endentry

|;

my $l14 = q|  \entry{L14}{book}{}
    \name{labelname}{1}{}{%
      {{}{St~John-Mollusc}{S.~J.-M.}{Oliver}{O.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{St~John-Mollusc}{S.~J.-M.}{Oliver}{O.}{}{}{}{}}%
    }
    \strng{namehash}{SJMO1}
    \strng{fullhash}{SJMO1}
    \field{sortinit}{S}
  \endentry

|;

my $l15 = q|  \entry{L15}{book}{}
    \name{labelname}{1}{}{%
      {{}{Gompel}{G.}{Roger~P.{\,}G.}{R.~P.}{van}{v.}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Gompel}{G.}{Roger~P.{\,}G.}{R.~P.}{van}{v.}{}{}}%
    }
    \strng{namehash}{vGRP1}
    \strng{fullhash}{vGRP1}
    \field{sortinit}{v}
  \endentry

|;

my $l16 = q|  \entry{L16}{book}{}
    \name{labelname}{1}{}{%
      {{}{Gompel}{G.}{Roger~{P.\,G.}}{R.~P.}{van}{v.}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Gompel}{G.}{Roger~{P.\,G.}}{R.~P.}{van}{v.}{}{}}%
    }
    \strng{namehash}{vGRP1}
    \strng{fullhash}{vGRP1}
    \field{sortinit}{v}
  \endentry

|;

my $l17 = q|  \entry{L17}{book}{}
    \name{labelname}{1}{}{%
      {{}{Lovecraft}{L.}{Bill~H.{\,}P.}{B.~H.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Lovecraft}{L.}{Bill~H.{\,}P.}{B.~H.}{}{}{}{}}%
    }
    \strng{namehash}{LBH1}
    \strng{fullhash}{LBH1}
    \field{sortinit}{L}
  \endentry

|;

my $l18 = q|  \entry{L18}{book}{}
    \name{labelname}{1}{}{%
      {{}{Lovecraft}{L.}{Bill~{H.\,P.}}{B.~H.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Lovecraft}{L.}{Bill~{H.\,P.}}{B.~H.}{}{}{}{}}%
    }
    \strng{namehash}{LBH1}
    \strng{fullhash}{LBH1}
    \field{sortinit}{L}
  \endentry

|;

my $l19 = q|  \entry{L19}{book}{}
    \name{labelname}{1}{}{%
      {{}{Mustermann}{M.}{Klaus-Peter}{K.-P.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Mustermann}{M.}{Klaus-Peter}{K.-P.}{}{}{}{}}%
    }
    \strng{namehash}{MKP1}
    \strng{fullhash}{MKP1}
    \field{sortinit}{M}
  \endentry

|;

my $l20 = q|  \entry{L20}{book}{}
    \name{labelname}{1}{}{%
      {{}{Ford}{F.}{{John Henry}}{J.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Ford}{F.}{{John Henry}}{J.}{}{}{}{}}%
    }
    \strng{namehash}{FJ1}
    \strng{fullhash}{FJ1}
    \field{sortinit}{F}
  \endentry

|;

my $l21 = q|  \entry{L21}{book}{}
    \name{labelname}{1}{}{%
      {{}{Smith}{S.}{{\v S}omeone}{{\v S}.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Smith}{S.}{{\v S}omeone}{{\v S}.}{}{}{}{}}%
    }
    \strng{namehash}{SS1}
    \strng{fullhash}{SS1}
    \field{sortinit}{S}
  \endentry

|;

# sortinit is set to a diacritic-stripped fallback since the Unicode equivalent
# of the sortinit latex character macro is not valid in the bbl encoding
my $l22 = q|  \entry{L22}{book}{}
    \name{labelname}{1}{}{%
      {{}{{\v S}mith}{{\v S}.}{Someone}{S.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{{\v S}mith}{{\v S}.}{Someone}{S.}{}{}{}{}}%
    }
    \strng{namehash}{SS1}
    \strng{fullhash}{SS1}
    \field{sortinit}{S}
  \endentry

|;


my $l23 = q|  \entry{L23}{book}{}
    \name{labelname}{1}{}{%
      {{}{Smith}{S.}{Šomeone}{Š.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Smith}{S.}{Šomeone}{Š.}{}{}{}{}}%
    }
    \strng{namehash}{SŠ1}
    \strng{fullhash}{SŠ1}
    \field{sortinit}{S}
  \endentry

|;

my $l24 = q|  \entry{L24}{book}{}
    \name{labelname}{1}{}{%
      {{}{Šmith}{Š.}{Someone}{S.}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{Šmith}{Š.}{Someone}{S.}{}{}{}{}}%
    }
    \strng{namehash}{ŠS1}
    \strng{fullhash}{ŠS1}
    \field{sortinit}{Š}
  \endentry

|;

my $l25 = q|  \entry{L25}{book}{}
    \name{labelname}{1}{}{%
      {{}{{American Psychological Association, Task Force on the Sexualization of Girls}}{A.}{}{}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{{American Psychological Association, Task Force on the Sexualization of Girls}}{A.}{}{}{}{}{}{}}%
    }
    \strng{namehash}{A1}
    \strng{fullhash}{A1}
    \field{sortinit}{A}
  \endentry

|;

my $l26 = q|  \entry{L26}{book}{}
    \name{labelname}{1}{}{%
      {{}{{Sci-Art Publishers}}{S.}{}{}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{{Sci-Art Publishers}}{S.}{}{}{}{}{}{}}%
    }
    \strng{namehash}{S1}
    \strng{fullhash}{S1}
    \field{sortinit}{S}
  \endentry

|;

my $l29 = q|  \entry{L29}{book}{}
    \name{labelname}{1}{}{%
      {{}{{U.S. Department of Health and Human Services, National Institute of Mental Health, National Heart, Lung and Blood Institute}}{U.}{}{}{}{}{}{}}%
    }
    \name{author}{1}{}{%
      {{}{{U.S. Department of Health and Human Services, National Institute of Mental Health, National Heart, Lung and Blood Institute}}{U.}{}{}{}{}{}{}}%
    }
    \strng{namehash}{U1}
    \strng{fullhash}{U1}
    \field{sortinit}{U}
  \endentry

|;

is_deeply(parsename('John Doe'), $name1, 'parsename 1');
is_deeply(parsename('Doe, Jr, John'), $name2, 'parsename 2');
is_deeply(parsename('von Berlichingen zu Hornberg, Johann Gottfried', {useprefix => 1}),
                    $name3, 'parsename 3') ;
is_deeply(parsename('von Berlichingen zu Hornberg, Johann Gottfried', {useprefix => 0}),
                    $name4, 'parsename 4') ;
is_deeply(parsename('{Robert and Sons, Inc.}'), $name5, 'parsename 5') ;
is_deeply(parsename('al-Ṣāliḥ, ʿAbdallāh'), $name6, 'parsename 6') ;
is_deeply(parsename('Jean Charles Gabriel de la Vallée Poussin', {useprefix => 1}), $name7, 'parsename 7');
is_deeply(parsename('{Jean Charles Gabriel} de la Vallée Poussin'), $name8, 'parsename 8');
is_deeply(parsename('Jean Charles Gabriel {de la} Vallée Poussin'), $name9, 'parsename 9');
is_deeply(parsename('Jean Charles Gabriel de la {Vallée Poussin}'), $name10, 'parsename 10');
is_deeply(parsename('{Jean Charles Gabriel} de la {Vallée Poussin}'), $name11, 'parsename 11');
is_deeply(parsename('Jean Charles Gabriel Poussin'), $name12, 'parsename 12');
is_deeply(parsename('Jean Charles {Poussin Lecoq}'), $name13, 'parsename 13');
is_deeply(parsename('J. C. G. de la Vallée Poussin', {useprefix => 1}), $name14, 'parsename 14');


is($bibentries->entry('l1')->get_field($bibentries->entry('l1')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Adler}{A.}{Alfred}{A.}{}{}{}{}}%' . "\n", 'First Last');
is($bibentries->entry('l2')->get_field($bibentries->entry('l2')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Bull}{B.}{Bertie~B.}{B.~B.}{}{}{}{}}%' . "\n", 'First Initial. Last');
is($bibentries->entry('l3')->get_field($bibentries->entry('l3')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Crop}{C.}{C.~Z.}{C.~Z.}{}{}{}{}}%' . "\n", 'Initial. Initial. Last');
is($bibentries->entry('l4')->get_field($bibentries->entry('l4')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Decket}{D.}{Derek~D}{D.~D.}{}{}{}{}}%' . "\n", 'First Initial Last');
is($bibentries->entry('l5')->get_field($bibentries->entry('l5')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Eel}{E.}{Egbert}{E.}{von}{v.}{}{}}%' . "\n", 'First prefix Last');
is($bibentries->entry('l6')->get_field($bibentries->entry('l6')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Frome}{F.}{Francis}{F.}{van~der~valt}{v.~d.~v.}{}{}}%' . "\n", 'First prefix prefix Last');
is($bibentries->entry('l7')->get_field($bibentries->entry('l7')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Gloom}{G.}{Gregory~R.}{G.~R.}{van}{v.}{}{}}%' . "\n", 'First Initial. prefix Last');
is($bibentries->entry('l8')->get_field($bibentries->entry('l8')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Henkel}{H.}{Henry~F.}{H.~F.}{van}{v.}{}{}}%' . "\n", 'First Initial prefix Last');
is($bibentries->entry('l9')->get_field($bibentries->entry('l9')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{{Iliad Ipswich}}{I.}{Ian}{I.}{}{}{}{}}%' . "\n", 'First {Last Last}');
is($bibentries->entry('l10')->get_field($bibentries->entry('l10')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Jolly}{J.}{James}{J.}{}{}{III}{I.}}%' . "\n", 'Last, Suffix, First') ;
is($bibentries->entry('l11')->get_field($bibentries->entry('l11')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Kluster}{K.}{Kevin}{K.}{van}{v.}{Jr.}{J.}}%' . "\n", 'prefix Last, Suffix, First');
is($bibentries->entry('l13')->get_field($bibentries->entry('l13')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Van de~Graaff}{V.~d.~G.}{R.~J.}{R.~J.}{}{}{}{}}%' . "\n", 'Last Last Last, Initial. Initial.');
is($bibentries->entry('l14')->get_field($bibentries->entry('l14')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{St~John-Mollusc}{S.~J.-M.}{Oliver}{O.}{}{}{}{}}%' . "\n", 'Last Last-Last, First');
is($bibentries->entry('l15')->get_field($bibentries->entry('l15')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Gompel}{G.}{Roger~P.{\,}G.}{R.~P.}{van}{v.}{}{}}%' . "\n", 'First F.{\,}F. Last');
is($bibentries->entry('l16')->get_field($bibentries->entry('l16')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Gompel}{G.}{Roger~{P.\,G.}}{R.~P.}{van}{v.}{}{}}%' . "\n", 'First {F.\,F.} Last');
is($bibentries->entry('l17')->get_field($bibentries->entry('l17')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Lovecraft}{L.}{Bill~H.{\,}P.}{B.~H.}{}{}{}{}}%' . "\n", 'Last, First {F.\,F.}');
is($bibentries->entry('l18')->get_field($bibentries->entry('l18')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Lovecraft}{L.}{Bill~{H.\,P.}}{B.~H.}{}{}{}{}}%' . "\n", 'Last, First F.{\,}F.');
is($bibentries->entry('l19')->get_field($bibentries->entry('l19')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Mustermann}{M.}{Klaus-Peter}{K.-P.}{}{}{}{}}%' . "\n", 'Firstname with hyphen');
is($bibentries->entry('l20')->get_field($bibentries->entry('l20')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Ford}{F.}{{John Henry}}{J.}{}{}{}{}}%' . "\n", 'Protected dual first name');
is($bibentries->entry('l23')->get_field($bibentries->entry('l23')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Smith}{S.}{Šomeone}{Š.}{}{}{}{}}%' . "\n", 'Unicode firstname');
is($bibentries->entry('l24')->get_field($bibentries->entry('l24')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Šmith}{Š.}{Someone}{S.}{}{}{}{}}%' . "\n", 'Unicode lastname');
is($bibentries->entry('l25')->get_field($bibentries->entry('l25')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{{American Psychological Association, Task Force on the Sexualization of Girls}}{A.}{}{}{}{}{}{}}%' . "\n", 'Single string name');
is($bibentries->entry('l26')->get_field($bibentries->entry('l26')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{{Sci-Art Publishers}}{S.}{}{}{}{}{}{}}%' . "\n", 'Hyphen at brace level <> 0');
is($section->has_citekey('l27'), '0', 'Bad name with 3 commas');
is($section->has_citekey('l28'), '0', 'Bad name with consecutive commas');
is($bibentries->entry('l29')->get_field($bibentries->entry('l29')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{{U.S. Department of Health and Human Services, National Institute of Mental Health, National Heart, Lung and Blood Institute}}{U.}{}{}{}{}{}{}}%' . "\n",  'Escaped name with 3 commas');

# A few tests depend set to non UTF-8 output
# Have to use a new biber object when trying to change encoding as this isn't
# dealt with in ->prepare
$biber->parse_ctrlfile('names.bcf');
$biber->set_output_obj(Biber::Output::BBL->new());

# Biber options
Biber::Config->setoption('bblencoding', 'latin1');

# Now generate the information
$biber->prepare;
$out = $biber->get_output_obj;
$section = $biber->sections->get_section(0);
$bibentries = $section->bibentries;

is($bibentries->entry('l21')->get_field('namehash'), 'SS1', 'Namehash check 1');
is($bibentries->entry('l21')->get_field($bibentries->entry('l21')->get_field('labelnamename'))->nth_element(1)->get_firstname_it, '{\v S}', 'Terseinitials 1');
is($bibentries->entry('l12')->get_field($bibentries->entry('l12')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, "      {{}{Vall{\\'e}e~Poussin}{V.~P.}{Charles Louis Xavier~Joseph}{C.~L. X.~J.}{de~la}{d.~l.}{}{}}%" . "\n", 'First First First First prefix prefix Last Last');
is($bibentries->entry('l21')->get_field($bibentries->entry('l21')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{Smith}{S.}{{\v S}omeone}{{\v S}.}{}{}{}{}}%' . "\n", 'LaTeX encoded unicode firstname');
is($bibentries->entry('l22')->get_field($bibentries->entry('l22')->get_field('labelnamename'))->nth_element(1)->name_to_bbl, '      {{}{{\v S}mith}{{\v S}.}{Someone}{S.}{}{}{}{}}%' . "\n", 'LaTeX encoded unicode lastname');

unlink "*.utf8";
