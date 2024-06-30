/** Autor: David Hudák
  * Projekt: FLP logický projekt -- Rubikova kostka
  * Akademický rok: 2022/2023, letní semestr
  * Login autora: xhudak03
  * Krátký popis: Tento soubor obsahuje hlavní a jedinou část implementace.
**/



/** cte radky ze standardniho vstupu, konci na LF nebo EOF */
read_line(L,C) :-
	get_char(C),
	(isEOFEOL(C), L = [], !;
		read_line(LL,_),% atom_codes(C,[Cd]),
		[C|LL] = L).


/** testuje znak na EOF nebo LF */
isEOFEOL(C) :-
	C == end_of_file;
	(char_code(C,Code), Code==10).


read_lines(Ls) :-
	read_line(L,C),
	( C == end_of_file, Ls = [] ;
	  read_lines(LLs), Ls = [L|LLs]
	).

/** rozdeli radek na podseznamy */
split_line([],[[]]) :- !.
split_line([' '|T], [[]|S1]) :- !, split_line(T,S1).
split_line([32|T], [[]|S1]) :- !, split_line(T,S1).    % aby to fungovalo i s retezcem na miste seznamu
split_line([10|T], [S1]) :- !, split_line(T,S1).    % aby to fungovalo i s retezcem na miste seznamu
split_line([H|T], [[H|G]|S1]) :- split_line(T,[G|S1]). % G je prvni seznam ze seznamu seznamu G|S1


/** vstupem je seznam radku (kazdy radek je seznam znaku) */
split_lines([],[]).
split_lines([L|Ls],[H|T]) :- split_lines(Ls,T), split_line(L,H).

write_lines_help([]):- nl.
write_lines_help([H|T]) :- writef("%w%w%w ", H), write_lines_help(T).

/** vypise seznam radku (kazdy radek samostatne) */
write_lines([]).
write_lines([H|T]) :- write_lines_help(H), write_lines(T).

walk_cubes_path([]).
walk_cubes_path([H|T]) :- nl, write_lines(H), walk_cubes_path(T).
/** Hlavní funkce projektu*/
start :-
		prompt(_, ''),
		read_lines(LL),
		split_lines(LL,S),
		cube_damn_line_remover(S, Snew),
        write_lines(Snew),
        solve_caller(Snew, 1),
        % write_lines(Snew),
        halt.
        % ; write(S), write("Chybny pocet radku\n"), halt).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hledání řešení

solve_caller(Cube, Depth) :-
    solve(Cube, CubeMoves, Depth), walk_cubes_path(CubeMoves);
    NewDepth is Depth + 1, solve_caller(Cube, NewDepth).

solve(Cube, _, _) :-
    is_result(Cube, Cube).

solve(Cube, [CubeMoved|Path], Limit) :-
    (
        rotate_right(Cube, 1, CubeMoved);
        rotate_left(Cube, 1, CubeMoved);
        rotate_right(Cube, 2, CubeMoved);
        rotate_left(Cube, 2, CubeMoved);
        rotate_right(Cube, 3, CubeMoved);
        rotate_left(Cube, 3, CubeMoved);
        
        rotate_front_left_down(Cube, CubeMoved);
        rotate_front_left_up(Cube, CubeMoved);
        rotate_front_mid_down(Cube, CubeMoved);
        rotate_front_mid_up(Cube, CubeMoved);
        rotate_front_right_down(Cube, CubeMoved);
        rotate_front_right_up(Cube, CubeMoved);

        rotate_rightview_left_down(Cube, CubeMoved);
        rotate_rightview_left_up(Cube, CubeMoved);
        rotate_rightview_mid_down(Cube, CubeMoved);
        rotate_rightview_mid_up(Cube, CubeMoved);
        rotate_rightview_right_down(Cube, CubeMoved);
        rotate_rightview_right_up(Cube, CubeMoved)
    ),
    Lminus is Limit - 1,
    Lminus > 0,
    solve(CubeMoved, Path, Lminus).
    
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definice vysledku a základní úprava kostky

% Korektní výsledek, pouze pro experimentální důvody
result([
        [[5, 5, 5]], % Upper strana kostky
        [[5, 5, 5]],
        [[5, 5, 5]],
        [[1, 1, 1],[2, 2, 2],[3, 3, 3], [4, 4, 4]], % Front, right, back, left
        [[1, 1, 1],[2, 2, 2],[3, 3, 3], [4, 4, 4]],
        [[1, 1, 1],[2, 2, 2],[3, 3, 3], [4, 4, 4]],
        [[6, 6, 6]], % Down strana kostky
        [[6, 6, 6]],
        [[6, 6, 6]]
    ]).

 % Predikát výsledku
is_result([
        [[U1, _, _]], % Upper strana kostky
        [[_, _, _]],
        [[_, _, _]],
        [[F1, _, _],[R1, _, _],[B1, _, _], [L1, _, _]], % Front, right, back, left
        [[_, _, _],[_, _, _],[_, _, _], [_, _, _]],
        [[_, _, _],[_, _, _],[_, _, _], [_, _, _]],
        [[D1, _, _]], % Down strana kostky
        [[_, _, _]],
        [[_, _, _]]
    ],
    [
        [[U1, U1, U1]], % Upper strana kostky
        [[U1, U1, U1]],
        [[U1, U1, U1]],
        [[F1, F1, F1],[R1, R1, R1],[B1, B1, B1], [L1, L1, L1]], % Front, right, back, left
        [[F1, F1, F1],[R1, R1, R1],[B1, B1, B1], [L1, L1, L1]],
        [[F1, F1, F1],[R1, R1, R1],[B1, B1, B1], [L1, L1, L1]],
        [[D1, D1, D1]], % Down strana kostky
        [[D1, D1, D1]],
        [[D1, D1, D1]]
    ]).

% Ošetření bince na vstupu
cube_damn_line_remover([
        [[U1, U2, U3 | _]], % Upper strana kostky
        [[U4, U5, U6 | _]],
        [[U7, U8, U9 | _]],
        [[F1, F2, F3],[R1, R2, R3],[B1, B2, B3], [L1, L2, L3 | _]], % Front, right, back, left
        [[F4, F5, F6],[R4, R5, R6],[B4, B5, B6], [L4, L5, L6 | _]],
        [[F7, F8, F9],[R7, R8, R9],[B7, B8, B9], [L7, L8, L9 | _]],
        [[D1, D2, D3 | _]], % Down strana kostky
        [[D4, D5, D6 | _]],
        [[D7, D8, D9 | _]] | _
    ], 
    [
        [[U1, U2, U3]], % Upper strana kostky
        [[U4, U5, U6]],
        [[U7, U8, U9]],
        [[F1, F2, F3],[R1, R2, R3],[B1, B2, B3], [L1, L2, L3]], % Front, right, back, left
        [[F4, F5, F6],[R4, R5, R6],[B4, B5, B6], [L4, L5, L6]],
        [[F7, F8, F9],[R7, R8, R9],[B7, B8, B9], [L7, L8, L9]],
        [[D1, D2, D3]], % Down strana kostky
        [[D4, D5, D6]],
        [[D7, D8, D9]]
    ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Úsek rotací
% Rotace doprava

rotate_right_up_or_down(C, 1, Res) :- % Rotuj horní část kostky
    rotate_hor_up_right(C, Res).

rotate_right_up_or_down(C, 2, C). % Jsi uprostřed, nic nerotuj

rotate_right_up_or_down(C, 3, Res) :- % Jsi dole, orotuj to dole
    rotate_hor_down_right(C, Res).

rotate_right(C, N, Res) :- 
    rotate_right_up_or_down(C, N, ResM), % Zrotuj horní či dolní část kostky podle potřeby
    rotate_four_caller(ResM, Npom, Res), % Zrotuj jeden z řádků
    N is Npom - 3. % V mé reprezentaci jsou horizontální řádky až ve 4.-6. řádku. Tímto zajistím posun na ně.

rotate_four_caller([Line|Cube], 1, [RoLine|Cube]) :-
    rotate_four(Line, RoLine).

rotate_four_caller([H|Restcube], N, [H|Res]) :-
    rotate_four_caller(Restcube, Nless, Res),
    N is Nless + 1. % Výběr správného řádku

rotate_four([F, R, B, L], [L, F, R, B]). % Protočí řádek
%%%%%%%%
% Rotace doleva

rotate_left(C, N, Res) :- % Rotace doleva je to samé, co doprava, jenom naopak.
    rotate_right(Res, N, C).

%%%%%%%%%%%%%%%%
% Rotace doleva a doprava horizontálně pro horní a dolní část kostky

rotate_hor_up_right([
        [[U1, U2, U3]], % Upper strana kostky
        [[U4, U5, U6]],
        [[U7, U8, U9]],
        M1, M2, M3, D1, D2, D3
    ],
    [
        [[U3, U6, U9]], % Upper strana kostky
        [[U2, U5, U8]],
        [[U1, U4, U7]],
        M1, M2, M3, D1, D2, D3
    ]).

rotate_hor_down_right([
        U1, U2, U3, M1, M2, M3,
        [[D1, D2, D3]],
        [[D4, D5, D6]],
        [[D7, D8, D9]]
    ],
    [
        U1, U2, U3, M1, M2, M3,
        [[D7, D4, D1]],
        [[D8, D5, D2]],
        [[D9, D6, D3]]
    ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotace vertiáklní -- zepředu levý sloupec (front)
% Je to napsané trochu nepěkně, ale nic lepšího jsem nevymyslel. Rotace na opačnou stranu jsou pod každou rotací udělané jako inverze operace.

rotate_front_left_down([
        [[U1, U2, U3]], % Upper strana kostky
        [[U4, U5, U6]],
        [[U7, U8, U9]],
        [[F1, F2, F3],R1,[B1, B2, B3], [L1, L2, L3]], % Front, right, back, left
        [[F4, F5, F6],R2,[B4, B5, B6], [L4, L5, L6]],
        [[F7, F8, F9],R3,[B7, B8, B9], [L7, L8, L9]],
        [[D1, D2, D3]], % Down strana kostky
        [[D4, D5, D6]],
        [[D7, D8, D9]]],
    [
        [[B9, U2, U3]], % Upper strana kostky
        [[B6, U5, U6]],
        [[B3, U8, U9]],
        [[U1, F2, F3],R1,[B1, B2, D7], [L7, L4, L1]], % Front, right, back, left
        [[U4, F5, F6],R2,[B4, B5, D4], [L8, L5, L2]],
        [[U7, F8, F9],R3,[B7, B8, D1], [L9, L6, L3]],
        [[F1, D2, D3]], % Down strana kostky
        [[F4, D5, D6]],
        [[F7, D8, D9]]]).

rotate_front_left_up(Cube, Res) :- rotate_front_left_down(Res, Cube).

% Rotace vertikální -- zepředu uprostřed (front)
rotate_front_mid_down([
        [[U1, U2, U3]], % Upper strana kostky
        [[U4, U5, U6]],
        [[U7, U8, U9]],
        [[F1, F2, F3],R1,[B1, B2, B3], L1], % Front, right, back, left
        [[F4, F5, F6],R2,[B4, B5, B6], L2],
        [[F7, F8, F9],R3,[B7, B8, B9], L3],
        [[D1, D2, D3]], % Down strana kostky
        [[D4, D5, D6]],
        [[D7, D8, D9]]],
    [
        [[U1, B8, U3]], % Upper strana kostky
        [[U4, B5, U6]],
        [[U7, B2, U9]],
        [[F1, U2, F3],R1,[B1, D8, B3], L1], % Front, right, back, left
        [[F4, U5, F6],R2,[B4, D5, B6], L2],
        [[F7, U8, F9],R3,[B7, D2, B9], L3],
        [[D1, F2, D3]], % Down strana kostky
        [[D4, F5, D6]],
        [[D7, F8, D9]]]).

rotate_front_mid_up(Cube, Res) :- rotate_front_mid_down(Res, Cube).

% Rotace vertikální -- zepředu napravo (front)
rotate_front_right_down([
        [[U1, U2, U3]], % Upper strana kostky
        [[U4, U5, U6]],
        [[U7, U8, U9]],
        [[F1, F2, F3],[R1, R2, R3],[B1, B2, B3], L1], % Front, right, back, left
        [[F4, F5, F6],[R4, R5, R6],[B4, B5, B6], L2],
        [[F7, F8, F9],[R7, R8, R9],[B7, B8, B9], L3],
        [[D1, D2, D3]], % Down strana kostky
        [[D4, D5, D6]],
        [[D7, D8, D9]]],
    [
        [[U1, U2, B7]], % Upper strana kostky
        [[U4, U5, B4]],
        [[U7, U8, B1]],
        [[F1, F2, U3],[R3, R6, R9],[D9, B2, B3], L1], % Front, right, back, left
        [[F4, F5, U6],[R2, R5, R8],[D6, B5, B6], L2],
        [[F7, F8, U9],[R1, R4, R7],[D3, B8, B9], L3],
        [[D1, D2, F3]], % Down strana kostky
        [[D4, D5, F6]],
        [[D7, D8, F9]]]).

rotate_front_right_up(Cube, Res) :- rotate_front_right_down(Res, Cube).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotace vertikální -- z pohledu zprava (right)
% Rotace na levém sloupečku
rotate_rightview_left_down([
        [[U1, U2, U3]], % Upper strana kostky
        [[U4, U5, U6]],
        [[U7, U8, U9]],
        [[F1, F2, F3],[R1, R2, R3],[B1, B2, B3], [L1, L2, L3]], % Front, right, back, left
        [[F4, F5, F6],[R4, R5, R6],[B4, B5, B6], [L4, L5, L6]],
        [[F7, F8, F9],[R7, R8, R9],[B7, B8, B9], [L7, L8, L9]],
        [[D1, D2, D3]], % Down strana kostky
        [[D4, D5, D6]],
        [[D7, D8, D9]]],
    [
        [[U1, U2, U3]], % Upper strana kostky
        [[U4, U5, U6]],
        [[L9, L6, L3]],
        [[F7, F4, F1],[U7, R2, R3],[B1, B2, B3], [L1, L2, D1]], % Front, right, back, left
        [[F8, F5, F2],[U8, R5, R6],[B4, B5, B6], [L4, L5, D2]],
        [[F9, F6, F3],[U9, R8, R9],[B7, B8, B9], [L7, L8, D3]],
        [[R7, R4, R1]], % Down strana kostky
        [[D4, D5, D6]],
        [[D7, D8, D9]]]).

rotate_rightview_left_up(Cube, Res) :- rotate_rightview_left_down(Res, Cube).

% Rotace na prostředním sloupečku z pravého pohledu 
rotate_rightview_mid_down([
        [[U1, U2, U3]], % Upper strana kostky
        [[U4, U5, U6]],
        [[U7, U8, U9]],
        [[F1, F2, F3],[R1, R2, R3],[B1, B2, B3], [L1, L2, L3]], % Front, right, back, left
        [[F4, F5, F6],[R4, R5, R6],[B4, B5, B6], [L4, L5, L6]],
        [[F7, F8, F9],[R7, R8, R9],[B7, B8, B9], [L7, L8, L9]],
        [[D1, D2, D3]], % Down strana kostky
        [[D4, D5, D6]],
        [[D7, D8, D9]]],
    [
        [[U1, U2, U3]], % Upper strana kostky
        [[L8, L5, L2]],
        [[U7, U8, U9]],
        [[F1, F2, F3],[R1, U4, R3],[B1, B2, B3], [L1, D4, L3]], % Front, right, back, left
        [[F4, F5, F6],[R4, U5, R6],[B4, B5, B6], [L4, D5, L6]],
        [[F7, F8, F9],[R7, U6, R9],[B7, B8, B9], [L7, D6, L9]],
        [[D1, D2, D3]], % Down strana kostky
        [[R8, R5, R2]],
        [[D7, D8, D9]]]).

rotate_rightview_mid_up(Cube, Res) :- rotate_rightview_mid_down(Res, Cube).

% Rotace na pravém sloupečku z pravého pohledu
rotate_rightview_right_down([
        [[U1, U2, U3]], % Upper strana kostky
        [[U4, U5, U6]],
        [[U7, U8, U9]],
        [[F1, F2, F3],[R1, R2, R3],[B1, B2, B3], [L1, L2, L3]], % Front, right, back, left
        [[F4, F5, F6],[R4, R5, R6],[B4, B5, B6], [L4, L5, L6]],
        [[F7, F8, F9],[R7, R8, R9],[B7, B8, B9], [L7, L8, L9]],
        [[D1, D2, D3]], % Down strana kostky
        [[D4, D5, D6]],
        [[D7, D8, D9]]],
    [
        [[L7, L4, L1]], % Upper strana kostky
        [[U4, U5, U6]],
        [[U7, U8, U9]],
        [[F1, F2, F3],[R1, R2, U1],[B3, B6, B9], [D7, L2, L3]], % Front, right, back, left
        [[F4, F5, F6],[R4, R5, U2],[B2, B5, B8], [D8, L5, L6]],
        [[F7, F8, F9],[R7, R8, U3],[B1, B4, B7], [D9, L8, L9]],
        [[D1, D2, D3]], % Down strana kostky
        [[D4, D5, D6]],
        [[R9, R6, R3]]]).

rotate_rightview_right_up(Cube, Res) :- rotate_rightview_right_down(Res, Cube).
