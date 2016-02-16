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
our @EXPORT = qw(clear_mock_env
    run_script set_mock_log_file set_mock_stdout set_mock_exit_status
    create_test_directory create_test_file create_test_files
    get_mock_log_for get_menu_selection_content);

BEGIN {

    use MockCommand;
    clear_mock_env();
}

use Config;
$ENV{PATH} = 't/mocks' . $Config{path_sep} . $ENV{PATH};
use File::Temp qw(tempdir);

sub run_script {

    my $param = shift || '';
    my @user_input = @_;

    my $script = './open-located.pl';

    my $cmd = "$script $param 2>&1";

    if (@user_input) {

        my $user_input = join("\n", @user_input);
        $cmd = "echo \"$user_input\" | $cmd";
    }

    my $output = `$cmd`;
    my $status = $? >> 8;

    return { output => $output, status => $status };
}

my $temp_dir;

sub create_test_file {

    my $filename = shift;
    my $temp_dir = get_temp_dir();

    $filename = $temp_dir . '/' . $filename;

    open(my $fh, '>', $filename)
        or die("Error opening $filename: $!");

    return $filename;
}

sub get_temp_dir {

    unless (defined $temp_dir) {

        $temp_dir = tempdir(CLEANUP => 1);
    }

    return $temp_dir;
}

sub create_test_directory {

    my $dirname = shift;

    my $temp_dir = get_temp_dir();

    $dirname = $temp_dir . '/' . $dirname;

    mkdir($dirname)
        or die("Error creating directory $dirname: $!");

    return $dirname;
}

sub get_temp_file {

    return File::Temp->new();
}

sub get_mock_log_for {

    my $cmd = shift;
    my $tmp = get_temp_file();

    set_mock_log_file($cmd, $tmp->filename);

    return $tmp;
}

sub create_test_files {

    my $prefix = shift;
    my $total = shift || 1;

    my @files;

    for (my $i = 1; $i <= $total; ++$i) {

        push(@files, create_test_file($prefix . $i));
    }

    return @files;
}

sub get_menu_selection_content {

    my @items = @_;
    my $content = "";

    for (my $i = 0; $i < @items; ++$i) {

        $content .= sprintf("[%d] %s\n", $i + 1, $items[$i]);
    }

    return $content;
}

1;
