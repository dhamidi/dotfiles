file('bin/agents', [
    copy_file('bin/agents', '~/.local/bin/agents'),
    chmod_exec('~/.local/bin/agents')
]).

file('config/AGENTS.md', [
    copy_file('config/AGENTS.md', '~/.config/AGENTS.md')
]).

file('agents/skills/secret-management/SKILL.md', [
    copy_tree('agents/skills', '~/.agents/skills')
]).

file('mise/config.toml', [
    copy_file('mise/config.toml', '~/.config/mise/config.toml')
]).

installed('agents', [
    run('~/.local/bin/agents sync')
]).

installed('mise', [
    run('mise install -g')
]).
