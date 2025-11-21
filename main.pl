:- use_module(library(pce)).
:- use_module(library(process)).

start :-
    % Determine initial directory (home)
    expand_file_name('~', [HomeDir]),

    new(D, dialog('Directory Listing')),
    send(D, size, size(800, 600)),

    % Text field to hold the directory path
    send(D, append, new(DirItem, text_item(directory, HomeDir))),

    % Editor widget to display the listing
    send(D, append, new(Editor, editor), below),

    % Refresh button: calls refresh/2 in Prolog
    send(D, append, button(refresh, message(@prolog, refresh, DirItem, Editor))),

    send(D, open),
    refresh(DirItem, Editor).

refresh(DirItem, Editor) :-
    % Read directory string from the text field
    get(DirItem, selection, Dir0),
    % Expand ~ etc to a real path
    expand_file_name(Dir0, [Dir]),

    % Run ls on that directory and capture output
    process_create(path(ls), [Dir], [stdout(pipe(Out))]),
    read_string(Out, _, Output),
    close(Out),

    % Update the editor with the new listing
    send(Editor, contents, Output).
