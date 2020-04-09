digit --> [X], {number(X)} .
alphaNumeric --> [X],{atom(X), X \= true, X \= false}.
identifier --> alphaNumeric .
endLine --> [;].
endPeriod --> [.].
equal --> [=].
var --> [var].
begin --> [begin].
end --> [end].


program --> block,endPeriod.
block --> begin, declrList,commandList,end.
/*
* Declaration Parsing
*/
declrList --> declR, endLine,declrList.
declrList --> declR, endLine.
declR --> var, identifier,equal,digit.
declR --> var, identifier,equal,["'"],alphaNumeric,["'"].
declR --> var, identifier,equal,booleanI.
declR --> var, identifierList.
identifierList --> identifier.
identifierList --> identifier,[','], identifierList.

/*
* Commands Parsing
*/
commandList --> commandI,endLine,commandList.
commandList --> commandI,endLine.
commandI --> display.
commandI --> commandInitialize.
commandI --> ifEval.
commandI --> forEval.
commandI --> whileEval.
commandI --> identifier ,[:,=], ternaryEval.

commandInitialize --> identifier,[:,=],expr.
commandInitialize --> identifier,[+,+].
commandInitialize --> identifier,[-,-].


ifEval -->[if],['('],booleanComb,[')'],[then],commandList, [else], commandList, [endif].
ifEval -->[if],['('],booleanComb,[')'],[then],commandList, [endif].
ternaryEval --> booleanComb,[?],expr,[:],expr.
forEval --> [for],['('],commandInitialize,endLine,booleanComb,endLine,commandInitialize,[')'],[do],commandList,[endfor].
forEval --> [for],identifier,[in],[range],['('],digit, [to],digit,[')'].
whileEval --> [while],['('],booleanComb,[')'],[do],commandList,[endwhile].

/*
* Boolean Parsing
*/
booleanComb --> booleanI.
booleanComb --> boolean.
booleanI --> [true].
booleanI --> [false].
boolean --> [!],booleanComb.
boolean --> expr,equal,equal,expr.
boolean --> expr,[!],equal,expr.
boolean --> expr,conditional,expr.


conditional --> [>].
conditional --> [<].
conditional --> [>,=].
conditional --> [<,=].
conditional --> [and].
conditional --> [or].
:-table expr/2, term/2 .
/*
* Expression Parsing
*/
expr --> expr, [-], term.
expr --> expr, [+], term.
expr --> term .

term --> term, [*], factor.
term --> term, [/], factor.
term --> factor.

factor --> ['('],expr,[')'].
factor --> digit.
factor --> identifier.
factor --> booleanI.
factor --> alphaNumeric.

display --> [display],['('],expr,[')'].

