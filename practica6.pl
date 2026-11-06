padre(juan, carlos).
padre(juan, luis).
padre(carlos, daniel).
padre(carlos, diego).
padre(luis, pablo).
padre(luis, manuel).
padre(luis, ramiro).
abuelo(X, Y) :- padre(X, Z), padre(Z, Y).
hijo(X, Y) :- padre(Y, X).
hermano(X, Y) :- padre(Z, X), padre(Z, Y), X \== Y.
descendiente(X, Y) :- hijo(X, Y).
descendiente(X, Z) :- hijo(X, Y), descendiente(Y, Z).
ancestro(X, Y) :- descendiente(Y, X).

vecino(X, Y, [X|[Y|Ls]]).
vecino(X, Y, [W|Ls]) :- vecino(X, Y, Ls).

% HACER
natural(0).
natural(suc(X)) :- natural(X).
menorOIgual(X, X) :- natural(X).
menorOIgual(X, suc(Y)) :- menorOIgual(X, Y).

% concatenar(?Lista1, ?Lista2, ?Lista3)
concatenar([], L, L).
concatenar([X|L1], L2, [X|L3]) :- concatenar(L1, L2, L3).

% last_(?L, ?U)
last_([U], U).
last_([_|L], U) :- last_(L, U).

% reverse_(+L, -L1)
reverse_([], []).
reverse_([X|L1], L2) :- reverse_(L1, L3), concatenar(L3, [X], L2).

% maxlista(+L, -M)
maxlista([M], M).
maxlista([X|L], M1) :- maxlista(L, M2), M1 is max(X, M2).

% minlista(+L, -M)
minlista([M], M).
minlista([X|L], M1) :- minlista(L, M2), M1 is min(X, M2).

% prefijo(?P, +L)
prefijo([], _).
prefijo([X|P], [Y|L]) :- X is Y, prefijo(P, L).

% sufijo(?S, +L)
sufijo(Xs, Xs).
sufijo(Xs, [_|Ys]) :- sufijo(Xs, Ys).

% CONSULTAR DEVUELVE LISTAS QUE INDIVIDUALMENTE SON PARTE DE LA LISTA FINAL PERO NO TIENEN EL ORDEN
% sublista(?S, +L)
% sublista([], _).
% sublista([X|S], [X|L]) :- sublista(S, L).
% sublista([X|S], [Y|L]) :- X \== Y, sublista([X|S], L).
% sublista([X|S], [Y|L]) :- X \== Y -> sublista([X|S], L) ; sublista(S, L).

sublista([], _).
sublista([X|S], [Y|L]) :- X is Y, sublista(S, L).
sublista([X|S], [Y|L]) :- X \== Y, sublista([X|S], L).

% pertenece(?X, +L)
pertenece(X, [X|_]).
pertenece(X, [_|L]) :- pertenece(X, L).

% aplanar(+Xs, -Ys)
aplanar([], []).
aplanar([X|Xs], Ys) :- is_list(X), !, append(Ws, Zs, Ys), aplanar(X, Ws), aplanar(Xs, Zs).
aplanar([X|Xs], [X,Ys]) :- aplanar(Xs, Ys).

% palindromo(+L, -L1)
palindromo(L, L1) :- reverse_(L, R), concatenar(L, R, L1).

% CONSULTAR
% doble(?L, ?L1)
doble([], []).
doble([X|L], L1) :- doble(L, L2), concatenar([X,X], L2, L1).
% FALLA: doble(X, [a,a,b,b,c,c]).

% CONSULTAR
% iesimo(?I, +L, -X)
iesimo(1, [X|_], X).
iesimo(I, [_|L], X) :- I1 is I-1, iesimo(I1, L, X).
% ERROR: iesimo(Y, [10, 20, 30, 40], X). Arguments are not sufficiently instantiated

% desde(+X, ?Y)
desde(X, X).
desde(X, Y) :- nonvar(Y) -> Y >= X, N is X+1, desde(N, Y) ; N is X+1, desde(N, Y).
% Observacion: Devuelve true y luego false cuando Y es mayor que X.

% CONSULTAR
% interseccion(+L1, +L2, -L3)
% interseccion([], _, []).
% interseccion(_, [], []).
% interseccion([X|L1], L2, L3) :- pertenece(X, L2), concatenar([X], L3, L4), sinRepetidos(L4, L5), interseccion(L1, L2, L5).
% sinRepetidos([], []).
% sinRepetidos([X|L1], L2) :- pertenece(X, L2) -> sinRepetidos(L1, L2) ; sinRepetidos(L1, L3), concatenar([X], L2, L3).
% ERROR: recursión infinita con L3 como variable.

% split_(N, L, L1, L2)
split_(0, L, _, L).
split_(N, [X|L], [X|L1], L2) :- N>0, N1 is N-1, split_(N1, L, L1, L2).

% borrar(+ListaOriginal, +X, -ListaSinXs)
borrar([], _, []).
borrar([X|L1], X, L2) :- borrar(L1, X, L2).
borrar([Y|L1], X, [Y|L2]) :- X\==Y, borrar(L1, X, L2).

% sacarDuplicados(+L1, -L2)
sacarDuplicados([], []).
sacarDuplicados([X|L1], [X|L2]) :- \+member(X, L1), sacarDuplicados(L1, L2).
sacarDuplicados([X|L1], L2) :- member(X, L1), sacarDuplicados(L1, L2).

% reparto(+L, +N, -LListas)
reparto(L, 1, [L|_]).
% reparto([], N, [[]|LListas]) :- N>=1, N1 is N-1, reparto([], N1, LListas).
% reparto([X|L], N, [[X]|LListas]) :- N>=1, N1 is N-1, reparto(L, N1, LListas).
reparto([X|L], N, [[X]|LListas]) :- N>=1, N1 is N-1, append([X], LListas1, [X|L]), reparto(L, N1, LListas1).

% repartoSinVacias(+L, -LListas)
repartoSinVacias([], []).
repartoSinVacias(L, [L1|LListas]) :- append(L1, L2, L), L1 = [_|_], repartoSinVistas(L2, LListas).

intercalar([], L, L).
intercalar(L, [], L).
intercalar([X|L1], [Y|L2], [X,Y|L3]) :- intercalar(L1, L2, L3).

% elementosTomadosEnOrden(+L,+N,-Elementos)
elementosTomadosEnOrden([], _, []).
elementosTomadosEnOrden(L, 0, Elementos).
elementosTomadosEnOrden([X|L], N, [X|Elementos]) :- N>=0, N1 is N-1, elementosTomadosEnOrden(L, N1, Elementos).

% nil
% bin(izq, v, der)

vacio(nil).

raiz(bin(izq, v, der)).

altura(nil, 0).
altura(bin(L, _, R), N) :- altura(L, N1), altura(R, N2), N1>=N2, !, N is N1+1.
altura(bin(L, _, R), N) :- altura(L, N1), altura(R, N2), N2>N1, !, N is N2+1.

cantidadDeNodos(nil, 0).
cantidadDeNodos(bin(L, _, R), N) :- cantidadDeNodos(L, N1), cantidadDeNodos(R, N2), N is N1+N2+1.

% inorder(+AB,-Lista)
inorder(nil, []).
inorder(bin(L, X, R), Lista) :- inorder(L, Lista1), inorder(R, Lista2), append(Lista1, [X|Lista2], Lista).

% arbolConInorder(+Lista,-AB)
arbolConInorder([], nil).
arbolConInorder([X|Lista], bin(nil, X, R)) :- arbolConInorder(Lista, R).
% arbolConInorder(Lista, bin(L, X, R)) :- append(Lista1, [X|Lista2], Lista), arbolConInorder(Lista1, L), arbolConInorder(Lista2, R).

%REINTENTAR
% coprimos(-X,-Y)
coprimos(X, Y) :- Y1 is Y+1, !, 1 is gcd(X, Y), coprimos(X, Y1).

% cuadradoSemiLatino(+N, -XS)
% cuadradoSemiLatino(X)

% diferenciaSimetrica(+Lista1, +Lista2, -Lista3)
diferenciaSimetrica([], L, L).
diferenciaSimetrica(L, [], L).
diferenciaSimetrica([X|Xs], Ys, [X|L]) :- \+member(X, Ys), diferenciaSimetrica(Xs, Ys, L), !.
diferenciaSimetrica(Xs, [Y|Ys], [Y|L]) :- \+member(Y, Xs), diferenciaSimetrica(Xs, Ys, L), !.

% corteMasParejo(+L,-L1,-L2)
corteMasParejo(L, L1, L2) :- length(L, N), N1 is N/2, split(N1, L, L1, L2).

% pop visto en clase
% ht(X, Xs, [X|Xs]).