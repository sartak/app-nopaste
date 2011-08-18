package App::Nopaste::Service::Debian;
use strict;
use warnings;
use base 'App::Nopaste::Service';

my $languages = {
    "text" => "-1",
    "abap" => "823",
    "antlr" => "849",
    "antlr-as" => "800",
    "antlr-cpp" => "893",
    "antlr-csharp" => "879",
    "antlr-java" => "837",
    "antlr-objc" => "838",
    "antlr-perl" => "862",
    "antlr-python" => "842",
    "antlr-ruby" => "900",
    "apacheconf" => "760",
    "applescript" => "883",
    "as" => "807",
    "as3" => "889",
    "aspx-cs" => "858",
    "aspx-vb" => "857",
    "basemake" => "841",
    "bash" => "749",
    "bat" => "847",
    "bbcode" => "813",
    "befunge" => "820",
    "boo" => "805",
    "brainfuck" => "745",
    "c" => "788",
    "cheetah" => "880",
    "clojure" => "860",
    "c-objdump" => "821",
    "common-lisp" => "887",
    "console" => "871",
    "control" => "818",
    "cpp" => "781",
    "cpp-objdump" => "872",
    "csharp" => "875",
    "css" => "772",
    "css+django" => "796",
    "css+erb" => "776",
    "css+genshitext" => "753",
    "css+mako" => "829",
    "css+myghty" => "754",
    "css+php" => "751",
    "css+smarty" => "877",
    "cython" => "853",
    "d" => "810",
    "delphi" => "743",
    "diff" => "826",
    "django" => "759",
    "d-objdump" => "774",
    "dpatch" => "768",
    "dylan" => "785",
    "erb" => "812",
    "erl" => "856",
    "erlang" => "855",
    "evoque" => "783",
    "fortran" => "777",
    "gas" => "846",
    "genshi" => "790",
    "genshitext" => "844",
    "glsl" => "843",
    "gnuplot" => "778",
    "groff" => "859",
    "haskell" => "834",
    "html" => "789",
    "html+cheetah" => "746",
    "html+django" => "750",
    "html+evoque" => "747",
    "html+genshi" => "865",
    "html+mako" => "825",
    "html+myghty" => "770",
    "html+php" => "830",
    "html+smarty" => "884",
    "ini" => "868",
    "io" => "832",
    "irc" => "793",
    "java" => "763",
    "js" => "886",
    "js+cheetah" => "824",
    "js+django" => "851",
    "js+erb" => "839",
    "js+genshitext" => "764",
    "js+mako" => "744",
    "js+myghty" => "798",
    "jsp" => "822",
    "js+php" => "894",
    "js+smarty" => "773",
    "lhs" => "890",
    "lighty" => "762",
    "llvm" => "881",
    "logtalk" => "811",
    "lua" => "835",
    "make" => "831",
    "mako" => "792",
    "matlab" => "787",
    "matlabsession" => "827",
    "minid" => "852",
    "modelica" => "861",
    "moocode" => "869",
    "mupad" => "816",
    "mxml" => "898",
    "myghty" => "864",
    "mysql" => "779",
    "nasm" => "899",
    "newspeak" => "870",
    "nginx" => "882",
    "numpy" => "748",
    "objdump" => "828",
    "objective-c" => "885",
    "ocaml" => "806",
    "perl" => "867",
    "php" => "892",
    "pot" => "782",
    "pov" => "836",
    "prolog" => "794",
    "py3tb" => "815",
    "pycon" => "848",
    "pytb" => "891",
    "python" => "795",
    "python3" => "845",
    "ragel" => "755",
    "ragel-c" => "854",
    "ragel-cpp" => "819",
    "ragel-d" => "769",
    "ragel-em" => "888",
    "ragel-java" => "767",
    "ragel-objc" => "896",
    "ragel-ruby" => "863",
    "raw" => "873",
    "rb" => "814",
    "rbcon" => "771",
    "rebol" => "780",
    "redcode" => "758",
    "rhtml" => "766",
    "rst" => "791",
    "scala" => "761",
    "scheme" => "765",
    "smalltalk" => "797",
    "smarty" => "756",
    "sourceslist" => "742",
    "splus" => "803",
    "sql" => "895",
    "sqlite3" => "804",
    "squidconf" => "809",
    "tcl" => "866",
    "tcsh" => "874",
    "tex" => "876",
    "text" => "878",
    "trac-wiki" => "786",
    "vala" => "833",
    "vb.net" => "808",
    "vim" => "752",
    "xml" => "840",
    "xml+cheetah" => "850",
    "xml+django" => "897",
    "xml+erb" => "817",
    "xml+evoque" => "757",
    "xml+mako" => "801",
    "xml+myghty" => "901",
    "xml+php" => "775",
    "xml+smarty" => "784",
    "xslt" => "802",
    "yaml" => "799",
};

sub uri { "http://paste.debian.net/" }

sub fill_form {
    my $self = shift;
    my $mech = shift;
    my %args = @_;
    my $lang = $languages->{$args{lang}} if $args{lang};

    $mech->form_number(1);
    if ($args{private}) {
        $mech->tick('private', '1');
    }
    $mech->submit_form(
        fields        => {
            code => $args{text},
            do { $args{nick} ? (poster => $args{nick}) : () },
            do { $lang ? (lang => $lang) : () },
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

App::Nopaste::Service::Debian - http://paste.debian.net/

=head1 AUTHOR

Ryan Niebur, C<< <ryanryan52@gmail.com> >>

=cut

