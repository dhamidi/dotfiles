# stdxml application

This reference applies to `/Users/dhamidi/projects/stdxml` and repositories with
the same contracts. Its prefix is `stdxml` / `STDXML`. Read current `AGENTS.md`,
`DEVELOPMENT.md` and relevant headers; these notes do not replace them.

- Internal cross-file identifiers use `stdxml__`; public identifiers use
  `stdxml_`; macros/enums use `STDXML_`. File-local functions remain static.
- Library code uses the fixed-width aliases and freestanding headers only.
- Fallible internal functions retain `STDXML_MUST_USE`, `stdxml__result` and
  explicit propagation. New normative functions/comments cite their spec owner.
- R4: pointer-bearing argument/result structures end in `_call_scoped` and have
  a lifetime comment. They can contain other call-scoped views. Persistent
  structs cannot contain these types or their pointers disguised as integers.
  Preserve existing arena/allocator/vtable exceptions.
- R18: validate and allocate before visible mutation. R19: preserve fuel
  reservations and bounded work. A parameter cleanup does not authorize new
  algorithms, costs, streaming latency or scheduling policies.
- R21: public operations validate engine, typed handles, lengths and all required
  pointers before access/mutation. Grouping must not bypass these checks.
- Every operational build/check command goes through `cc -o build build.c` and
  `./build <command>`. New scoped commands must preserve existing gates.
- Public interface changes need `docs/API_CHANGES.md` entries. Internal borrowed
  views do not enter `include/stdxml.h`.
- Generated tables are changed through their generators and verified for byte
  identity. Golden fixtures come only from oracle tooling, never this refactor.
- `docs/PARAMETER_INTERFACES.md` documents permanent parameter enforcement and
  scoped commands. Agree validation scope for each new task; the completed
  migration's scoped policy is not a standing exemption from normal gates.
  Keep all existing tests intact and disclose omitted checks.

The allocator contract prescribed in AGENTS.md is an explicit exception candidate
for `resize` (five parameters) and `deallocate` (four). Inventory the typedefs,
fields and implementing functions exactly. `allocate` already has three.
Project-owned panic and comparator callbacks need design review and migration,
not an automatic exception for every vtable function.
