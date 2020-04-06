% using table for expr and term predicates
:-table expr/3, term/3 .
% expression check with precedence - returns parse tree
expr(t_add(X,Y)) --> expr(X), [+], term(Y).
expr(t_sub(X,Y)) --> expr(X), [-], term(Y).
expr(X) --> term(X).
term(t_mul(X,Y)) --> term(X), [*], factor(Y).
term(t_div(X,Y)) --> term(X), [/], factor(Y).
term(X) --> factor(X).
factor(X) --> ['('], expr(X), [')'].
factor(X) --> number(X).
factor(X) --> identifier(X).
identifier(x) --> [x].
identifier(y) --> [y].
identifier(z) --> [z].
identifier(u) --> [u].
identifier(v) --> [v].
number(X) -->[X], { number(X) }.
% evaluation of expression with environment values - returns output of the calculation
eval_expr(X,_,X):- number(X).
eval_expr(X,Env,Result):- lookup(X,Env,Result).
eval_expr(t_add(X,Y),Env,Val):- eval_expr(X,Env,Val1), eval_expr(Y,Env,Val2), Val is Val1 + Val2.
eval_expr(t_sub(X,Y),Env,Val):- eval_expr(X,Env,Val1), eval_expr(Y,Env,Val2), Val is Val1 - Val2.
eval_expr(t_mul(X,Y),Env,Val):- eval_expr(X,Env,Val1), eval_expr(Y,Env,Val2), Val is Val1 * Val2.
eval_expr(t_div(X,Y),Env,Val):- eval_expr(X,Env,Val1), eval_expr(Y,Env,Val2), Val is Val1 / Val2.
% lookup predicate returns value to identifiers
lookup(Identifier,[(Identifier,Value)|_],Value).
lookup(Identifier,[_|Tail],Value):- lookup(Identifier,Tail,Value).