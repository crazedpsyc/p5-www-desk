#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok('WWW::Desk');
    use_ok('WWW::Desk::Article');
    use_ok('WWW::Desk::Case');
    use_ok('WWW::Desk::Customer');
    use_ok('WWW::Desk::Group');
    use_ok('WWW::Desk::User');
    use_ok('WWW::Desk::Macro');
    use_ok('WWW::Desk::Topic');
}

done_testing;
