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

#-------------------------------------------------------------------------------
#
# Configuration:
#
# $ENV{MOCK_LOG_<CMD>}: file to log the command arguments.
# $ENV{MOCK_STDOUT_<CMD>}: standard output for the command execution.
# $ENV{MOCK_EXIT_STATUS_<CMD>}: exit status for the execution.
#
# Example:
#
# $ENV{MOCK_LOG_VI} = '/tmp/vi.log';
#
#-------------------------------------------------------------------------------

package MockCommand;

use 5.8.0;
use strict;
use warnings;

use File::Basename;
use base 'Exporter';
our @EXPORT = qw/clear_mock_env run/;

sub clear_mock_env {

    foreach my $key (keys(%ENV)) {

        next unless $key =~ /^MOCK_/;

        delete $ENV{$key};
    }
}

sub run {

    my $cmd         = uc(basename($0));
    my $log_key     = 'MOCK_LOG_' . $cmd;
    my $stdout_key  = 'MOCK_STDOUT_' . $cmd;
    my $status_key  = 'MOCK_EXIT_STATUS_' . $cmd;

    if (exists $ENV{$log_key}) {

        my $log_file = $ENV{$log_key};

        open (my $log, '>', $log_file)
            or die("Error opening '$log_file': $!");

        print $log "ARGV=" . join(",",@ARGV);
    }

    if (exists $ENV{$stdout_key}) {

        print $ENV{$stdout_key};
    }

    my $exit_status = exists $ENV{$status_key}
        ? exists $ENV{$status_key}
        : 0;

    exit($exit_status);
}

1;
