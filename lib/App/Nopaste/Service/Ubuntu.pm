package App::Nopaste::Service::Ubuntu;
use strict;
use warnings;
use base 'App::Nopaste::Service';

my $languages = {
    "Plain Text"                => "text",
    "ApacheConf"                => "apacheconf",
    "ActionScript"              => "as",
    "Bash"                      => "bash",
    "Batchfile"                 => "bat",
    "BBCode"                    => "bbcode",
    "Befunge"                   => "befunge",
    "Boo"                       => "boo",
    "C"                         => "c",
    "c-objdump"                 => "c-objdump",
    "Common Lisp"               => "common-lisp",
    "Debian Control file"       => "control",
    "C++"                       => "cpp",
    "cpp-objdump"               => "cpp-objdump",
    "C#"                        => "csharp",
    "CSS"                       => "css",
    "CSS+Django/Jinja"          => "css+django",
    "CSS+Ruby"                  => "css+erb",
    "CSS+Genshi Text"           => "css+genshitext",
    "CSS+Mako"                  => "css+mako",
    "CSS+Myghty"                => "css+myghty",
    "CSS+PHP"                   => "css+php",
    "CSS+Smarty"                => "css+smarty",
    "D"                         => "d",
    "d-objdump"                 => "d-objdump",
    "Delphi"                    => "delphi",
    "Diff"                      => "diff",
    "Django/Jinja"              => "django",
    "DylanLexer"                => "dylan",
    "ERB"                       => "erb",
    "Erlang"                    => "erlang",
    "GAS"                       => "gas",
    "Genshi"                    => "genshi",
    "Genshi Text"               => "genshitext",
    "Groff"                     => "groff",
    "Haskell"                   => "haskell",
    "HTML"                      => "html",
    "HTML+Django/Jinja"         => "html+django",
    "HTML+Genshi"               => "html+genshi",
    "HTML+Mako"                 => "html+mako",
    "HTML+Myghty"               => "html+myghty",
    "HTML+PHP"                  => "html+php",
    "HTML+Smarty"               => "html+smarty",
    "INI"                       => "ini",
    "IRC logs"                  => "irc",
    "Java"                      => "java",
    "JavaScript"                => "js",
    "JavaScript+Django/Jinja"   => "js+django",
    "JavaScript+Ruby"           => "js+erb",
    "JavaScript+Genshi Text"    => "js+genshitext",
    "JavaScript+Mako"           => "js+mako",
    "JavaScript+Myghty"         => "js+myghty",
    "JavaScript+PHP"            => "js+php",
    "JavaScript+Smarty"         => "js+smarty",
    "Java Server Page"          => "jsp",
    "Literate Haskell"          => "lhs",
    "LLVM"                      => "llvm",
    "Lua"                       => "lua",
    "Makefile"                  => "make",
    "Mako"                      => "mako",
    "MiniD"                     => "minid",
    "MOOCode"                   => "moocode",
    "MuPAD"                     => "mupad",
    "Myghty"                    => "myghty",
    "MySQL"                     => "mysql",
    "objdump"                   => "objdump",
    "Objective-C"               => "objective-c",
    "OCaml"                     => "ocaml",
    "Perl"                      => "perl",
    "PHP"                       => "php",
    "Gettext Catalog"           => "pot",
    "Python console session"    => "pycon",
    "Python Traceback"          => "pytb",
    "Python"                    => "python",
    "Raw token data"            => "raw",
    "Ruby"                      => "rb",
    "Ruby irb session"          => "rbcon",
    "Redcode"                   => "redcode",
    "RHTML"                     => "rhtml",
    "reStructuredText"          => "rst",
    "Scheme"                    => "scheme",
    "Smarty"                    => "smarty",
    "Debian Sourcelist"         => "sourceslist",
    "SQL"                       => "sql",
    "SquidConf"                 => "squidconf",
    "TeX"                       => "tex",
    "Text only"                 => "text",
    "MoinMoin/Trac Wiki markup" => "trac-wiki",
    "VB.net"                    => "vb.net",
    "VimL"                      => "vim",
    "XML"                       => "xml",
    "XML+Django/Jinja"          => "xml+django",
    "XML+Ruby"                  => "xml+erb",
    "XML+Mako"                  => "xml+mako",
    "XML+Myghty"                => "xml+myghty",
    "XML+PHP"                   => "xml+php",
    "XML+Smarty"                => "xml+smarty",
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

