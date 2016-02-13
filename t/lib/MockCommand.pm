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
our @EXPORT = qw(
    clear_mock_env run set_mock_log_file set_mock_stdout set_mock_exit_status);

use constant {

    EXIT_STATUS_PREFIX => 'MOCK_EXIT_STATUS_',
    LOG_PREFIX         => 'MOCK_LOG_',
    STDOUT_PREFIX      => 'MOCK_STDOUT_',
};

sub clear_mock_env {

    foreach my $key (keys(%ENV)) {

        next unless $key =~ /^MOCK_/;

        delete $ENV{$key};
    }
}

sub set_mock_log_file {

    my ($cmd, $filename) = @_;
    set_env(get_mock_log_file_var_name($cmd), $filename);
}

sub get_mock_log_file_var_name {

    return get_env_var_name(LOG_PREFIX, @_);
}

sub get_env_var_name {

    my ($prefix, $cmd) = @_;
    return $prefix . uc($cmd);
}

sub set_env {

    my ($var_name, $value) = @_;

    $ENV{$var_name} = $value;
}

sub set_mock_stdout {

    my ($cmd, $value) = @_;
    set_env(get_mock_stdout_var_name($cmd), $value);
}

sub get_mock_stdout_var_name {

    return get_env_var_name(STDOUT_PREFIX, @_);
}

sub set_mock_exit_status {

    my ($cmd, $value) = @_;
    set_env(get_mock_exit_status_var_name($cmd), $value);
}

sub get_mock_exit_status_var_name {

    return get_env_var_name(EXIT_STATUS_PREFIX, @_);
}

sub run {

    my $cmd         = basename($0);
    my $log_var     = get_mock_log_file_var_name($cmd);
    my $stdout_var  = get_mock_stdout_var_name($cmd);
    my $status_var  = get_mock_exit_status_var_name($cmd);

    if (exists $ENV{$log_var}) {

        my $log_file = $ENV{$log_var};

        open (my $log, '>', $log_file)
            or die("Error opening '$log_file': $!");

        print $log "ARGV=" . join(",",@ARGV);
    }

    if (exists $ENV{$stdout_var}) {

        print $ENV{$stdout_var};
    }

    my $exit_status = exists $ENV{$status_var}
        ? exists $ENV{$status_var}
        : 0;

    exit($exit_status);
}

1;
