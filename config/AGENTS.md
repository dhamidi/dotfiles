# Global Agent Guidance

<!-- Source of truth for agent guidance on this machine.
     Read by Amp as AGENTS.md and by Claude Code via the CLAUDE.md symlink.
     Managed with `agents` (~/.local/bin/agents); run `agents sync` after edits. -->

Machine-wide tooling conventions. Project-level `AGENTS.md`/`mise.toml` override these.

## Tool installation

- Install developer tools with **mise**; fall back to **brew** only when a tool isn't
  available through mise.
- Prefer **machine-wide** installation (`mise use -g <tool>`) over per-project.
- Install missing tools **proactively** — if a needed tool is absent, install it rather
  than asking or working around it.

## Secrets

- Manage and access all secrets with **fnox** (backed by 1Password). Never read raw
  values, hardcode secrets, or hand-write `.env` files with real values.
- See the **secret-management** skill for accounts, vaults, and exact commands.

## Languages & runtimes

- **bun** — run and execute JavaScript and TypeScript (`bun run`, `bun x`, `bun <file>`).
- **pnpm** — package management (install/add/remove dependencies).
- **zig** — the compiler for native code and for compiling to WebAssembly
  (`zig build-exe`, `zig cc`, `-target wasm32-*`).

## Shell & data

- **jq** — use in pipelines to parse, filter, and transform JSON.

## Code search and edits

- Prefer **ast-grep** (`ast-grep`/`sg`) for code-aware search, refactors, and pattern-based edits; use `rg` only for plain text.
- Use patterns like `ast-grep -l ts -p 'function $NAME($$$ARGS) { $$$BODY }'` and rewrites with `-r`, adding `-i` for interactive edits.
- For details, run `ast-grep --help`, `ast-grep run --help`, or see <https://ast-grep.github.io/>.

## Tasks

- **mise is the global task runner.** Define project-specific tasks as mise tasks.
- If a project already has a `mise.toml`, add tasks in **`mise.local.toml`** so they
  merge with the existing config rather than editing `mise.toml` directly.

## Git

- Use **Conventional Commits** for commit messages (`feat:`, `fix:`, `chore:`, …).
- Prefer a **linear history** (rebase over merge; avoid merge commits).

## Skills & agent instructions

- Manage skills and `AGENTS.md` files with the **`agents`** CLI (`~/.local/bin/agents`),
  which keeps them visible to **both Amp and Claude Code**.
- Author guidance in **`AGENTS.md`** (the source of truth) and skills under
  **`.agents/skills/<name>/SKILL.md`** (canonical); `agents` symlinks `CLAUDE.md` and
  `.claude/skills/<name>` to match.
- Use `agents skill <name>` to scaffold a skill and `agents md` to create an `AGENTS.md`
  (both auto-bridge). After editing or adding any of these by hand, run **`agents sync`**.
- `agents status` shows what each tool currently sees; `-g/--global` vs `-p/--project`
  picks the scope.
