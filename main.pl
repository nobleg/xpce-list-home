:- use_module(library(pce)).
:- use_module(library(process)).

start :-
    new(D, dialog('Home Directory Listing')),
    send(D, size, size(800, 600)),

    % Editor widget to show the directory listing
    send(D, append, new(E, editor), below),

    % Refresh button
    send(D, append, button(refresh, message(@prolog, refresh, E))),

    send(D, open),
    refresh(E).

refresh(Editor) :-
    expand_file_name('~', [HomeDir]),
    process_create(path(ls), [HomeDir], [stdout(pipe(Out))]),
    read_string(Out, _, Output),
    close(Out),
    send(Editor, contents, Output).
