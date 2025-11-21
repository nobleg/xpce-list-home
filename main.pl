:- use_module(library(pce)).
:- use_module(library(process)).

% XPCE home directory lister – version 1.0


start :-
    % Find home directory
    expand_file_name('~', [HomeDir]),

    % Run ls and capture stdout
    process_create(path(ls), [HomeDir],
                   [ stdout(pipe(Out)),
                     process(PID)
                   ]),
    read_string(Out, _, Output),
    close(Out),

    % XPCE window
    new(D, dialog('Home Directory Listing')),
    send(D, append, new(E, editor)),
    send(E, contents, Output),
    send(D, size, size(800, 600)),
    send(D, open),

    format('Spawned ls via PID ~w~n', [PID]).
