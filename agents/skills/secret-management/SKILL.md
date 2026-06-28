---
name: secret-management
description: Dario's secret-access setup on this machine. ALL secrets/API keys/tokens/credentials are retrieved through fnox (backed by 1Password via the op CLI) — never read raw values, hardcode them, or invent env-var plumbing. Use whenever a task needs a secret, API key, token, password, or credential; when reading/writing fnox.toml or fnox/1Password/op config; or when a command fails for lack of a secret. A project's own fnox.toml overrides these defaults.
tools: Read, Edit, Write, Bash
---

# Secret Management (fnox + 1Password)

On this machine, **every secret is accessed through [fnox](https://fnox.jdx.dev)**, which resolves
references from **1Password** via the `op` CLI. Do not bypass this:

- ❌ Do NOT call `op read`/`op item get` directly to fetch a secret for app/runtime use.
- ❌ Do NOT hardcode secrets, paste them into files, or write `.env` files with real values.
- ❌ Do NOT print a secret's value unless the user explicitly asks.
- ✅ DO retrieve secrets with `fnox get <KEY>` or inject them with `fnox exec -- <cmd>`.
- ✅ DO add new secrets as *references* (never the literal value) into a `fnox.toml`.

**Project override rule:** if the working directory (or a parent) contains a `fnox.toml`, that
project's config wins — its `[providers.*]`, `vault`, `account`, and `[secrets]` take precedence
over the personal defaults below. Always run `fnox config-files` first to see what's in effect.

## The environment (personal defaults)

- `fnox` (by @jdx) and `op` (1Password CLI) are installed via mise.
- Global fnox config: `~/.config/fnox/config.toml` defines the `1password` provider.
- `OP_ACCOUNT=my.1password.eu` is exported from `~/.profile` (default 1Password account).

### Registered 1Password accounts

| Role | Sign-in address | Email | Default? |
|------|-----------------|-------|----------|
| **Personal** | `my.1password.eu` | dario.hamidi@gmail.com | ✅ yes |
| Work | `ampcode.1password.com` | dario@ampcode.com | no |

### Vaults

- **Personal** vault (`my.1password.eu` account) is the default fnox vault. Short secret
  references resolve against it.
- Work account (`ampcode.1password.com`) vaults: **Employee** (your private work vault) and
  **Shared** (team-shared). Use **Employee** as the work default.
- For any other account/vault, use a full `op://` URI or set `account`/`vault` on the provider.

## How to use it

```bash
fnox list                       # show declared secrets (TUI: fnox tui)
fnox get RUBYGEMS_API_KEY        # print one resolved secret
fnox exec -- npm publish         # run a command with all secrets injected as env vars
fnox config-files                # which configs are loaded (project > home > global)
```

### Declaring a new secret

A secret is an env-var name mapped to a 1Password reference. Reference forms:

- `"Item/field"` — short form, resolves in the provider's default vault (Personal).
- `"op://VAULT/Item/field"` — full URI, reaches any vault/account.

Edit the relevant `fnox.toml` (project's if present, else `~/fnox.toml`):

```toml
[secrets]
RUBYGEMS_API_KEY = { provider = "1password", value = "Rubygems/password" }
OPENAI_API_KEY   = { provider = "1password", value = "op://Personal/OpenAI/credential" }
```

Or from the CLI (writes a reference, not the value):

```bash
fnox set OPENAI_API_KEY --provider 1password --key-name "OpenAI/credential"
```

### Pointing a secret at the Work account

```toml
[providers.work]
type = "1password"
account = "ampcode.1password.com"
vault = "Employee"   # or "Shared" for team-shared items

[secrets]
WORK_TOKEN = { provider = "work", value = "Some Item/credential" }
```

## Known gotchas (don't be alarmed)

- **`fnox provider test` and `op whoami` may report "account is not signed in."** This is a CLI
  *session* concept, separate from secret reads. Actual `fnox get` / `op read op://...` work fine
  because the unlocked 1Password **desktop app** authorizes each read. Do not "fix" this by
  changing the account config. To get a real CLI session, the user runs `op signin` — it is not
  required for fnox to function.
- **The TUI only lists *declared* secrets**, it is not a vault browser. An empty Secrets pane
  (`Loaded: 0 | Total: 0`) means no `[secrets]` are defined in any loaded config — add them.
- **Multiple accounts are signed in**, so bare `op` commands need the account. `OP_ACCOUNT` (set in
  `~/.profile`) supplies the personal default; pass `--account` for the work account.
