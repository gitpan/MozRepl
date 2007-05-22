package MozRepl::Plugin::JSON;

use strict;
use warnings;

use base qw(MozRepl::Plugin::Base);

use Carp::Clan qw(croak);

=head1 NAME

MozRepl::Plugin::JSON - To JSON string plugin.

=head1 VERSION

version 0.03

=cut

our $VERSION = '0.03';

=head1 SYNOPSYS

    use MozRepl;
    use MozRepl::Util;

    my $repl = MozRepl->new;
    $repl->setup({ plugins => { plugins => [qw/JSON/] } });
    print $repl->json({ source => MozRepl::Util->javascript_value({foo => 1, bar => 2}) });

=head1 DESCRIPTION

Add json() method to L<MozRepl>.

=head1 METHODS

=head2 setup($ctx, $args)

Load script at http://json.org/json.js
So extending build in object.

    Array.prototype.toJSONString()
    Boolean.prototype.toJSONString()
    Data.prototype.toJSONString()
    Number.prototype.toJSONString()
    Object.prototype.toJSONString()
    String.prototype.toJSONString()
    String.prototype.parseJSON(filter)

=cut

sub setup {
    my ($self, $ctx, $args) = @_;

    $ctx->execute($self->process('setup', { repl => $ctx->repl }));
}

=head2 execute($ctx, $args)

=over 4

=item $ctx

Context object. See L<MozRepl>.

=item $args

Hash reference.

=over 4

=item source

Source string. If you want to JavaScript literal, then use MozRepl::Util->javascript_value() method.
See L<MozRepl::Util/javascript_value($value)>.

=back

=back

=cut

sub execute {
    my ($self, $ctx, $args) = @_;

    # croak("Temporary json not support on this OS : " . $^O) if ($^O eq "cygwin");

    my $cmd = $self->process('execute', { repl => $ctx->repl, source => $args->{source} });
    my @result = $ctx->execute($cmd);

    if ($result[$#result - 1] =~ /\!{3} InternalError: /) { ### recursive error
        $ctx->log->debug($result[$#result - 1]);

        croak($result[$#result - 1]);
    }

    return join("\n", @result);
}

=head1 SEE ALSO

=over 4

=item L<MozRepl::Plugin::Base>

=item L<MozRepl::Util>

=item L<Data::JavaScript::Anon>

=item http://json.org/json.js

=back

=head1 AUTHOR

Toru Yamaguchi, C<< <zigorou@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-mozrepl-plugin-json@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2007 Toru Yamaguchi, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of MozRepl::Plugin::JSON

__DATA__
__setup__
if(!Object.prototype.toJSONString){Array.prototype.toJSONString=function(){var a=['['],b,i,l=this.length,v;function
p(s){if(b){a.push(',');}
a.push(s);b=true;}
for(i=0;i<l;i+=1){v=this[i];switch(typeof v){case'object':if(v){if(typeof v.toJSONString==='function'){p(v.toJSONString());}}else{p("null");}
break;case'string':case'number':case'boolean':p(v.toJSONString());}}
a.push(']');return a.join('');};Boolean.prototype.toJSONString=function(){return String(this);};Date.prototype.toJSONString=function(){function f(n){return n<10?'0'+n:n;}
return'"'+this.getFullYear()+'-'+
f(this.getMonth()+1)+'-'+
f(this.getDate())+'T'+
f(this.getHours())+':'+
f(this.getMinutes())+':'+
f(this.getSeconds())+'"';};Number.prototype.toJSONString=function(){return isFinite(this)?String(this):"null";};Object.prototype.toJSONString=function(){var a=['{'],b,k,v;function p(s){if(b){a.push(',');}
a.push(k.toJSONString(),':',s);b=true;}
for(k in this){if(this.hasOwnProperty(k)){v=this[k];switch(typeof v){case'object':if(v){if(typeof v.toJSONString==='function'){p(v.toJSONString());}}else{p("null");}
break;case'string':case'number':case'boolean':p(v.toJSONString());}}}
a.push('}');return a.join('');};(function(s){var m={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'};s.parseJSON=function(filter){var j;function walk(k,v){var i;if(v&&typeof v==='object'){for(i in v){if(v.hasOwnProperty(i)){v[i]=walk(i,v[i]);}}}
return filter(k,v);}
if(/^("(\\.|[^"\\\n\r])*?"|[,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t])+?$/.test(this)){try{j=eval('('+this+')');}catch(e){throw new SyntaxError("parseJSON");}}else{throw new SyntaxError("parseJSON");}
if(typeof filter==='function'){j=walk('',j);}
return j;};s.toJSONString=function(){if(/["\\\x00-\x1f]/.test(this)){return'"'+this.replace(/([\x00-\x1f\\"])/g,function(a,b){var c=m[b];if(c){return c;}
c=b.charCodeAt();return'\\u00'+
Math.floor(c/16).toString(16)+
(c%16).toString(16);})+'"';}
return'"'+this+'"';};})(String.prototype);}
__execute__
(function(variable) {
  return variable.toJSONString();
})([% source %]);
__END__
