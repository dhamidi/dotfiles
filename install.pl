:- consult('manifest.pl').

main :-
    ensure_all_files,
    ensure_all_installed,
    halt(0).

ensure_all_files :-
    forall(file(Path, Actions), ensure_file(Path, Actions)).

ensure_all_installed :-
    forall(installed(Name, Actions), ensure_installed(Name, Actions)).

desired(file(Path), present) :-
    file(Path, _Actions).
desired(installed(Name), present) :-
    installed(Name, _Actions).

actual(file(Path), present) :-
    file_present(Path), !.
actual(file(_Path), missing).
actual(installed(Name), present) :-
    check_installed(Name), !.
actual(installed(_Name), missing).

state(Target, Desired, Actual) :-
    desired(Target, Desired),
    actual(Target, Actual).

satisfied(Target) :-
    state(Target, Desired, Desired).

planned_command(file(Path), Command) :-
    file(Path, Actions),
    \+ satisfied(file(Path)),
    shell_script(Actions, Command).
planned_command(installed(Name), Command) :-
    installed(Name, Actions),
    \+ satisfied(installed(Name)),
    shell_script(Actions, Command).

desired_file(Path) :-
    desired(file(Path), present).

desired_tree(Paths) :-
    findall(Path, desired_file(Path), Paths).

missing_file(Path) :-
    state(file(Path), present, missing).

present_file(Path) :-
    state(file(Path), present, present).

tree_diff(Path, Status) :-
    state(file(Path), present, Status).

file_present(Path) :-
    expand_file_name(Path, [ExpandedPath]),
    exists_file(ExpandedPath).

print_planned_commands :-
    forall(planned_command(Target, Command),
           format('~w ~w~n', [Target, Command])).

print_desired_tree :-
    forall(desired_file(Path), format('~w~n', [Path])).

print_tree_diff :-
    forall(tree_diff(Path, Status), format('~w ~w~n', [Status, Path])).

ensure_installed(Name, _Actions) :-
    check_installed(Name), !,
    report(ok, Name, installed).
ensure_installed(Name, Actions) :-
    shell_script(Actions, Command),
    report(run, action, Command),
    shell(Command, Status),
    (   Status =:= 0,
        check_installed(Name)
    ->  report(ok, Name, installed)
    ;   report(fail, Name, install),
        halt(1)
    ).

ensure_file(Path, _Actions) :-
    file_present(Path), !,
    report(ok, Path, present).
ensure_file(Path, Actions) :-
    shell_script(Actions, Command),
    report(run, action, Command),
    shell(Command, Status),
    (   Status =:= 0,
        file_present(Path)
    ->  report(ok, Path, present)
    ;   report(fail, Path, missing),
        halt(1)
    ).

shell_script(Actions, Command) :-
    maplist(shell_fragment, Actions, Fragments),
    atomic_list_concat(Fragments, ' && ', Command).

shell_fragment(copy_file(Source, Target), Command) :-
    dirname(Target, Dir),
    atomic_list_concat(['mkdir -p ', Dir, ' && cp ', Source, ' ', Target], Command).
shell_fragment(copy_tree(Source, Target), Command) :-
    dirname(Target, Dir),
    atomic_list_concat(['mkdir -p ', Dir, ' && cp -R ', Source, '/. ', Target, '/'], Command).
shell_fragment(chmod_exec(Path), Command) :-
    atomic_list_concat(['chmod +x ', Path], Command).
shell_fragment(run(Command), Command).

dirname(Path, Dir) :-
    atomic_list_concat(Parts, '/', Path),
    append(DirParts, [_Base], Parts),
    atomic_list_concat(DirParts, '/', Dir).

check_installed(Name) :-
    atomic_list_concat(['command -v ', Name, ' >/dev/null 2>&1'], Command),
    shell(Command, 0).

report(Status, Subject, Detail) :-
    format('~w ~w ~w~n', [Status, Subject, Detail]),
    flush_output.
