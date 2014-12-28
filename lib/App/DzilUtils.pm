package App::DzilUtils;

our $DATE = '2014-12-27'; # DATE
our $VERSION = '0.04'; # VERSION

use 5.010001;
use strict;
use warnings;

our $_complete_stuff = sub {
    require Complete::Module;
    my $which = shift;
    my %args = @_;

    my $word = $args{word} // '';
    my $sep = $word =~ /::/ ? '::' : '/';
    $word =~ s/\Q$sep\E/::/g;

    # convenience: allow Foo/Bar.{pm,pod,pmc}
    $word =~ s/\.(pm|pmc|pod)\z//;

    my $ns_prefix    = 'Dist::Zilla::'.
        ($which eq 'bundle' ? 'PluginBundle' :
             $which eq 'plugin' ? 'Plugin' :
                 $which eq 'role' ? 'Role' : '').'::';

    my $compres = Complete::Module::complete_module(
        word      => $word,
        ns_prefix => $ns_prefix,
        find_pmc  => 0,
        find_pod  => 0,
    );

    for (@$compres) { s/::/$sep/g }

    {
        words => $compres,
        path_sep => $sep,
    };
};

our $_complete_bundle = sub {
    $_complete_stuff->('bundle', @_);
};

our $_complete_plugin = sub {
    $_complete_stuff->('plugin', @_);
};

our $_complete_role = sub {
    $_complete_stuff->('role', @_);
};

1;
# ABSTRACT: Collection of CLI utilities for Dist::Zilla

__END__

=pod

=encoding UTF-8

=head1 NAME

App::DzilUtils - Collection of CLI utilities for Dist::Zilla

=head1 VERSION

This document describes version 0.04 of App::DzilUtils (from Perl distribution App-DzilUtils), released on 2014-12-27.

=head1 SYNOPSIS

This distribution provides several command-line utilities related to
L<Dist::Zilla>.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/App-DzilUtils>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-App-DzilUtils>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=App-DzilUtils>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

perlancar <perlancar@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by perlancar@cpan.org.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
