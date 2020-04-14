:- set_prolog_flag(double_quotes, string).
%:- use_rendering(svgtree).
endLine --> [;].
endPeriod --> [.].
equal --> [=].
var --> [var].
begin --> [begin].
end --> [end].

digit(X) --> [X], {number(X)} .
identifier(X) --> [X],{atom(X), X \= true, X \= false}.
anystring(X) --> [X],{string(X)}.

program(t_program(X)) --> block(X),endPeriod.
block(t_block(X,Y)) --> begin, declrList(X),commandList(Y),end.
/*
* Declaration Parsing
*/
declrList(t_declrList(X,Y)) --> declR(X), endLine,declrList(Y).
declrList(t_declrList(X)) --> declR(X), endLine.
declR(t_assign(X,Y)) --> var, identifier(X),[:,=],digit(Y).
declR(t_assign(X,Y)) --> var, identifier(X),[:,=],anystring(Y).
declR(t_assign(X,Y)) --> var, identifier(X),[:,=],booleanI(Y).
declR(X) --> var, identifierList(X).
identifierList(t_identifierList(X,Y)) --> identifier(X),[','], identifierList(Y).
identifierList(X) --> identifier(X).


/*
* Commands Parsing
*/
commandList(t_commandList(X,Y)) --> commandI(X),endLine,commandList(Y).
commandList(t_commandList(X)) --> commandI(X),endLine.
commandI(X) --> display(X).
commandI(X) --> commandInitialize(X).
commandI(X) --> ifEval(X).
commandI(X) --> forEval(X).
commandI(X) --> whileEval(X).
commandI(X) --> ternaryEval(X).
commandI(X) --> block(X).

commandInitialize(t_commandInitialize(X,Y)) --> identifier(X),[:,=],expr(Y).
commandInitialize(t_commandInitialize(X,+,+)) --> identifier(X),[+,+].
commandInitialize(t_commandInitialize(X,-,-)) --> identifier(X),[-,-].


ifEval(t_ifEval(X,Y,Z)) -->[if],['('],booleanComb(X),[')'],[then],commandList(Y), [else],
    						commandList(Z), [endif].
ifEval(t_ifEval(X,Y)) -->[if],['('],booleanComb(X),[')'],[then],commandList(Y), [endif].

ternaryEval(t_ternary(W,X,Y,Z)) --> identifier(W) ,[:,=], booleanComb(X),[?],expr(Y),[:],expr(Z).
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

factor(t_bracket(X)) --> ['('],expr(X),[')'].
factor(t_numeric(X)) --> digit(X).
factor(X) --> identifier(X).
factor(t_boolean(X)) --> booleanI(X).
factor(t_string(X)) --> anystring(X).

display(t_display(X)) --> [display],['('],expr(X),[')'].





eval_program(t_program(X),FinalEnv) :- eval_block(X,[],FinalEnv).
eval_block(t_block(X,Y), EnvIn, EnvOut) :- eval_declrList(X,EnvIn, Env1), eval_commandList(Y, Env1, EnvOut).
eval_declrList(t_declrList(X,Y),EnvIn, EnvOut) :- eval_declR(X,EnvIn, Env1), eval_declrList(Y, Env1, EnvOut).
eval_declrList(t_declrList(X),EnvIn, EnvOut):- eval_declR(X,EnvIn, EnvOut).

eval_declR(t_assign(X,Y), EnvIn, EnvOut) :- update(X,Y, EnvIn, EnvOut).
eval_declR(t_identifierList(X,Y), EnvIn, EnvOut) :- update(X,0,EnvIn,Env1), eval_declR(Y,Env1,EnvOut).
eval_declR(X, EnvIn, EnvOut) :- update(X,0,EnvIn,EnvOut).


eval_commandList(t_commandList(X,Y),EnvIn, EnvOut) :- eval_commandI(X,EnvIn, Env1), eval_commandList(Y, Env1, EnvOut).
eval_commandList(t_commandList(X),EnvIn, EnvOut) :- eval_commandI(X,EnvIn, EnvOut).
eval_commandI(t_display(X),EnvIn, _) :- lookup(X, EnvIn, Val),nl,write(X), write(=), write(Val).


lookup(Id,[(Id,Val)|_],Val).
lookup(Id,[_|T],Val):- lookup(Id,T,Val).

update(Id,Val,[],[(Id,Val)]).
update(Id,Val,[(Id,_)|T],[(Id,Val)|T]).
update(Id,Val,[H|T],[H|R]):-H \=(Id,_),update(Id,Val,T,R).

