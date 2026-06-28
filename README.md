# dotfiles

Shared agent configuration and tooling.

## Getting started

Clone the repo and run `make`:

```sh
git clone https://github.com/dhamidi/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles
make
```

`make` bootstraps SWI-Prolog if needed, then runs the Prolog installer. The installer copies the managed files into place, runs `agents sync`, and asks mise to install the globally configured tools.

## Exploring the installer

Run SWI-Prolog interactively; this only loads the installer predicates and does not install anything by itself:

```sh
swipl -s install.pl
```

Useful queries:

```prolog
print_planned_commands.  % show commands needed to reach the desired state
print_desired_tree.      % show the desired installed file tree
print_tree_diff.         % show present/missing files on this system

desired(Target, DesiredState).
actual(Target, ActualState).
state(Target, DesiredState, ActualState).
satisfied(Target).
planned_command(Target, Command).
desired_file(Path).
missing_file(Path).
present_file(Path).
tree_diff(Path, Status).
```

## Contents

- `Makefile` — bootstrap entrypoint; ensures `swipl` is available and runs the installer
- `install.pl` — Prolog installer engine
- `manifest.pl` — declarative install manifest
- `bin/agents` — helper for managing AGENTS.md files and skills
- `config/AGENTS.md` — global agent guidance
- `agents/skills/` — global agent skills
- `mise/config.toml` — global mise tool configuration
