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

my @files = create_test_files('foo', 5);

set_mock_stdout('locate', join("\n", @files));

my $timestamp = "1451606523";
my @newest_to_older = reverse(@files);

foreach my $file (@newest_to_older) {

    utime($timestamp, $timestamp, $file);

    $timestamp += 60;
}

my $menu_string =
    "Located more than one file.\n"
    . "\n"
    . get_menu_selection_content(@newest_to_older)
    . "\n"
    . "[q] quit\n"
    . "\n"
    . "Which one do you want to open?\n";

my $result = run_script("foo", "1");

is($result->{output},$menu_string,
    'files should be ordered by modification time in ascending order');
