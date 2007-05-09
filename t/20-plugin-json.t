use Test::More tests => 2;
use MozRepl;
use MozRepl::Util;

SKIP: {
    my $repl = MozRepl->new;

    eval {
        $repl->setup(
            { plugins => { plugins => [qw/JSON/] } } );
    };
    skip( "MozRepl is not started or MozLab is not installed.", 2 ) if ($@);

    ok( $repl->can('json') );
    is($repl->json({ source => MozRepl::Util->javascript_value({a => 1, b => 2})}), q|{"a":1,"b":2}|);
}
