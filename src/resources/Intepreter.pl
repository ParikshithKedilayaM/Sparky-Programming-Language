%:- use_rendering(svgtree).
endLine --> [;].
endPeriod --> [.].
equal --> [=].
var --> [var].
begin --> [begin].
end --> [end].

digit(X) --> [X], {number(X)} .
identifier(X) --> [X],{atom(X), X \= true, X \= false}.
anystring(X) --> [X],{atom(X)}.

program(t_program(X)) --> block(X),endPeriod.
block(t_block(X,Y)) --> begin, declrList(X),commandList(Y),end.
/*
* Declaration Parsing
*/
declrList(t_declrList(X,Y)) --> declR(X), endLine,declrList(Y).
declrList(t_declrList(X)) --> declR(X), endLine.
declR(t_assign(X,Y)) --> var, identifier(X),[:,=],digit(Y).
declR(t_assign(X,Y)) --> var, identifier(X),[:,=],['"'],anystring(Z),{atom_string(Z,Y)},['"'].
declR(t_assign(X,Y)) --> var, identifier(X),[:,=],booleanI(Y).
declR(t_assign_id(X,Y)) --> var, identifier(X),[:,=],identifier(Y).
declR(X) --> var, identifierList(X).
identifierList(t_identifierList(X,Y)) --> identifier(X),[','], identifierList(Y).
identifierList(t_id(X)) --> identifier(X).


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
commandInitialize(t_commandInitialize(X,Y)) --> identifier(X),[:,=],['"'],anystring(Z),{atom_string(Z,Y)},['"'].
commandInitialize(t_commandInitialize(X,+,+)) --> identifier(X),[+,+].
commandInitialize(t_commandInitialize(X,-,-)) --> identifier(X),[-,-].


ifEval(t_ifteEval(X,Y,Z)) -->[if],['('],booleanComb(X),[')'],[then],commandList(Y), [else],
    						commandList(Z), [endif].
ifEval(t_ifEval(X,Y)) -->[if],['('],booleanComb(X),[')'],[then],commandList(Y), [endif].

ternaryEval(t_ternary(W,X,Y,Z)) --> identifier(W) ,[:,=], booleanComb(X),[?],expr(Y),[:],expr(Z).
forEval(t_traditionalforEval(X,Y,Z,T)) --> [for],['('],commandInitialize(X),endLine,booleanComb(Y),
   								 endLine,commandInitialize(Z),[')'],[do],commandList(T),
    							[endfor].
forEval(t_advancedforEval(X,Y,Z,T)) --> [for],identifier(X),[in],[range],['('],digit(Y), [to],digit(Z),[')'], [do],commandList(T),
    							[endfor].
whileEval(t_whileEval(X,Y)) --> [while],['('],booleanComb(X),[')'],[do],commandList(Y),[endwhile].

/*
* Boolean Parsing
*/
booleanComb(X) --> booleanI(X).
booleanComb(X) --> boolean(X).
booleanI(true) --> [true].
booleanI(false) --> [false].
boolean(t_booleanNegate(X)) --> [!],booleanComb(X).
boolean(t_booleanExprEquals(X,Y)) --> expr(X),equal,equal,expr(Y).
boolean(t_booleanExprNotEquals(X,Y)) --> expr(X),[!],equal,expr(Y).
boolean(t_booleanExprCond(X,Y,Z)) --> expr(X),conditional(Y),expr(Z).


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
factor(t_boolean(X)) --> booleanI(X).
factor(t_string(X)) -->['"'], anystring(X),['"'].


display(t_display(X)) --> [display],['('],expr(X),[')'].





eval_program(t_program(X),FinalEnv) :- eval_block(X,[],FinalEnv).
eval_block(t_block(X,Y), EnvIn, EnvOut) :- eval_declrList(X,EnvIn, Env1), eval_commandList(Y, Env1, EnvOut).
eval_declrList(t_declrList(X,Y),EnvIn, EnvOut) :- eval_declR(X,EnvIn, Env1), eval_declrList(Y, Env1, EnvOut).
eval_declrList(t_declrList(X),EnvIn, EnvOut):- eval_declR(X,EnvIn, EnvOut).

eval_declR(t_assign(X,Y), EnvIn, EnvOut) :- update(X,Y, EnvIn, EnvOut).
eval_declR(t_identifierList(X,Y), EnvIn, EnvOut) :- update(X,0,EnvIn,Env1), eval_declR(Y,Env1,EnvOut).
eval_declR(t_id(X), EnvIn, EnvOut) :- update(X,0,EnvIn,EnvOut).


eval_commandList(t_commandList(X,Y),EnvIn, EnvOut) :- eval_commandI(X,EnvIn, Env1), eval_commandList(Y, Env1, EnvOut).
eval_commandList(t_commandList(X),EnvIn, EnvOut) :- eval_commandI(X,EnvIn, EnvOut).
eval_commandI(t_commandInitialize(X,Y),EnvIn,EnvOut) :- eval_expr(Y, EnvIn, Env1, Val) , update(X,Val,Env1, EnvOut).
eval_commandI(t_display(X),EnvIn,EnvIn) :- lookup(X, EnvIn, Val),write(X), write(=), write(Val),nl.

% Evaluation Logic for IF loop and If-then-else-----------------------------------------------------------------------
eval_commandI(t_ifEval(X,Y),EnvIn,EnvOut):- eval_bool(X,EnvIn,EnvOut1,true),
                                             eval_commandList(Y,EnvOut1,EnvOut).
eval_commandI(t_ifteEval(X,Y,_Z),EnvIn,EnvOut):- eval_bool(X,EnvIn,EnvOut1,true),
                                                 eval_commandList(Y,EnvOut1,EnvOut).
eval_commandI(t_ifteEval(X,_Y,Z),EnvIn,EnvOut):- eval_bool(X,EnvIn,EnvOut1,false),
                                                 eval_commandList(Z,EnvOut1,EnvOut).
%----------------------------------------------------------------------------------------------------------------------




% Evaluation Logic for WHILE Loop--------------------------------------------------------------------------------------
eval_commandI(t_whileEval(B,C),EnvIn,EnvOut):-eval_bool(B,EnvIn,EnvIn,true),
                                           eval_commandList(C,EnvIn,Env2),
                                           eval_commandI(t_whileEval(B,C),Env2,EnvOut).
eval_commandI(t_whileEval(B,_C),Env,Env):-eval_bool(B,Env,Env,false).

%----------------------------------------------------------------------------------------------------------------------

% Evaluation Logic for FOR Loop---------------------------------------------------------------------------

eval_commandI(t_traditionalforEval(X,Y,Z,T),EnvIn,EnvOut) :- eval_commandI(X,EnvIn, EnvOut1), eval_for(Y,Z,T, EnvOut1, EnvOut).
eval_commandI(t_advancedforEval(X,Y,Z,T),EnvIn,EnvOut) :- Y < Z,update(X,Y,EnvIn, EnvOut1),  eval_advforinc(X,Z,T, EnvOut1, EnvOut).

eval_commandI(t_advancedforEval(X,Y,Z,T),EnvIn,EnvOut) :- Y > Z,update(X,Y,EnvIn, EnvOut1),  eval_advfordec(X,Z,T, EnvOut1, EnvOut).



eval_for(Y,Z,T,EnvIn,EnvOut):-				 eval_bool(Y,EnvIn,EnvOut2,true),     
    										 eval_commandI(Z,EnvOut2,EnvOut3),   
    									     eval_commandList(T,EnvOut3, EnvOut4),  
    										 eval_for(Y,Z,T,EnvOut4,EnvOut).
    										


eval_for(Y,_,_,EnvIn,EnvOut):-				 eval_bool(Y,EnvIn,EnvOut,false). 

% for (i in range(0,10);

% Evaluation for Advanced FOR loop -----------------------------------------------------------------------------------
% forEval(t_forEval(X,Y,Z,C)) --> [for],identifier(X),[in],[range],['('],digit(Y), [to],digit(Z),[')'].


eval_advforinc(X,Z,T,EnvIn,EnvOut):-             eval_bool(t_booleanExprCond(X,<,Z),EnvIn,EnvOut2,true), 
    										  eval_commandList(T,EnvOut2,EnvOut3),
    										  lookup(X,EnvOut3,Val), Val1 is Val + 1,
    										  update(X,Val1,EnvOut3,EnvOut4),
    										  eval_advforinc(X,Z,T,EnvOut4,EnvOut).
    											
eval_advforinc(X,Z,_,EnvIn,EnvOut):-             eval_bool(t_booleanExprCond(X,<,Z),EnvIn,EnvOut,false).


eval_advfordec(X,Z,T,EnvIn,EnvOut):-             eval_bool(t_booleanExprCond(X,>,Z),EnvIn,EnvOut2,true), 
    										  eval_commandList(T,EnvOut2,EnvOut3),
    										  lookup(X,EnvOut3,Val), Val1 is Val - 1,
    										  update(X,Val1,EnvOut3,EnvOut4),
    										  eval_advfordec(X,Z,T,EnvOut4,EnvOut).


eval_advfordec(X,Z,_,EnvIn,EnvOut):-             eval_bool(t_booleanExprCond(X,>,Z),EnvIn,EnvOut,false).








% Boolean Evaluation Logic---------------------------------------------------------------------------------------------
not(true,false).
not(false,true).

equal(Val1,Val2,true):-Val1=Val2.
equal(Val1,Val2,false):- Val1\=Val2.

greaterThan(Val1,Val2,true) :- Val1 > Val2.
greaterThan(Val1,Val2,false) :- Val1 =< Val2.

lessThan(Val1,Val2,true) :- Val1 < Val2.
lessThan(Val1,Val2,false) :- Val1 >= Val2.


greaterThanorEqual(Val1,Val2,true) :- Val1 >= Val2.
greaterThanorEqual(Val1,Val2,false) :- Val1 < Val2.

lessThanorEqual(Val1,Val2,true) :- Val1 =< Val2.
lessThanorEqual(Val1,Val2,false) :- Val1 > Val2.





eval_bool(true,Env,Env,true).
eval_bool(false,Env,Env,false).


eval_bool(t_booleanNegate(B),EnvIn,EnvOut,Val):-eval_bool(B,EnvIn,EnvOut,Val1),
                                                not(Val1,Val).
eval_bool(t_booleanExprEquals(E1,E2),Env,NewEnv,Val):-eval_expr(E1,Env,Env1,Val1),
                                                      eval_expr(E2,Env1,NewEnv,Val2),
                                                      equal(Val1,Val2,Val).
eval_bool(t_booleanExprNotEquals(E1,E2),Env,NewEnv,Val):-eval_expr(E1,Env,Env1,Val1),
                                                         eval_expr(E2,Env1,NewEnv,Val2),
                                                         equal(Val1,Val2,Val3),
                                                         not(Val3,Val).

eval_bool(t_booleanExprCond(E1,<,E2),Env,NewEnv,Val):-eval_expr(E1,Env,Env1,Val1),
                                                         eval_expr(E2,Env1,NewEnv,Val2),
                                                         lessThan(Val1,Val2,Val).

eval_bool(t_booleanExprCond(E1,>,E2),Env,NewEnv,Val):-eval_expr(E1,Env,Env1,Val1),
                                                         eval_expr(E2,Env1,NewEnv,Val2),
                                                         greaterThan(Val1,Val2,Val).

eval_bool(t_booleanExprCond(E1,=<,E2),Env,NewEnv,Val):-eval_expr(E1,Env,Env1,Val1),
                                                         eval_expr(E2,Env1,NewEnv,Val2),
                                                         lessThanorEqual(Val1,Val2,Val).

eval_bool(t_booleanExprCond(E1,<=,E2),Env,NewEnv,Val):-eval_expr(E1,Env,Env1,Val1),
                                                         eval_expr(E2,Env1,NewEnv,Val2),
                                                         lessThanorEqual(Val1,Val2,Val).


eval_bool(t_booleanExprCond(E1,=>,E2),Env,NewEnv,Val):-eval_expr(E1,Env,Env1,Val1),
                                                         eval_expr(E2,Env1,NewEnv,Val2),
                                                         greaterThanorEqual(Val1,Val2,Val).

eval_bool(t_booleanExprCond(E1,>=,E2),Env,NewEnv,Val):-eval_expr(E1,Env,Env1,Val1),
                                                         eval_expr(E2,Env1,NewEnv,Val2),
                                                         greaterThanorEqual(Val1,Val2,Val).
%----------------------------------------------------------------------------------------------------------------------

%Evaluate expression when t_add tree node is encountered
eval_expr(t_add(X,Y),EnvIn, EnvOut, Val) :- eval_expr(X,EnvIn,EnvOut1,Val1), 
    										eval_expr(Y,EnvOut1,EnvOut,Val2), 
    										Val is Val1 + Val2.


%To be validated again

eval_expr(t_add(t_string(X),t_string(Y)),Env, Env, Val) :- concat(X,Y,Val).

%Evaluate expression when t_sub tree node is encountered
eval_expr(t_sub(X,Y),EnvIn, EnvOut, Val) :- eval_expr(X,EnvIn,EnvOut1,Val1), 
    										eval_expr(Y,EnvOut1,EnvOut,Val2), 
    										Val is Val1 - Val2.

%Evaluate expression when t_mul tree node is encountered
eval_expr(t_mul(X,Y),EnvIn,EnvOut, Val) :- eval_expr(X,EnvIn,EnvOut1,Val1), 
    										eval_expr(Y,EnvOut1,EnvOut,Val2), 
    										Val is Val1 * Val2.

%Evaluate expression when t_div tree node is encountered
eval_expr(t_div(X,Y),EnvIn,EnvOut, Val) :- eval_expr(X,EnvIn,EnvOut1,Val1), 
    										eval_expr(Y,EnvOut1,EnvOut,Val2), 
    										Val is Val1 / Val2.

%Evaluate expression when t_add tree node is encountered
eval_expr(X,Env,Env,X) :- number(X).

%Evaluate expression when t_add tree node is encountered
eval_expr(X,EnvIn,EnvOut,Result) :- eval_id(X,EnvIn,EnvOut,Result).
eval_expr(t_id_expr_equality(X,Y),EnvIn,EnvOut,Result):-eval_expr(Y,EnvIn,EnvOut1,Result), update(X,Result,EnvOut1,EnvOut).
eval_id(X,EnvIn,EnvIn,Result):- lookup(X,EnvIn,Result).


lookup(Id,[(Id,Val)|_],Val).
lookup(Id,[_|T],Val):- lookup(Id,T,Val).

update(Id,Val,[],[(Id,Val)]).
update(Id,Val,[(Id,_)|T],[(Id,Val)|T]).
update(Id,Val,[H|T],[H|R]):-H \=(Id,_),update(Id,Val,T,R).

