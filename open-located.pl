#!/usr/bin/env perl

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

use 5.8.0;
use strict;
use warnings;

package Locator;

sub new {

    my $class = shift;
    my $self = {};

    return bless $self, $class;
}

sub search_files {

    my ($self, $filename) = @_;

    my @all = `locate -e -i -b -r "^$filename"`;

    map { chomp } @all;

    my @files = grep(-f $_, @all);

    return @files;
}

package Viewer;

sub new {

    my $class = shift;
    my $self = { viewer => 'vi' };

    return bless $self, $class;
}

sub open {

    my ($self, $filename) = @_;

    exec($self->{viewer}, $filename);
}

package main;

my @files = Locator->new()->search_files(shift);

unless (@files) {

    print STDERR "file not found\n";
    exit(1);
}

Viewer->new()->open(shift @files);

exit(0);
