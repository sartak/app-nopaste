package App::Nopaste::Service::Pastie;
use strict;
use warnings;
use base 'App::Nopaste::Service';

my %languages = (
    "bash" => "13",
    "c#" => "20",
    "c/c++" => "7",
    "css" => "8",
    "diff" => "5",
    "go" => "21",
    "html (erb / rails)" => "12",
    "html / xml" => "11",
    "java" => "9",
    "javascript" => "10",
    "objective-c/c++" => "1",
    "perl" => "18",
    "php" => "15",
    "plain text" => "6",
    "python" => "16",
    "ruby" => "3",
    "ruby on rails" => "4",
    "sql" => "14",
    # hidden
    "apache" => "22",
    "clojure" => "38",
    "d" => "26",
    "erlang" => "27",
    "fortran" => "28",
    "haskell" => "29",
    "ini" => "35",
    "io" => "24",
    "lisp" => "25",
    "lua" => "23",
    "makefile" => "31",
    "nu" => "36",
    "pascal" => "17",
    "puppet" => "39",
    "scala" => "32",
    "scheme" => "33",
    "smarty" => "34",
    "tex" => "37",
    # aliases
    "sh" => "13",
    "c" => "7",
    "c++" => "7",
    "objective-C" => "1",
    "objective-C++" => "1",
    "plain" => "6",
    "raw" => "6",
    "rails" => "4",
    "html" => "11",
    "xml" => "11",
    "js" => "10",
    "make" => "31",
);

sub uri { 'http://pastie.org/' }

sub fill_form {
    my $self = shift;
    my $mech = shift;
    my %args = @_;

    my $lang_id = $languages{"plain text"};
    $lang_id = $languages{lc($args{lang})}
        if (exists $args{lang} && exists $languages{lc($args{lang})});

    $mech->submit_form(
        fields => {
            "paste[body]"          => $args{text},
            "paste[authorization]" => 'burger', # set with JS to avoid bots
            "paste[restricted]"    => $args{private},
            "paste[parser_id]"     => $lang_id,
        },
    );
}

sub return {
    my $self = shift;
    my $mech = shift;

    my $prefix ='';
    my ($id) = $mech->title =~ /\#(\d+)/;
    if (!$id) {
        ($id) = $mech->content =~ m{http://pastie.org/\d+/wrap\?key=([a-z0-9]+)};
        $prefix = 'private/';
    }
    return (0, "Could not construct paste link.") if !$id;
    return (1, "http://pastie.org/$prefix$id");
}

1;

__END__

=head1 NAME

App::Nopaste::Service::Pastie - http://pastie.org

=cut

