:- use_module(library(crypto)).
:- consult('manifest.pl').

main :-
    install,
    halt(0).

cli :-
    current_prolog_flag(argv, Args),
    cli(Args),
    halt(0).

cli([]) :-
    install.
cli([install]) :-
    install.
cli([status]) :-
    print_state.
cli([diff]) :-
    run_diff.
cli([pull]) :-
    run_pull.
cli([commit]) :-
    run_commit('chore: update dotfiles').
cli([commit, '-m', Message]) :-
    run_commit(Message).
cli([sync]) :-
    run_sync('chore: update dotfiles').
cli([sync, '-m', Message]) :-
    run_sync(Message).
cli([commands]) :-
    print_planned_commands.
cli([tree]) :-
    print_desired_tree.
cli([help]) :-
    print_help.
cli(_) :-
    print_help,
    halt(1).

install :-
    ensure_all_files,
    ensure_all_installed.

ensure_all_files :-
    forall(file(_Repo, System, _Specs), ensure_file(System)).

ensure_all_installed :-
    forall(installed(Name, _Actions), ensure_installed(Name)).

desired(file(System), present) :-
    file(_Repo, System, _Specs).
desired(installed(Name), present) :-
    installed(Name, _Actions).

actual(file(System), present) :-
    managed(Repo, System),
    same_file_or_tree(Repo, System), !.
actual(file(System), stale) :-
    file_present(System), !.
actual(file(_System), missing).
actual(installed(Name), present) :-
    check_installed(Name), !.
actual(installed(_Name), missing).

state(Target, Desired, Actual) :-
    desired(Target, Desired),
    actual(Target, Actual).

satisfied(Target) :-
    state(Target, Desired, Desired).

managed(Repo, System) :-
    file(Repo, System, _Specs).

install_actions(Repo, System, Actions) :-
    file(Repo, System, Specs),
    maplist(install_action(Repo, System), Specs, Actions).

install_action(Repo, System, copy_file, copy_file(Repo, System)).
install_action(Repo, System, copy_tree, copy_tree(Repo, System)).
install_action(_Repo, System, chmod_exec, chmod_exec(System)).

pull_actions(Repo, System, [copy_file(System, Repo)]) :-
    file(Repo, System, Specs),
    member(copy_file, Specs).
pull_actions(Repo, System, [copy_tree(System, Repo)]) :-
    file(Repo, System, Specs),
    member(copy_tree, Specs).

planned_command(file(System), Command) :-
    managed(Repo, System),
    \+ satisfied(file(System)),
    install_actions(Repo, System, Actions),
    shell_script(Actions, Command).
planned_command(installed(Name), Command) :-
    installed(Name, Actions),
    \+ satisfied(installed(Name)),
    shell_script(Actions, Command).

pull_command(Repo, System, Command) :-
    managed(Repo, System),
    pull_actions(Repo, System, Actions),
    shell_script(Actions, Command).

diff_command(Repo, System, Command) :-
    managed(Repo, System),
    atomic_list_concat(['diff -ruN ', Repo, ' ', System], Command).

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

same_file_or_tree(Repo, System) :-
    content_hash(Repo, RepoHash),
    content_hash(System, SystemHash),
    RepoHash == SystemHash.

content_hash(Path, Hash) :-
    expand_file_name(Path, [ExpandedPath]),
    exists_file(ExpandedPath), !,
    crypto_file_hash(ExpandedPath, Hash, [algorithm(sha256)]).
content_hash(Path, Hash) :-
    expand_file_name(Path, [ExpandedPath]),
    exists_directory(ExpandedPath),
    directory_hash(ExpandedPath, Hash).

directory_hash(Dir, Hash) :-
    directory_files_recursive(Dir, Files),
    maplist(relative_file_hash(Dir), Files, Pairs),
    sort(Pairs, SortedPairs),
    term_string(SortedPairs, Content),
    crypto_data_hash(Content, Hash, [algorithm(sha256)]).

directory_files_recursive(Dir, Files) :-
    directory_files(Dir, Entries),
    findall(File,
            ( member(Entry, Entries),
              \+ member(Entry, ['.', '..']),
              directory_file_path(Dir, Entry, Path),
              nested_file(Path, File)
            ),
            Nested),
    flatten(Nested, Files).

nested_file(Path, Path) :-
    exists_file(Path).
nested_file(Path, Files) :-
    exists_directory(Path),
    directory_files_recursive(Path, Files).

relative_file_hash(Dir, File, Relative-Hash) :-
    relative_file_name(File, Dir, Relative),
    crypto_file_hash(File, Hash, [algorithm(sha256)]).

file_present(Path) :-
    expand_file_name(Path, [ExpandedPath]),
    ( exists_file(ExpandedPath) ; exists_directory(ExpandedPath) ).

print_planned_commands :-
    forall(planned_command(Target, Command),
           format('~w ~w~n', [Target, Command])).

print_desired_tree :-
    forall(desired_file(Path), format('~w~n', [Path])).

print_tree_diff :-
    forall(tree_diff(Path, Status), format('~w ~w~n', [Status, Path])).

print_state :-
    forall(state(Target, Desired, Actual),
           format('~w desired=~w actual=~w~n', [Target, Desired, Actual])).

run_diff :-
    forall(diff_command(_Repo, _System, Command), run_optional(Command)).

run_pull :-
    forall(pull_command(Repo, System, Command),
           ( report(run, action, Command),
             shell(Command, Status),
             ( Status =:= 0 -> report(ok, Repo, synced_from(System))
             ; report(fail, Repo, synced_from(System)), halt(1)
             )
           )).

run_commit(Message) :-
    in_dotfiles_repo((
        run_pull,
        stage_and_commit(Message)
    )).

run_sync(Message) :-
    run_commit(Message),
    in_dotfiles_repo(shell('git push', PushStatus)),
    ( PushStatus =:= 0 -> report(ok, git, pushed)
    ; report(fail, git, push), halt(1)
    ).

in_dotfiles_repo(Goal) :-
    source_file(run_sync(_), SourceFile),
    file_directory_name(SourceFile, RepoDir),
    working_directory(CurrentDir, RepoDir),
    call_cleanup(Goal, working_directory(_, CurrentDir)).

stage_and_commit(Message) :-
    shell('git add .', AddStatus),
    ( AddStatus =:= 0 -> true ; report(fail, git, add), halt(1) ),
    shell('git diff --cached --quiet', DiffStatus),
    ( DiffStatus =:= 0 -> report(ok, git, unchanged)
    ; shell_script([run('git diff --cached'), run_commit_command(Message)], Command),
      shell(Command, CommitStatus),
      ( CommitStatus =:= 0 -> report(ok, git, committed)
      ; report(fail, git, commit), halt(1)
      )
    ).

run_commit_command(Message, Command) :-
    atomic_list_concat(['git commit -m ', '''', Message, ''''], Command).

ensure_installed(Name) :-
    check_installed(Name), !,
    report(ok, Name, installed).
ensure_installed(Name) :-
    installed(Name, Actions),
    shell_script(Actions, Command),
    report(run, action, Command),
    shell(Command, Status),
    (   Status =:= 0,
        check_installed(Name)
    ->  report(ok, Name, installed)
    ;   report(fail, Name, install),
        halt(1)
    ).

ensure_file(System) :-
    state(file(System), present, present), !,
    report(ok, System, present).
ensure_file(System) :-
    managed(Repo, System),
    install_actions(Repo, System, Actions),
    shell_script(Actions, Command),
    report(run, action, Command),
    shell(Command, Status),
    (   Status =:= 0,
        file_present(System)
    ->  report(ok, System, present)
    ;   report(fail, System, missing),
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
shell_fragment(run_commit_command(Message), Command) :-
    run_commit_command(Message, Command).

dirname(Path, Dir) :-
    atomic_list_concat(Parts, '/', Path),
    append(DirParts, [_Base], Parts),
    atomic_list_concat(DirParts, '/', Dir).

check_installed(Name) :-
    atomic_list_concat(['command -v ', Name, ' >/dev/null 2>&1'], Command),
    shell(Command, 0).

run_optional(Command) :-
    shell(Command, Status),
    ( Status =:= 0 ; Status =:= 1 ), !.
run_optional(Command) :-
    report(fail, action, Command),
    halt(1).

print_help :-
    writeln('usage: dotfiles [install|status|diff|pull|commit|sync|commands|tree|help]').

report(Status, Subject, Detail) :-
    format('~w ~w ~w~n', [Status, Subject, Detail]),
    flush_output.
