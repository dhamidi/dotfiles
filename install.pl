:- initialization(main, main).

main :-
    ensure_file('bin/agents', 'mkdir -p ~/.local/bin && cp bin/agents ~/.local/bin/agents && chmod +x ~/.local/bin/agents'),
    ensure_file('config/AGENTS.md', 'mkdir -p ~/.config && cp config/AGENTS.md ~/.config/AGENTS.md'),
    ensure_file('agents/skills/secret-management/SKILL.md', 'mkdir -p ~/.agents/skills && cp -R agents/skills/. ~/.agents/skills/'),
    ensure_installed('agents', '~/.local/bin/agents sync'),
    halt(0).

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
