# Effect.ts documentation — annotated analysis

Source: https://effect.website/docs  
Analysis: two rounds, four and four pages.

Round 1 pages: getting-started/why-effect, getting-started/the-effect-type,
concurrency/fibers, error-management/expected-errors.  
Round 2 pages: building-pipelines, requirements-management/layers,
stream/introduction, scheduling/schedule-combinators.

Each passage is quoted exactly from the live page and tagged with the move
it demonstrates. Tags map to the named moves in SKILL.md.

---

## effect.website/docs/getting-started/why-effect — Why Effect?

**Name the insight** — one sentence, no hedge:

> "Effect's major unique insight is that we can use the type system to
> track **errors** and **context**, not only **success** values."
>
> — Introduction section

The sentence names the insight ("track errors and context in the type"),
attributes it to the library ("Effect's"), and quantifies what was missing
before ("not only success values"). No "arguably", no "in a sense", no
"one might say". The claim is stated as a fact and then demonstrated.

The word "major" does work here — it ranks this insight above the other
things Effect does, directing the reader's attention. That is different
from enthusiasm markers like "powerful" or "elegant", which are
unanchored adjectives. "Major" here means: of the several insights,
this is the load-bearing one.

**Causal narrative** — the full shape: situation → why the obvious fix
fails → the actual fix:

Situation (the problem):

> "Based on the types, we have no idea that this function can throw an
> exception. We can only find out by reading the code."
>
> — Analyzing the problem section

Why the obvious fix fails:

> "Often, we will do the 'easiest' thing and just wrap the function in a
> `try/catch` block. This is a good first step to prevent your program
> from crashing, but it doesn't make it any easier to manage or understand
> our complex application/library."
>
> — Analyzing the problem section

The actual fix: the section then introduces `Effect<number, Error, never>`,
where the error type appears in the signature. The reader arrives at the
type already understanding why `try/catch` wasn't enough.

The critical sentence is: "This is a good first step to prevent your
program from crashing, *but* it doesn't make it any easier to manage."
Conceding that try/catch is a good first step makes the limitation more
credible, not less. This is the causal narrative move at its most precise:
it does not dismiss the obvious fix; it explains why the obvious fix hits
a ceiling.

---

## effect.website/docs/getting-started/the-effect-type — The Effect Type

**Pre-teach the structure** — write the shape in prose before showing the
type:

> "The `Effect` type is a description of a workflow or operation that is
> **lazily** executed."
>
> — Introduction

The emphasis on "lazily" is precise: Effect values describe computations
without running them. The type signature (`Effect<Success, Error,
Requirements>`) appears after this sentence. The reader arrives at the
three-parameter type already knowing what it describes (a lazy
description) rather than reading the parameters cold.

A second pre-teaching moves one paragraph later:

> "An `Effect` can be executed by the Effect Runtime System, which
> interprets it into actual interactions with the external world."
>
> — Introduction

This pairs with the lazy-description sentence to give the full lifecycle:
define (lazy) → execute (runtime). The reader has the two-phase mental
model before any code example shows either phase.

**Definitional contrast** (subtler than the fibers page):

> "However, effects are not actually functions. They can model
> synchronous, asynchronous, concurrent, and resourceful computations."
>
> — Introduction

The contrast is between "function" (what it looks like to a reader
familiar with functional programming) and "effect value" (what it actually
is). The sentence "they can model synchronous, asynchronous, concurrent,
and resourceful computations" expands the scope beyond what a plain
function covers — which is the point. This is definitional contrast by
negation: X is not Y, and here is the dimension Y cannot reach.

---

## effect.website/docs/concurrency/fibers — Fibers

**Definitional contrast** — the clearest example in this corpus:

> "An `Effect` is a higher-level concept that describes an effectful
> computation. It is lazy and immutable, meaning it represents a
> computation that may produce a value or fail but does not immediately
> execute. A fiber, on the other hand, represents the running execution of
> an `Effect`. It can be interrupted or awaited to retrieve its result."
>
> — Introduction

The grammatical structure is deliberate: four sentences in two pairs, each
pair carrying one term. The first pair defines Effect (higher-level,
lazy, immutable, represents-but-does-not-execute). The second pair defines
fiber (running execution, can be interrupted or awaited). "On the other
hand" is the only transition; the structure does the rest.

The contrast is along three dimensions simultaneously:
- abstraction level (higher-level concept vs. running execution)
- temporality (represents vs. executes)  
- control (immutable vs. interruptible/awaitable)

A paragraph that listed these dimensions would take twice the space and
land half the force. The parallel sentence structure carries all three
contrasts at once.

**Pre-teach the structure** — before showing how to create fibers:

> "All effects in Effect are executed by fibers. If you didn't create the
> fiber yourself, it was created by an operation you're using (if it's
> concurrent) or by the Effect runtime system."
>
> — Introduction

The reader who didn't know fibers existed is told: you've been using them
all along. This reframes the concept from "new thing to learn" to
"name for something you already rely on." The page then shows how to
create fibers explicitly. The reader arrives there already holding the
context.

---

## effect.website/docs/scheduling/schedule-combinators — Schedule Combinators

**Causal narrative** — the best paragraph in the Effect.ts corpus:

> "When a resource is out of service due to overload or contention,
> retrying and backing off doesn't help us. If all failed API calls are
> backed off to the same point of time, they cause another overload or
> contention. Jitter adds some amount of randomness to the delay of the
> schedule. This helps us to avoid ending up accidentally synchronizing
> and taking the service down by accident."
>
> — Jitter section

The shape: situation ("resource is out of service due to overload") →
why the obvious fix fails ("retrying and backing off doesn't help") →
mechanism of the failure ("all failed API calls are backed off to the
same point of time, they cause another overload") → the actual fix
("Jitter adds some amount of randomness") → why the fix works ("avoid
ending up accidentally synchronizing").

This paragraph is structured like a proof, not a list of features. The
reader cannot arrive at "use jitter" without first understanding why
exponential backoff alone is insufficient. That understanding is not
assumed — it is built in four sentences.

The phrase "taking the service down by accident" is the closest this
paragraph gets to tone. It names the consequence of the failure
concretely (the service goes down) and qualifies it ("by accident") to
distinguish this from intentional load. Both words do real work.

---

## Cross-page observations

**Density and trust** — Effect.ts documentation trusts the reader more
than most technical writing does. The why-effect page does not explain
what a type system is or what exceptions are. It assumes the reader knows
TypeScript and starts from there. Precision aimed at the right reader
lands harder than precision that pauses to explain what it doesn't need
to explain.

**Named concepts travel** — once "Effect value" is defined as a lazy
description, the term is reused without re-definition across every
subsequent page. The fibers page can say "running execution of an Effect"
because "Effect" already has a fixed meaning. This is the benefit of
the pre-teach move: terms earn their subsequent uses.

**Contrast as the primary teaching mode** — across the corpus, Effect.ts
introduces new concepts most often by contrast (Effect vs. function,
Effect vs. fiber, tracked errors vs. untracked exceptions). The reader's
existing mental model is the scaffold; the new concept is stated as the
way that scaffold is wrong or incomplete. This is the opposite of
definition-first: it starts from what the reader already knows and
describes how the new thing departs from it.

**What the corpus avoids** — across all eight pages analyzed: no "Note
that", no "It's worth mentioning", no "importantly", no "simply", no
"easily". Hedging preambles are absent. The equivalent function is
performed by concrete examples and by stating the thing directly.
