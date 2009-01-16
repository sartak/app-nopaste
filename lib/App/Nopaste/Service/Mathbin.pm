package App::Nopaste::Service::Mathbin;
use strict;
use warnings;
use base 'App::Nopaste::Service';

sub uri { 'http://www.mathbin.net/' }
sub forbid_in_default { 1 }

sub fill_form {
    my $self = shift;
    my $mech = shift;
    my %args = @_;

    $mech->submit_form(
        form_number   => 1,
        fields        => {
            body => $self->fix_eqns($args{text}),
            do { $args{desc} ? (title => $args{desc}) : () },
            do { $args{nick} ? (name  => $args{nick}) : () },
        },
    );
}

sub return {
    my $self = shift;
    my $mech = shift;

    my $result = $mech->base;

    return (1, $result) if $result =~ /\/\d+$/;
    return (0, "Paste unsuccessful");
}

sub fix_eqns {
    my $self = shift;
    my $text = shift;

    $text =~ s"\\\["[EQ]"g;
    $text =~ s"\\\]"[/EQ]"g;

    my @text = split /\$\$/, $text, -1;
    $text = '';
    my $inside = 0;
    for (@text) {
        $text .= $_;
        if ($inside) {
            $text .= '[/EQ]';
            $inside = 0;
        }
        else {
            $text .= '[EQ]';
            $inside = 1;
        }
    }
    $text =~ s/\[EQ\]$//;

    @text = split /\$/, $text, -1;
    $text = '';
    $inside = 0;
    for (@text) {
        $text .= $_;
        if ($inside) {
            $text .= '[/IEQ]';
            $inside = 0;
        }
        else {
            $text .= '[IEQ]';
            $inside = 1;
        }
    }
    $text =~ s/\[IEQ\]$//;

    return $text;
}

=head1 NAME

App::Nopaste::Service::Mathbin - http://www.mathbin.net/

=head1 AUTHOR

Jesse Luehrs, C<< <jluehrs2 at uiuc.edu> >>

=cut

1;
