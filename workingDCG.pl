digit --> [X], {number(X)} .
alphaNumeric --> [X],{atom(X), X \= true, X \= false}.
identifier --> alphaNumeric .
endLine --> [;].
endPeriod --> [.].
const --> [const].
equal --> [=].
var --> [var].
begin --> [begin].
end --> [end].


program --> block,endPeriod.
block --> begin, declrL,endLine,command,end.
/*
* Declaration Parsing
*/
declrL --> declR, endLine,declrL.
declrL --> declR.
declR --> const, identifier,equal,digit.
declR --> const, identifier,equal,alphaNumeric.
declR --> const, identifier,equal,booleanI.
declR --> var, identifier.

/*
* Commands Parsing
*/
command --> commandI, endLine,command.
command --> commandI.
commandI --> identifier,[:=],expr.
commandI --> ifEval.
commandI --> forEval.
commandI --> [while],['('],boolean,[')'],[do],command,[endwhile].
commandI --> [while],['('],booleanI,[')'],[do],command,[endwhile].
commandI --> block.

ifEval -->[if],boolean,[then],command, [else], command, [endif].
ifEval -->[if],booleanI,[then],command, [else], command, [endif].
ifEval --> boolean,[?],expr,[:],expr,endLine.
ifEval --> booleanI,[?],expr,[:],expr,endLine.
forEval --> ['('],expr,endLine,boolean,endLine,expr,endLine,[')'].
forEval --> ['('],expr,endLine,booleanI,endLine,expr,endLine,[')'].

/*
* Boolean Parsing
*/
booleanI --> [true].
booleanI --> [false].
boolean --> [not],boolean.
boolean --> [not],booleanI.
boolean --> expr,equal,equal,expr.
boolean --> expr,conditional,expr.


conditional --> [>].
conditional --> [<].
conditional --> [>=].
conditional --> [<=].

:-table expr/2, term1/2, term2/2, term3/2 .
/*
* Expression Parsing
*/
expr --> expr, [-], term1.
expr --> term1.
term1 --> term1, [+], term2.
term1 --> term2.
term2 --> term2, [*], term3.
term2 --> term3.
term3 --> term3, [/], term4.
term3 --> term4.
term4 --> ['('],expr,[')'].
term4 --> digit.
term4 --> identifier.
term4 --> booleanI.
term4 --> alphaNumeric.


