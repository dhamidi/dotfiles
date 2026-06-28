:- initialization(main, main).
:- consult('manifest.pl').

main :-
    ensure_all_files,
    ensure_all_installed,
    halt(0).

ensure_all_files :-
    forall(file(Path, Command), ensure_file(Path, Command)).

ensure_all_installed :-
    forall(installed(Name, Command), ensure_installed(Name, Command)).

ensure_installed(Name, _Command) :-
    check_installed(Name), !,
    report(ok, Name, installed).
ensure_installed(Name, Command) :-
    report(run, Name, Command),
    shell(Command, Status),
    (   Status =:= 0,
        check_installed(Name)
    ->  report(ok, Name, installed)
    ;   report(fail, Name, install),
        halt(1)
    ).

ensure_file(Path, _Command) :-
    exists_file(Path), !,
    report(ok, Path, present).
ensure_file(Path, Command) :-
    report(run, Path, Command),
    shell(Command, Status),
    (   Status =:= 0,
        exists_file(Path)
    ->  report(ok, Path, present)
    ;   report(fail, Path, missing),
        halt(1)
    ).

check_installed(Name) :-
    atomic_list_concat(['command -v ', Name, ' >/dev/null 2>&1'], Command),
    shell(Command, 0).

report(Status, Subject, Detail) :-
    format('~w ~w ~w~n', [Status, Subject, Detail]),
    flush_output.
