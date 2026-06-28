file('bin/agents', 'mkdir -p ~/.local/bin && cp bin/agents ~/.local/bin/agents && chmod +x ~/.local/bin/agents').
file('config/AGENTS.md', 'mkdir -p ~/.config && cp config/AGENTS.md ~/.config/AGENTS.md').
file('agents/skills/secret-management/SKILL.md', 'mkdir -p ~/.agents/skills && cp -R agents/skills/. ~/.agents/skills/').
file('mise/config.toml', 'mkdir -p ~/.config/mise && cp mise/config.toml ~/.config/mise/config.toml').
installed('agents', '~/.local/bin/agents sync').
installed('mise', 'mise install -g').
