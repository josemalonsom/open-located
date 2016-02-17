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
use BaseTestCase;

use Test::More tests => 3;

my @files = create_test_files('foo', 2);
set_mock_stdout('locate', join("\n", @files));

my $tmp = get_mock_log_for('vi');

my $expected = get_menu_selection(\@files);

my $result = run_script("foo", "2");

is($result->{output}, $expected);

open(my $fh, '<', $tmp->filename) or die("Error opening $tmp->filename: $!");
my @lines = <$fh>;

ok(@lines);

is($lines[0], "ARGV=$files[1]", "opens the choosen file");
