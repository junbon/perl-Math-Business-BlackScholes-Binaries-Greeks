use Test::More tests => 73;
use Test::NoWarnings;

use BOM::Utility::Format::Numbers qw( roundnear );

use BOM::Utility::Math::Greeks::Delta;
use BOM::Utility::Math::Greeks::Gamma;
use BOM::Utility::Math::Greeks::Theta;
use BOM::Utility::Math::Greeks::Vanna;
use BOM::Utility::Math::Greeks::Vega;
use BOM::Utility::Math::Greeks::Volga;

my $S     = 1.35;
my $t     = 7 / 365;
my $sigma = 0.11;
my $r     = 0.002;
my $q     = 0.001;

my @test_cases = ({
        type     => 'CALL',
        barriers => [1.36],
        delta    => 17.1969,
        gamma    => 397.7032,
        theta    => -4.4077,
        vanna    => -119.8414,
        vega     => 1.5291,
        volga    => -25.0014,
    },
    {
        type     => 'PUT',
        barriers => [1.36],
        delta    => -17.1969,
        gamma    => -397.7032,
        theta    => 4.4097,
        vanna    => 119.8414,
        vega     => -1.5291,
        volga    => 25.0014,
    },
    {
        type     => 'VANILLA_CALL',
        barriers => [1.36],
        delta    => 0.3172,
        gamma    => 17.3243,
        theta    => -0.1914,
        vanna    => 1.5897,
        vega     => 0.0666,
        volga    => 0.1413,
    },
    {
        type     => 'VANILLA_PUT',
        barriers => [1.36],
        delta    => -0.6828,
        gamma    => 17.3243,
        theta    => -0.1901,
        vanna    => 1.5897,
        vega     => 0.0666,
        volga    => 0.1413,
    },
    {
        type     => 'ONETOUCH',
        barriers => [1.36],
        delta    => 34.5897,
        gamma    => 806.1289,
        theta    => -8.9339,
        vanna    => -238.0101,
        vega     => 3.1084,
        volga    => -49.8754,
    },
    {
        type     => 'NOTOUCH',
        barriers => [1.36],
        delta    => -34.5882,
        gamma    => -806.0155,
        theta    => 8.9347,
        vanna    => 238.0067,
        vega     => -3.1082,
        volga    => 49.8739,
    },
    {
        type     => 'EXPIRYRANGE',
        barriers => [1.36, 1.34],
        delta    => 0.0764,
        gamma    => -815.1082,
        theta    => 8.9881,
        vanna    => 0.4024,
        vega     => -3.1339,
        volga    => 50.2401,
    },
    {
        type     => 'EXPIRYMISS',
        barriers => [1.36, 1.34],
        delta    => -0.0764,
        gamma    => 815.1082,
        theta    => -8.9861,
        vanna    => -0.4024,
        vega     => 3.1339,
        volga    => -50.2401,
    },
    {
        type     => 'RANGE',
        barriers => [1.36, 1.34],
        delta    => -0.0042,
        gamma    => -170.3061,
        theta    => 1.8778,
        vanna    => 0.4036,
        vega     => -0.6548,
        volga    => 56.1613,
    },
    {
        type     => 'UPORDOWN',
        barriers => [1.36, 1.34],
        delta    => 0.0042,
        gamma    => 170.4863,
        theta    => -1.8778,
        vanna    => -0.4037,
        vega     => 0.6549,
        volga    => -56.1652,
    },
    {
        type     => 'RANGE',
        barriers => [1.35, 1.34],
        delta    => 0,
        gamma    => 0,
        theta    => 0.002,
        vanna    => 0.0002,
        vega     => 0,
        volga    => 0,
    },
    {
        type     => 'UPORDOWN',
        barriers => [1.36, 1.35],
        delta    => -0.0009,
        gamma    => 0.1815,
        theta    => 0,
        vanna    => 0.0165,
        vega     => 0,
        volga    => 0,
    },
);

foreach my $case (@test_cases) {
    my $bet_type = $case->{type};
    foreach my $greek (qw(delta gamma theta vanna vega volga)) {
        my $formula_name = 'BOM::Utility::Math::Greeks::' . ucfirst($greek) . '::' . lc($bet_type);
        my $computed_value = &$formula_name($S, @{$case->{barriers}}, $t, $r, $r - $q, $sigma), my $test_value = $case->{$greek};
        is(roundnear(1e-4, $computed_value), $test_value, $bet_type . ' ' . $greek);
    }
}
