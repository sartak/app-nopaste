use strict;
use warnings;
use Test::More;

my @content = (
    <<FORM,
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>pasting to magnet_web</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body>
    <table>
      <tr>
      <td>
       <img src="http://paste.scsys.co.uk/static/nopaste.gif" alt="POE Paste with lovely alien head...">
        </td>
        <td align="left">
         <h1><font face="courier new">No paste!</font></h1>
         <font face="courier new" size="-1">
          1. Select the channel for the URL announcment.<br>
          2. Supply a nick for the announcement.<br>
          3. Supply an summary of the paste for the announcement<br>
          4. <b>Paste!</b><br>
          5. Submit the form with the Paste it! button.<br>
        </font>
       </td>
      </tr>
     </table>
    <form method='post' action='http://paste.scsys.co.uk/paste' enctype='application/x-www-from-urlencoded' name="pasteForm">
     <font face="courier new" size="-1"><br><br>
      1. channel: <select name='channel'><option value="" selected>(none)</option> <option value="#angerwhale">#angerwhale</option> <option value="#axkit-dahut">#axkit-dahut</option> <option value="#catalyst">#catalyst</option> <option value="#catalyst-dev">#catalyst-dev</option> <option value="#cometd">#cometd</option> <option value="#dbix-class">#dbix-class</option> <option value="#distzilla">#distzilla</option> <option value="#formhandler">#formhandler</option> <option value="#handel">#handel</option> <option value="#iusethis">#iusethis</option> <option value="#killtrac">#killtrac</option> <option value="#london.pm">#london.pm</option> <option value="#miltonkeynes.pm">#miltonkeynes.pm</option> <option value="#moose">#moose</option> <option value="#p5p">#p5p</option> <option value="#padre">#padre</option> <option value="#pdl">#pdl</option> <option value="#perl">#perl</option> <option value="#perl-help">#perl-help</option> <option value="#perlde">#perlde</option> <option value="#pita">#pita</option> <option value="#poe">#poe</option> <option value="#reaction">#reaction</option> <option value="#rt">#rt</option> <option value="#soap-lite">#soap-lite</option> <option value="#spb.pm">#spb.pm</option> <option value="#tt">#tt</option> <option value="#web-simple">#web-simple</option></select>&nbsp; &nbsp;
      2. your nick: <input type='text' name='nick' size='25' maxlength='25'><br><br>
      3. summary: <input type='text' name='summary' size='80' maxlength='160'><br><br>
      4. paste: <textarea name='paste' rows=25 cols=75 style='width:100%'></textarea><br><br>
      5. <input type='submit' name='Paste it' value='Paste it'><input type='reset' name='Clear form' value='Clear form'>
     </font>
    </form><br>
    <div align="right">
     <a href="http://validator.w3.org/check/referer"><img border="0" src="http://www.w3.org/Icons/valid-html401" alt="Valid HTML 4.01!" height="31" width="88"></a><br><br>
    </div>
    <div>
     <div align=right><font size='-1'><a href='http://sf.net/projects/pastebot/'>Pastebot</a> is powered by <a href='http://poe.perl.org/'>POE</a>.</font></div>
    </div>
    <!-- Automatically put the clipboard contents into the paste field and select it. -->
    <script language="jscript" type="">
      onload=function () {
        try {
          document.pasteForm.paste.value=clipboardData.getData("Text") || "";
          document.pasteForm.paste.select();
        }
        catch (oErr) {}
      }
    </script>
  </body>
</html>
FORM
    <<RETURN,
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
 <head>
  <title>Your paste, number 211360...</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="refresh" content="5;url=http://paste.scsys.co.uk/211360">
 </head>
 <body>

  <p>
   This content is stored as
   <a href='http://paste.scsys.co.uk/211360'>http://paste.scsys.co.uk/211360</a>. You will be redirected
   shortly.
  </p>
  <p>
   From: Someone at 217.168.150.38
   <br>
   Summary: ‘test’
  </p>
  <p>
   <pre>‘test’</pre>
  </p>
  <p>
   <div align=right><font size='-1'><a href='http://sf.net/projects/pastebot/'>Pastebot</a> is powered by <a href='http://poe.perl.org/'>POE</a>.</font></div>
  </p>
 </body>
</html>
RETURN
);

my @requests;
{
    package LWP::Protocol::test;
    use base 'LWP::Protocol';
    sub request {
        my $self = shift;
        my ($req) = @_;
        push @requests, $req;
        return HTTP::Response->new(200, 'OK', [], shift @content);
    }
}
LWP::Protocol::implementor('http' => 'LWP::Protocol::test');

{
    package App::Nopaste::Service::MyTest;
    use base 'App::Nopaste::Service';

    sub uri { 'http://localhost/' }
}

{
    package MyTest::Cmd;
    use base 'App::Nopaste::Command';

    sub read_text { '‘test’' }
}

my $input = {
    nick       => '',
    services   => ['App::Nopaste::Service::MyTest'],
    extra_argv => []
};

my $cmd = MyTest::Cmd->new($input);
isa_ok($cmd,'App::Nopaste::Command');

my $ret = $cmd->run;
is($ret, 'http://paste.scsys.co.uk/211360');
my ($post) = grep { $_->method eq 'POST' } @requests;
is($post->content, 'channel=&nick=&summary=&paste=%E2%80%98test%E2%80%99&private=0');

done_testing;
