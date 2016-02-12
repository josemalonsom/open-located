#-------------------------------------------------------------------------------
#
# Copyright (C) 2016  Jose M. Alonso M.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#-------------------------------------------------------------------------------

use 5.8.8;
use strict;
use warnings;

use lib './t/lib';
use Test::More tests => 5;

use BaseTestCase;
use MockCommand;

clear_mock_env();

my $result;

$result = run_script("foo");
is($result->{status}, 1, "fails if file isn't found");
is($result->{output}, "file not found\n", "shows an error message if file isn't found");

$ENV{'MOCK_STDOUT_LOCATE'} = "/dir2/foo\n";
$result = run_script("foo");
is($result->{status}, 0, "ends with success if file is found");

$ENV{'MOCK_STDOUT_LOCATE'} = "/dir2/foo\n";

my $log = "/tmp/log.vi";
$ENV{'MOCK_LOG_VI'} = $log;
$result = run_script("foo");

open(my $fh, '<', $log) or die($!);;

my @lines = <$fh>;

ok(@lines);
chomp $lines[0];
is($lines[0], "ARGV=/dir2/foo", "opens the found file");
