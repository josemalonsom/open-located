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

use Test::More tests => 1;

my $max_files = 10;
my $total_test_files = 15;
my $remainder = $total_test_files - $max_files;

my @files = create_test_files('foo', $total_test_files);

set_mock_stdout('locate', join("\n", @files));

my @slice = @files[0 .. $max_files - 1];

my $menu_string = get_menu_selection(\@slice, $remainder);

my $result = run_script("foo", "1");

is($result->{output}, $menu_string);
