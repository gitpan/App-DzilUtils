package App::DzilUtils;

our $DATE = '2014-11-28'; # DATE
our $VERSION = '0.02'; # VERSION

use 5.010001;
use strict;
use warnings;

our $_complete_plugin_or_bundle = sub {
    require Complete::Module;
    my $which = shift;
    my %args = @_;

    my $word = $args{word} // '';

    # convenience: allow Foo/Bar.{pm,pod,pmc}
    $word =~ s/\.(pm|pmc|pod)\z//;

    # compromise, if word doesn't contain :: we use the safer separator /, but
    # if already contains '::' we use '::' (but this means in bash user needs to
    # use quote (' or ") to make completion behave as expected since : is a word
    # break character in bash/readline.
    my $sep = $word =~ /::/ ? '::' : '/';
    $word =~ s/\W+/::/g;
    my $ns_prefix    = 'Dist::Zilla::Plugin'.
        ($which eq 'bundle' ? 'Bundle':'').'::';

    {
        words => Complete::Module::complete_module(
            word      => $word,
            ns_prefix => $ns_prefix,
            find_pmc  => 0,
            find_pod  => 0,
            separator => $sep,
            ci        => 1, # convenience
        ),
        path_sep => $sep,
    };
};

our $_complete_plugin = sub {
    $_complete_plugin_or_bundle->('plugin', @_);
};

our $_complete_bundle = sub {
    $_complete_plugin_or_bundle->('bundle', @_);
};

1;
# ABSTRACT: Collection of CLI utilities for Dist::Zilla

__END__

=pod

=encoding UTF-8

=head1 NAME

App::DzilUtils - Collection of CLI utilities for Dist::Zilla

=head1 VERSION

This document describes version 0.02 of App::DzilUtils (from Perl distribution App-DzilUtils), released on 2014-11-28.

=head1 SYNOPSIS

This distribution provides the following command-line utilities:

 list-dzil-bundle-contents
 list-dzil-bundles
 list-dzil-plugin-roles
 list-dzil-plugins

Bash tab completion is available. To activate, put this in your shell script
startup:

 complete -C list-dzil-bundle-contents list-dzil-bundle-contents
 complete -C list-dzil-bundles         list-dzil-bundles
 complete -C list-dzil-plugin-roles    list-dzil-plugin-roles
 complete -C list-dzil-plugins         list-dzil-plugins

Check back often, there will be more utilities added.

=head1 FAQ

=head2 In shell completion, why do you use / (slash) instead of :: (double colon) as it should be?

If you type module name which doesn't contain any ::, / will be used as
namespace separator. Otherwise if you already type ::, it will use ::.

Colon is problematic because by default it is a word breaking character in bash.
This means, in this command:

 % list-dzil-bundle-contents Author:<tab>

bash is completing a new word (empty string), and in this:

 % list-dzil-bundle-contents Author::SHARYAN<tab>

bash is completing C<SHARYAN> instead of what we want C<Author::SHARYAN>.

The solution is to use quotes, e.g.

 % list-dzil-bundle-contents "Author::SHARYAN<tab>
 % list-dzil-bundle-contents 'Author::SHARYAN<tab>

or, use /:

 % list-dzil-bundle-contents author/sharyan<tab>

Note that most completion are made case-insensitive for convenience.

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
