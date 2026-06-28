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

## Contents

- `Makefile` — bootstrap entrypoint; ensures `swipl` is available and runs the installer
- `install.pl` — Prolog installer engine
- `manifest.pl` — declarative install manifest
- `bin/agents` — helper for managing AGENTS.md files and skills
- `config/AGENTS.md` — global agent guidance
- `agents/skills/` — global agent skills
- `mise/config.toml` — global mise tool configuration
