digit --> [X], {number(X)} .
alphaNumeric --> [X],{atom(X), X \= true, X \= false}.
identifier --> alphaNumeric .
endLine --> [;].
endPeriod --> [.].
equal --> [=].
var --> [var].
begin --> [begin].
end --> [end].
doubleQuotes -->['"'].

program --> block,endPeriod.
block --> begin, declrList,commandList,end.
/*
* Declaration Parsing
*/
declrList --> declR, endLine,declrList.
declrList --> declR, endLine.
declR --> var, identifier,equal,digit.
declR --> var, identifier,equal,doubleQuotes,alphaNumeric,doubleQuotes.
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





digit(X) --> [X], {number(X)} .
alphaNumeric(X) --> [X],{atom(X), X \= true, X \= false}.
identifier(X) --> alphaNumeric(X) .


program(t_program(X)) --> block(X),endPeriod.
block(t_block(X,Y)) --> begin, declrList(X),commandList(Y),end.
/*
* Declaration Parsing
*/
declrList(t_declr(X,Y)) --> declR(X), endLine,declrList(Y).
declrList(t_declr(X)) --> declR(X), endLine.
declR(t_declr(X,=,Y)) --> var, identifier(X),equal,digit(Y).
declR(t_declr(X,=,Y)) --> var, identifier(X),equal,doubleQuotes,alphaNumeric(Y),doubleQuotes.
declR(t_declr(X,=,Y)) --> var, identifier(X),equal,booleanI(Y).
declR(X) --> var, identifierList(X).
identifierList(t_identifier(X)) --> identifier(X).
identifierList(t_identifier(X,Y)) --> identifier(X),[','], identifierList(Y).

/*
* Commands Parsing
*/
commandList(t_commandList(X,Y)) --> commandI(X),endLine,commandList(Y).
commandList(t_commandList(X)) --> commandI(X),endLine.
commandI(t_command(X)) --> display(X).
commandI(t_command(X)) --> commandInitialize(X).
commandI(t_command(X)) --> ifEval(X).
commandI(t_command(X)) --> forEval(X).
commandI(t_command(X)) --> whileEval(X).
commandI(t_command(X,Y)) --> identifier(X) ,[:,=], ternaryEval(Y).

commandInitialize(t_commandInitialize(X,Y)) --> identifier(X),[:,=],expr(Y).
commandInitialize(t_commandInitialize(X,+,+)) --> identifier(X),[+,+].
commandInitialize(t_commandInitialize(X,-,-)) --> identifier(X),[-,-].


ifEval(t_ifEval(X,Y,Z)) -->[if],['('],booleanComb(X),[')'],[then],commandList(Y), [else],
    						commandList(Z), [endif].
ifEval(t_ifEval(X,Y)) -->[if],['('],booleanComb(X),[')'],[then],commandList(Y), [endif].

ternaryEval(t_ternary(X,Y,Z)) --> booleanComb(X),[?],expr(Y),[:],expr(Z).
forEval(t_forEval(X,Y,Z,T)) --> [for],['('],commandInitialize(X),endLine,booleanComb(Y),
   								 endLine,commandInitialize(Z),[')'],[do],commandList(T),
    							[endfor].
forEval(t_forEval(X,Y,Z)) --> [for],identifier(X),[in],[range],['('],digit(Y), [to],digit(Z),[')'].
whileEval(t_whileEval(X,Y)) --> [while],['('],booleanComb(X),[')'],[do],commandList(Y),[endwhile].

/*
* Boolean Parsing
*/
booleanComb(X) --> booleanI(X).
booleanComb(X) --> boolean(X).
booleanI(true) --> [true].
booleanI(false) --> [false].
boolean(t_boolean(!,X)) --> [!],booleanComb(X).
boolean(t_boolean(X,=,=,Y)) --> expr(X),equal,equal,expr(Y).
boolean(t_boolean(X,!,=,Y)) --> expr(X),[!],equal,expr(Y).
boolean(t_boolean(X,Y,Z)) --> expr(X),conditional(Y),expr(Z).


conditional(>) --> [>].
conditional(<) --> [<].
conditional(>=) --> [>,=].
conditional(<=) --> [<,=].
conditional(and) --> [and].
conditional(or) --> [or].
:-table expr/3, term/3 .
/*
* Expression Parsing
*/
expr(t_sub(X,Y)) --> expr(X), [-], term(Y).
expr(t_add(X,Y)) --> expr(X), [+], term(Y).
expr(X) --> term(X) .

term(t_mul(X,Y)) --> term(X), [*], factor(Y).
term(t_div(X,Y)) --> term(X), [/], factor(Y).
term(X) --> factor(X).

factor(X) --> ['('],expr(X),[')'].
factor(X) --> digit(X).
factor(X) --> identifier(X).
factor(X) --> booleanI(X).
factor(X) --> alphaNumeric(X).

display(X) --> [display],['('],expr(X),[')'].
