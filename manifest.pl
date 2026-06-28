file('bin/agents', '~/.local/bin/agents', [copy_file, chmod_exec]).
file('bin/dotfiles', '~/.local/bin/dotfiles', [copy_file, chmod_exec]).
file('config/AGENTS.md', '~/.config/AGENTS.md', [copy_file]).
file('agents/skills', '~/.agents/skills', [copy_tree]).
file('mise/config.toml', '~/.config/mise/config.toml', [copy_file]).

installed('agents', [run('~/.local/bin/agents sync')]).
installed('mise', [run('mise install -g')]).
