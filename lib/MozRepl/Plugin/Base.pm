package MozRepl::Plugin::Base;

use strict;
use warnings;

use base qw(Class::Accessor::Fast);

use Carp qw(croak);
use Template;
use Template::Provider::FromDATA;

__PACKAGE__->mk_accessors($_) for (qw/template/);

=head1 NAME

MozRepl::Plugin::Base - The fantastic new MozRepl::Plugin::Base!

=head1 VERSION

version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

=head1 METHODS

=head2 new

=cut

sub new {
    my ($class, $args) = @_;

    my $provider = Template::Provider::FromDATA->new({
        CLASSES => $class
    });
    $args->{template} = Template->new({
        LOAD_TEMPLATES => [$provider],
        PRE_CHOMP => 1
    });

    my $self = $class->SUPER::new($args);

    return $self;
}

=head2 setup

=cut

sub setup {
    my ($self, $ctx, @args) = @_;
}

=head2 execute

=cut

sub execute {
    my ($self, $ctx, @args) = @_;

    croak('Please override this method');
}

=head2 method_name

=cut

sub method_name {
    return "";
}

=head2 help

=cut

sub help {
    my ($self, $ctx, $variable) = @_;
    my $help = '';
    ### later
    return $help;
}

=head2 process

=cut

sub process {
    my ($self, $name, $vars) = @_;

    my $output = '';

    $self->template->process($name, $vars, \$output);
    return $output;
}

=head1 AUTHOR

Toru Yamaguchi, C<< <zigorou@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-mozrepl-plugin-base@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2007 Toru Yamaguchi, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of MozRepl::Plugin::Base
