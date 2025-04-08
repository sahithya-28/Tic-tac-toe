:- dynamic board/1.

% Initialize the board
init_board :-
    retractall(board(_)),
    assert(board([ '-', '-', '-', '-', '-', '-', '-', '-', '-' ])).

% Display the board
display_board :-
    board(B),
    nth0(0, B, A1), nth0(1, B, A2), nth0(2, B, A3),
    nth0(3, B, B1), nth0(4, B, B2), nth0(5, B, B3),
    nth0(6, B, C1), nth0(7, B, C2), nth0(8, B, C3),
    format("w | ~w | ~wn", [A1, A2, A3]),
    format("--+---+--~n"),
    format("w | ~w | ~wn", [B1, B2, B3]),
    format("--+---+--~n"),
    format("w | ~w | ~wn", [C1, C2, C3]),
    nl.

% Make a move
make_move(Player, Position) :-
    board(B),
    nth0(Position, B, '-', Rest),
    nth0(Position, NewBoard, Player, Rest),
    retract(board(B)),
    assert(board(NewBoard)).

% Check if a player has won
check_winner(Player) :-
    board(B),
    (win_combination(Player, B) -> true ; fail).

win_combination(P, [P, P, P, _, _, _, _, _, _]).
win_combination(P, [_, _, _, P, P, P, _, _, _]).
win_combination(P, [_, _, _, _, _, _, P, P, P]).
win_combination(P, [P, _, _, P, _, _, P, _, _]).
win_combination(P, [_, P, _, _, P, _, _, P, _]).
win_combination(P, [_, _, P, _, _, P, _, _, P]).
win_combination(P, [P, _, _, _, P, _, _, _, P]).
win_combination(P, [_, _, P, _, P, _, P, _, _]).

% Check for a draw
check_draw :-
    board(B),
    \+ member('-', B),  % No empty spaces left
    writeln("It's a draw!"),
    init_board.

% Start the game
play :-
    init_board,
    display_board,
    play_turn('X').

% Play turns alternately
play_turn(Player) :-
    format("Player ~w, enter your move (0-8) or type 'exit' to quit: ", [Player]),
    read(Input),
    (Input == exit -> writeln("Game exited."), ! ;
    (integer(Input), between(0, 8, Input) ->
        board(B),
        nth0(Input, B, Val),
        (Val == '-' -> make_move(Player, Input), display_board, 
            (check_winner(Player) -> format("Player ~w wins!~n", [Player]), init_board ;
             check_draw ;
             switch_player(Player, Next), play_turn(Next)) 
        ; writeln("Invalid move, try again."), play_turn(Player))
    ; writeln("Invalid input, try again."), play_turn(Player))).

% Switch players
switch_player('X', 'O').
switch_player('O', 'X').