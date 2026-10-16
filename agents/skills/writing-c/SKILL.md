---
name: writing-c
description: Write or refactor C interfaces with at most three parameters, meaningful argument groups, explicit ownership, and compiler-driven validation. Use for C function design, implementation, and structural signature migrations.
---

# Writing C

Write interfaces whose argument groups express a domain concept and a lifetime.
Keep every project-owned C function and function-pointer signature at three
parameters or fewer, including state, fuel, and output parameters. A required
external callback signature may have an exact, documented exception; callbacks
owned by the project follow the limit.

Read the project's instructions and current contracts before selecting types.
Use its prefix, type conventions, error model, and build entry point. The
`stdxml` examples in the references illustrate the design; adapt their names and
storage restrictions to the actual project.

## Select the grouping

Read [parameter groups](references/parameter-groups.md) when designing or
replacing a signature. Choose among buffer views, initialization configurations,
stream transfers, semantic keys, borrowed dependency views, transactions,
outcomes, control operations, and test execution plans.

- Prefer `owner, operation, output` when all three are needed.
- Prefer `owner, configuration, fuel` for initialization without another result.
- Leave an already-clear signature alone when it fits the limit.
- Reuse an existing domain type before creating another description of it.
- Use designated initializers for grouped arguments. Spell identifiers out.
- Separate input descriptions from outputs; keep outputs last when the project
  uses out-parameters. Identify intentional in/out state explicitly.
- Do not move unrelated arguments into a generic context merely to pass lint.
- Do not move call-local pointers into persistent objects to shorten signatures.
- State units, buffer validity, aliasing rules, fuel behavior, and output behavior
  on refusal and suspension. Preserve existing semantics during a refactor.

## Change existing code

Read [mechanical refactoring](references/mechanical-refactoring.md) for a
signature migration. Use ast-grep to locate and rewrite C structure. Check the
match inventory and preview the rewrite before applying it. Review indirect
calls, callback assignments, macros, and expressions with side effects.

Use the compiler to find missed declarations, call sites, and callback types.
Type checking does not prove argument order, lifetime, restartability, or
behavioral equivalence: review the old-to-new field mapping and run targeted
existing behavioral checks when those risks occur.

For this repository, also read [stdxml contracts](references/stdxml.md). Use
`docs/PARAMETER_INTERFACES.md` for the permanent parameter contract and verification
commands. Agree the validation budget for each new task. Do not treat this skill
as authorization to commit, push, change existing gates, or run expensive suites.
