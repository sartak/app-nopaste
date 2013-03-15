package App::Nopaste::Service::Ubuntu;
use strict;
use warnings;
use base 'App::Nopaste::Service';

my $languages = {
    "text"           => "Plain Text",
    "apacheconf"     => "ApacheConf",
    "as"             => "ActionScript",
    "bash"           => "Bash",
    "bat"            => "Batchfile",
    "bbcode"         => "BBCode",
    "befunge"        => "Befunge",
    "boo"            => "Boo",
    "c"              => "C",
    "c-objdump"      => "c-objdump",
    "common-lisp"    => "Common Lisp",
    "control"        => "Debian Control file",
    "cpp"            => "C++",
    "cpp-objdump"    => "cpp-objdump",
    "csharp"         => "C#",
    "css"            => "CSS",
    "css+django"     => "CSS+Django/Jinja",
    "css+erb"        => "CSS+Ruby",
    "css+genshitext" => "CSS+Genshi Text",
    "css+mako"       => "CSS+Mako",
    "css+myghty"     => "CSS+Myghty",
    "css+php"        => "CSS+PHP",
    "css+smarty"     => "CSS+Smarty",
    "d"              => "D",
    "d-objdump"      => "d-objdump",
    "delphi"         => "Delphi",
    "diff"           => "Diff",
    "django"         => "Django/Jinja",
    "dylan"          => "DylanLexer",
    "erb"            => "ERB",
    "erlang"         => "Erlang",
    "gas"            => "GAS",
    "genshi"         => "Genshi",
    "genshitext"     => "Genshi Text",
    "groff"          => "Groff",
    "haskell"        => "Haskell",
    "html"           => "HTML",
    "html+django"    => "HTML+Django/Jinja",
    "html+genshi"    => "HTML+Genshi",
    "html+mako"      => "HTML+Mako",
    "html+myghty"    => "HTML+Myghty",
    "html+php"       => "HTML+PHP",
    "html+smarty"    => "HTML+Smarty",
    "ini"            => "INI",
    "irc"            => "IRC logs",
    "java"           => "Java",
    "js"             => "JavaScript",
    "js+django"      => "JavaScript+Django/Jinja",
    "js+erb"         => "JavaScript+Ruby",
    "js+genshitext"  => "JavaScript+Genshi Text",
    "js+mako"        => "JavaScript+Mako",
    "js+myghty"      => "JavaScript+Myghty",
    "js+php"         => "JavaScript+PHP",
    "js+smarty"      => "JavaScript+Smarty",
    "jsp"            => "Java Server Page",
    "lhs"            => "Literate Haskell",
    "llvm"           => "LLVM",
    "lua"            => "Lua",
    "make"           => "Makefile",
    "mako"           => "Mako",
    "minid"          => "MiniD",
    "moocode"        => "MOOCode",
    "mupad"          => "MuPAD",
    "myghty"         => "Myghty",
    "mysql"          => "MySQL",
    "objdump"        => "objdump",
    "objective-c"    => "Objective-C",
    "ocaml"          => "OCaml",
    "perl"           => "Perl",
    "php"            => "PHP",
    "pot"            => "Gettext Catalog",
    "pycon"          => "Python console session",
    "pytb"           => "Python Traceback",
    "python"         => "Python",
    "raw"            => "Raw token data",
    "rb"             => "Ruby",
    "rbcon"          => "Ruby irb session",
    "redcode"        => "Redcode",
    "rhtml"          => "RHTML",
    "rst"            => "reStructuredText",
    "scheme"         => "Scheme",
    "smarty"         => "Smarty",
    "sourceslist"    => "Debian Sourcelist",
    "sql"            => "SQL",
    "squidconf"      => "SquidConf",
    "tex"            => "TeX",
    "text"           => "Text only",
    "trac-wiki"      => "MoinMoin/Trac Wiki markup",
    "vb.net"         => "VB.net",
    "vim"            => "VimL",
    "xml"            => "XML",
    "xml+django"     => "XML+Django/Jinja",
    "xml+erb"        => "XML+Ruby",
    "xml+mako"       => "XML+Mako",
    "xml+myghty"     => "XML+Myghty",
    "XML+PHP"        => "XML+PHP",
    "XML+SMARTY"     => "XML+Smarty",
};

sub uri { "http://paste.ubuntu.com/" }

sub fill_form {
    my $self = shift;
    my $mech = shift;
    my %args = @_;
    my $lang = $languages->{$args{lang}} if $args{lang};

    $mech->form_number(1);
    $mech->submit_form(
        fields        => {
            content => $args{text},
            do { $args{nick} ? (poster => $args{nick}) : () },
            do { $lang ? (syntax => $lang) : () },
        },
    );
}

sub return {
    my $self = shift;
    my $mech = shift;

    my $link = $mech->uri();

    return (1, $link);
}

1;

__END__

=head1 NAME

App::Nopaste::Service::Ubuntu - http://paste.ubuntu.com/

=head1 AUTHOR

gregor herrmann, C<< <gregoa@debian.org> >>

(Based on App::Nopaste::Service::Debian, written by
Ryan Niebur, C<< <ryanryan52@gmail.com> >>)

=cut

