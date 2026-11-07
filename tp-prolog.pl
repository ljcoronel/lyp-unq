% symbol(?C)
symbol(a).
symbol(b).
symbol(c).

% tieneEstrella(+RegEx)
tieneEstrella(star(_)).
tieneEstrella(concat(R, _)) :- tieneEstrella(R), !.
tieneEstrella(concat(_, R)) :- tieneEstrella(R).
tieneEstrella(or(R, _)) :- tieneEstrella(R), !.
tieneEstrella(or(_, R)) :- tieneEstrella(R).

% longitudMaxima(+RegEx, -N)
longitudMaxima(empty, 0).
longitudMaxima(R, 1) :- symbol(R).
longitudMaxima(concat(R1, R2), N) :- longitudMaxima(R1, N1), longitudMaxima(R2, N2), N is N1 + N2.
longitudMaxima(or(R1, R2), N) :- longitudMaxima(R1, N1), longitudMaxima(R2, N2), N is max(N1, N2).
longitudMaxima(star(_), _) :- fail.

% cadena(?X)
cadena(X) :- length(X, _), maplist(symbol, X).

% match_inst(+Cadena, +RegEx)
match_inst([], empty) :- !.
match_inst([], star(_)) :- !.
match_inst([R], R) :- symbol(R), !.
match_inst(Cadena, concat(R1, R2)) :- append(C1, C2, Cadena), match_inst(C1, R1), match_inst(C2, R2), !.
match_inst(Cadena, or(R, _)) :- match_inst(Cadena, R), !.
match_inst(Cadena, or(_, R)) :- match_inst(Cadena, R), !.
match_inst(Cadena, star(R)) :- append(C1, C2, Cadena), C1 \= [], match_inst(C1, R), match_inst(C2, star(R)), !.

% match(?Cadena, +RegEx)
match(Cadena, R) :- nonvar(Cadena), !, match_inst(Cadena, R).
match(Cadena, R) :- longitudMaxima(R, M), between(0, M, N), cadena_de_longitud(Cadena, N), match_inst(Cadena, R).
match(Cadena, R) :- \+longitudMaxima(R, _), cadena(Cadena), match_inst(Cadena, R).

cadena_de_longitud([], 0).
cadena_de_longitud([R|Cadena], N) :- N > 0, N1 is N - 1, symbol(R), cadena_de_longitud(Cadena, N1).

% diferencia(?Cadena, +R1, +R2)
diferencia(Cadena, R1, R2) :- match(Cadena, R1), \+match_inst(Cadena, R2).