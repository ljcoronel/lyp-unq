% symbol(?C)
symbol(a).
symbol(b).
symbol(c).

% tieneEstrella(+RegEx)
tieneEstrella(star(_)).
tieneEstrella(concat(A, B)) :- nonvar(A), nonvar(B), tieneEstrella(A).
tieneEstrella(concat(A, B)) :- nonvar(A), nonvar(B), tieneEstrella(B).
tieneEstrella(or(A, _)) :- tieneEstrella(A).
tieneEstrella(or(_, B)) :- tieneEstrella(B).

% longitudMaxima(+RegEx, -N)
longitudMaxima(empty, 0).
longitudMaxima(C, 1) :- symbol(C).
longitudMaxima(concat(A, B), N) :- longitudMaxima(A, N1), longitudMaxima(B, N2), N is N1 + N2.
longitudMaxima(or(A, B), N) :- longitudMaxima(A, N1), longitudMaxima(B, N2), N is max(N1, N2).
longitudMaxima(star(_), _) :- fail.

% cadena(?X)
cadena(X) :-length(X, _), lista_simbolos(X).

lista_simbolos([]).
lista_simbolos([C|Cs]) :- symbol(C), lista_simbolos(Cs).

% match_inst(+Cadena, +RegEx)
match_inst([], empty).
match_inst([], star(_)).
match_inst([C], C) :- symbol(C).
match_inst(Cs, concat(A, B)) :- append(L1, L2, Cs), match_inst(L1, A), match_inst(L2, B).
match_inst(Cs, or(A, _)) :- match_inst(Cs, A), !.
match_inst(Cs, or(_, B)) :- match_inst(Cs, B), !.
match_inst(Cs, star(C)) :- append(L1, L2, Cs), L1 \= [], match_inst(L1, C), match_inst(L2, star(C)).

% match(?Cadena, +RegEx)
match(Cadena, RegEx) :- nonvar(Cadena), match_inst(Cadena, RegEx).
match(Cadena, RegEx) :- var(Cadena), longitudMaxima(RegEx, Max), between(0, Max, Len), cadena_de_longitud(Len, Cadena), match_inst(Cadena, RegEx).
match(Cadena, RegEx) :- var(Cadena), \+longitudMaxima(RegEx, _), cadena(Cadena), match_inst(Cadena, RegEx).

cadena_de_longitud(0, []).
cadena_de_longitud(N, [S|R]) :- N > 0, N1 is N - 1, symbol(S), cadena_de_longitud(N1, R).

% diferencia(?Cadena, +R1, +R2)
diferencia(Cadena, R1, R2) :- match(Cadena, R1), \+ match_inst(Cadena, R2).