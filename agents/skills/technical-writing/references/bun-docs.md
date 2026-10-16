# Bun documentation — annotated analysis

Source: https://bun.sh/docs  
Analysis: two rounds, five pages each.

Round 1 pages: index, installation, runtime/modules, bundler, quickstart.  
Round 2 pages: SQLite, file I/O, HTTP server, test runner, CLI reference.

Each passage is quoted exactly from the live page and tagged with the move
it demonstrates. Tags map to the named moves in SKILL.md.

---

## bun.sh/docs — Index page

**Closing rhythm** — three sentences, each depending on the one before,
the last landing the point:

> "But most JavaScript programs don't run in a vacuum. They need a way to
> access the outside world to perform useful tasks. This is where *runtimes*
> come in."
>
> — "What is a runtime?" section

Read it aloud. The first sentence establishes the prior claim (vacuum).
The second names the consequence (outside world). The third names the
concept (runtimes). Each sentence makes the next one possible; the third
only lands because the first two built toward it. This is the opposite of
a list of three parallel openers: it converges.

**Dry measurement** — the ratio does the work:

> "Install packages up to 30x faster than npm with a global cache and
> workspaces"
>
> — Package Manager card

No adjectives. No enthusiasm. The multiple and the mechanism ("global
cache") say what needs to be said.

---

## bun.sh/docs/runtime/modules — Module Resolution

**Epistemic honesty** — name the difficulty honestly before claiming a
solution, then name it again:

> "Module resolution in JavaScript is a complex topic.
>
> The ecosystem is currently in the midst of a years-long transition from
> CommonJS modules to native ES modules. TypeScript enforces its own set of
> rules around import extensions that aren't compatible with ESM. Different
> build tools support path re-mapping via disparate non-compatible
> mechanisms.
>
> Bun aims to provide a consistent and predictable module resolution system
> that works out of the box. Unfortunately it's still quite complex."
>
> — Opening section

The structure is: name the difficulty → enumerate its causes → promise a
solution → immediately caveat the promise. The caveat after the promise
("Unfortunately it's still quite complex") is what earns trust. Prose that
promises without caveating reads as marketing; prose that qualifies the
promise reads as honest.

The third paragraph could have stopped at "works out of the box." It
didn't. That one extra sentence — "Unfortunately it's still quite complex"
— is the epistemic honesty move. It costs nothing and earns everything.

---

## bun.sh/docs/bundler — Bundler

**Problem before solution** — state the problem in enough detail that the
API feels inevitable when it arrives:

> "Why bundle?
>
> The bundler is a key piece of infrastructure in the JavaScript ecosystem.
> As a brief overview of why bundling is so important:
>
> **Reducing HTTP requests.** A single package in `node_modules` may
> consist of hundreds of files, and large applications may have dozens of
> such dependencies. Loading each of these files with a separate HTTP
> request becomes untenable very quickly, so bundlers are used to convert
> our application source code into a smaller number of self-contained
> 'bundles' that can be loaded with a single request.
>
> **Code transforms.** Modern apps are commonly built with languages or
> tools like TypeScript, JSX, and CSS modules, all of which must be
> converted into plain JavaScript and CSS before they can be consumed by a
> browser. The bundler is the natural place to configure these
> transformations."
>
> — "Why bundle?" section

The API (`bun build`, `Bun.build()`) appears before this section. But the
"Why bundle?" explanation is placed here, between the at-a-glance summary
and the first code example. The reader who skips the why-section skips it
willingly; the reader who reads it arrives at the example already wanting
to bundle.

The key sentence is: "A single package in `node_modules` may consist of
hundreds of files, and large applications may have dozens of such
dependencies." That's the problem stated concretely — not "bundling improves
performance" but the specific mechanism (file count × dependency depth ×
HTTP requests) that makes it untenable.

**Dry measurement** — performance stated without enthusiasm:

> "It's fast. The numbers below represent performance on esbuild's
> three.js benchmark."
>
> — Opening section

Two sentences. The first is a claim. The second is the evidence source.
No exclamation. No adjectives. The benchmark chart follows.

---

## bun.sh/docs/api/sqlite — SQLite

**Dry measurement** — concrete ratio, no commentary:

> "The `bun:sqlite` module is roughly 3-6x faster than `better-sqlite3`
> and 8-9x faster than `deno.land/x/sqlite` for read queries. Each driver
> was benchmarked against the Northwind Traders dataset."
>
> — Introduction section

Named competitors. Named dataset. Range rather than a single number
("3-6x") conveys honest measurement. No adjectives follow the numbers.

**Negative framing for deferred operations** — the canonical example in
this corpus:

> "At this stage, we haven't inserted any cats! The call to
> `db.transaction()` returns a new function (`insertCats`) that *wraps*
> the function that executes the queries."
>
> — Transactions section

This sentence appears immediately after the transaction is defined and
immediately before the explanation of how to execute it. Its work is to
name the moment: the function is wrapped but not called; the cats are
defined but not inserted. Without this sentence a reader might assume the
transaction ran at definition time — the most common mental-model error
with lazy or higher-order APIs.

The same move appears a few paragraphs earlier, more quietly:

> "Use the `db.query()` method on your `Database` instance to prepare a
> SQL query. The result is a `Statement` instance that will be cached on
> the `Database` instance. *The query will not be executed.*"
>
> — Statements section

"*The query will not be executed.*" — four words that prevent the most
common mistake. Italicized for emphasis, not because the sentence needs
the italics to land (it doesn't), but the page uses this convention for
notes. The sentence itself is the move.

**Causal narrative** — used more quietly here than in Effect.ts, but
present in the WAL section:

> "In WAL mode, writes to the database are written directly to a separate
> file called the 'WAL file' (`-wal`). A shared-memory index file (`-shm`)
> is also created for read coordination. The WAL file will be later
> integrated into the main database file. Think of it as a buffer for
> pending writes."
>
> — WAL mode section

Situation (WAL mode creates two files) → mechanism (buffer for pending
writes) → consequence (needs cleanup). The cleanup instructions follow.
The reader arrives at the cleanup step already understanding why it is
needed.

---

## Cross-page observations

**What Bun does not do** — the index avoids vague connectives throughout.
"Bun processes start 4x faster than Node.js" names the specific effect,
not "Bun enables faster development." The bundler page says "Loading each
of these files with a separate HTTP request becomes untenable very
quickly," not "the bundler improves performance."

**Formatting as a teaching tool** — the index card grid previews the four
tools (runtime, package manager, test runner, bundler) before the prose
explains them. The reader arrives at "What is Bun?" already holding a
four-part structure. This is the pre-teach move applied to page layout,
not prose.

**Tone** — technical, dry, not cold. The SQLite page refers to cats. The
quickstart begins with a friendly "Hello world in minutes." These are
intentional warmth injections that do not use enthusiasm markers; they use
concrete images instead.
