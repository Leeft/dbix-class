use strict;
use warnings;

use Test::More;
use lib qw(t/lib);
use DBICTest;

plan tests => 25;

my $schema = DBICTest->init_schema();
my $rs = $schema->resultset('Artist');

RETURN_RESULTSETS: {

	my ($crap, $girl, $damn) = $rs->populate( [
	  { artistid => 4, name => 'Manufactured Crap', cds => [ 
		  { title => 'My First CD', year => 2006 },
		  { title => 'Yet More Tweeny-Pop crap', year => 2007 },
		] 
	  },
	  { artistid => 5, name => 'Angsty-Whiny Girl', cds => [
		  { title => 'My parents sold me to a record company' ,year => 2005 },
		  { title => 'Why Am I So Ugly?', year => 2006 },
		  { title => 'I Got Surgery and am now Popular', year => 2007 }

		]
	  },
	  { artistid=>6, name => 'Like I Give a Damn' }

	] );
	
	isa_ok( $crap, 'DBICTest::Artist', "Got 'Artist'");
	isa_ok( $damn, 'DBICTest::Artist', "Got 'Artist'");
	isa_ok( $girl, 'DBICTest::Artist', "Got 'Artist'");	
	
	ok( $crap->name eq 'Manufactured Crap', "Got Correct name for result object");
	ok( $girl->name eq 'Angsty-Whiny Girl', "Got Correct name for result object");
	
	use Data::Dump qw/dump/;
	
	ok( $crap->cds->count == 2, "got Expected Number of Cds");
	ok( $girl->cds->count == 3, "got Expected Number of Cds");
}

RETURN_VOID: {

	$rs->populate( [
	  { artistid => 7, name => 'Manufactured CrapB', cds => [ 
		  { title => 'My First CDB', year => 2006 },
		  { title => 'Yet More Tweeny-Pop crapB', year => 2007 },
		] 
	  },
	  { artistid => 8, name => 'Angsty-Whiny GirlB', cds => [
		  { title => 'My parents sold me to a record companyB' ,year => 2005 },
		  { title => 'Why Am I So Ugly?B', year => 2006 },
		  { title => 'I Got Surgery and am now PopularB', year => 2007 }

		]
	  },
	  {artistid=>9,  name => 'XXXX' }

	] );
	
	my $artist = $rs->find(7);

	ok($artist, 'Found artist');
	is($artist->name, 'Manufactured CrapB');
	is($artist->cds->count, 2, 'Has CDs');

	my @cds = $artist->cds;

	is($cds[0]->title, 'My First CDB', 'A CD');
	is($cds[0]->year,  2006, 'Published in 2006');

	is($cds[1]->title, 'Yet More Tweeny-Pop crapB', 'Another crap CD');
	is($cds[1]->year,  2007, 'Published in 2007');

	$artist = $rs->find(8);
	ok($artist, 'Found artist');
	is($artist->name, 'Angsty-Whiny GirlB');
	is($artist->cds->count, 3, 'Has CDs');

	@cds = $artist->cds;


	is($cds[0]->title, 'My parents sold me to a record companyB', 'A CD');
	is($cds[0]->year,  2005, 'Published in 2005');

	is($cds[1]->title, 'Why Am I So Ugly?B', 'A Coaster');
	is($cds[1]->year,  2006, 'Published in 2006');

	is($cds[2]->title, 'I Got Surgery and am now PopularB', 'Selling un-attainable dreams');
	is($cds[2]->year,  2007, 'Published in 2007');

	$artist = $rs->search({name => 'XXXX'})->single;
	ok($artist, "Got Expected Artist Result");

	is($artist->cds->count, 0, 'No CDs');

}

