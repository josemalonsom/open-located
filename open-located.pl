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

    my ($class, $max_files) = @_;

    $max_files ||= 10;

    my $self = {
        max_files => $max_files,
        viewer          => 'vi'
    };

    return bless $self, $class;
}

sub ask_user_to_filter_files {

    my ($self, @files) = @_;
    my $menu = $self->get_menu(\@files);
    my $chosen_file;

    while ( ! $chosen_file ) {

        print STDOUT $menu;

        my $user_answer = <STDIN>;

        chomp $user_answer;

        $self->cancel_and_exit() if $user_answer eq 'q';

        if ($user_answer !~ /^\d+$/ || ! defined $files[$user_answer - 1]) {

            print "\nincorrect option [$user_answer]\n\n";
            next;
        }

        $chosen_file = $files[$user_answer - 1];
    }

    return $chosen_file;
}

sub cancel_and_exit {

    print "canceled by user\n";
    exit(1);
}

sub get_menu {

    my ($self, $files) = @_;

    my $content = $self->get_selection_content($files);

    if ($self->{max_files} < @{$files}) {

        my $diff = @{$files} - $self->{max_files};
        $content .= "\n(there are $diff more files not shown)\n";
    }

    my $menu_template =
        "Located more than one file.\n"
        . "\n%s\n"
        . "[q] quit\n"
        . "\n"
        . "Which one do you want to open?\n";

    return sprintf($menu_template, $content);
}

sub get_selection_content {

    my ($self, $files) = @_;
    my $content = "";

    my $max_index = $self->{max_files} <= @{$files}
        ? $self->{max_files}
        : @{$files};

    for  (my $i = 0; $i < $max_index; ++$i) {

        $content .= sprintf("[%s] %s\n", $i + 1, @{$files}[$i]);
    }

    return $content;
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
