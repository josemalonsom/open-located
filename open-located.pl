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

package ScreenMenu;

sub new {

    my $class = shift;
    my $self = { viewer => 'vi' };

    return bless $self, $class;
}

sub ask_user_to_filter_files {

    my ($self, @files) = @_;

    my $menu = $self->get_menu(@files);

    my $chosen_file;

    while ( ! $chosen_file ) {

        print STDOUT $menu;

        my $user_answer = <STDIN>;

        chomp $user_answer;

        if (defined $files[$user_answer - 1]) {
            $chosen_file = $files[$user_answer - 1];
        }
    }

    return $chosen_file;
}

sub get_menu {

    my ($self, @files) = @_;

    my $options = "";

    for  (my $i = 0; $i < @files; ++$i) {

        $options .= sprintf("[%s] %s\n", $i + 1, $files[$i]);
    }

    my $menu_template =
        "Located more than one file.\n"
        . "\n%s\n"
        . "[q] quit\n"
        . "\n"
        . "Which one do you want to open?\n";

    return sprintf($menu_template, $options);
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

if (@files > 1) {

    @files = ScreenMenu->new()->ask_user_to_filter_files(@files);
}

Viewer->new()->open(shift @files);

exit(0);
