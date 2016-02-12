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

package BaseTestCase;

use 5.8.8;
use strict;
use warnings;

use base 'Exporter';
our @EXPORT = qw(clear_mock_env run_script);

use Config;
$ENV{PATH} = 't/mocks' . $Config{path_sep} . $ENV{PATH};

sub run_script {

    my $param = shift || '';

    my $script = './open-located.pl';

    my $output = `$script $param 2>&1`;
    my $status = $? >> 8;

    return { output => $output, status => $status };
}
