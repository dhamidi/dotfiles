---
name: technical-writing
description: Write, revise, and check technical prose. Covers the sequencing and teaching moves that make documentation worth reading — drawn from close analysis of Bun and Effect.ts documentation — paired with a Harper-based shell script for grammar and style checking. Also restructures design documents into RFC-style specifications. Use for new documentation, voice passes on existing prose, prose audits via the Harper script, or rescuing a design document that has grown into an essay.
---

# Technical writing

Good technical prose does one thing: it makes a competent reader finish. Not
a beginner who needs reassurance, and not an expert who needs no explanation
— a peer who hasn't learned this specific thing yet. Everything below is in
service of that reader.

This skill covers three modes:

- **Voice pass** — revise existing prose to cut the tells of machine-written
  text while keeping every earned observation.
- **RFC register** — restructure a design document into a specification an
  implementer can follow.
- **Prose check** — run Harper and pattern-based counts to get a baseline
  before and after edits.

In a literate-programming repo, this skill touches markdown only: code blocks
stay untouched, and the build gate runs after every edit.

---

## The reader contract

The reader is intelligent and hasn't learned this specific thing yet. This
determines every structural choice:

- Explain a concept once, at the right resolution. Trust them to carry it.
- Show *why* before showing *how*. The reader arrives at the API already
  wanting it, or they skim past it.
- Name difficulty honestly. Prose that doesn't oversell earns more trust than
  prose that does.
- Let numbers carry conviction. "28x faster (6ms vs 170ms)" does more work
  than "dramatically faster" or an exclamation mark.

---

## The named moves

Nine moves that recur across the best technical documentation. Each is named
so it can be requested, checked, and improved. Examples are drawn from Bun
and Effect.ts — two projects whose documentation repays close reading.

### Sequencing: how information arrives

**Problem before solution.** Front-load the motivation before showing the
API. The reader who understands the problem arrives at the code already
wanting it.

> Bun's bundler page lists why bundling matters — HTTP request count,
> dependency depth — before showing a single flag. Bun's modules page names
> the complexity of JavaScript module resolution before explaining how Bun
> handles it.

Broken: *"Use `--entrypoint` to specify your app's entry file."*
Fixed: *"A single package in node_modules may consist of hundreds of files,
and loading each with a separate HTTP request becomes untenable quickly.
`--entrypoint` tells Bun where to start."*

**Causal narrative.** For non-obvious behavior — failures, retries,
tradeoffs — follow the reader's reasoning: situation → why the obvious fix
fails → the actual fix.

> Effect.ts scheduling docs: *"When a resource is out of service due to
> overload or contention, retrying and backing off doesn't help us. If all
> failed API calls are backed off to the same point of time, they cause
> another overload or contention. Jitter adds some amount of randomness to
> the delay of the schedule."*

Situation first. The naive solution breaks. Then the concept. This is the
opposite of API-first documentation, and it produces the best paragraph in
the Effect.ts corpus.

### Teaching: how concepts arrive

**Definitional contrast.** Introduce two related terms in back-to-back
sentences with identical grammatical structure. The contrast lands from the
form; no transition prose is needed.

> Effect.ts fibers page: *"An `Effect` is a higher-level concept that
> describes an effectful computation. It is lazy and immutable… A fiber, on
> the other hand, represents the running execution of an `Effect`. It can be
> interrupted or awaited to retrieve its result."*

Same sentence shape, one new clause per sentence. The parallel form carries
the contrast so the prose doesn't have to.

**Pre-teach the structure.** Write the shape of a thing in prose before
showing it as code. The reader arrives at the type signature or schema
already holding its structure.

> Effect.ts: *"a computation that may succeed, fail, or require some
> additional context"* — written before the `Effect<R, E, A>` type is shown.
> The triplet maps directly onto the three type parameters. The prose is
> previewing the signature.

**Name the insight.** One sentence: name the insight, attribute it, quantify
what was missing before, no hedge. No "arguably", no "in a sense".

> Effect.ts: *"Effect's major unique insight is that we can use the type
> system to track errors and context, not only success values."*

Names the insight. Attributes it to the library. Quantifies the gap ("not
only success values"). Done.

### Register: voice and tone

**Closing rhythm.** Three sentences, each building on the previous, the last
landing the point. Not three openers — three closers.

> Bun: *"But most JavaScript programs don't run in a vacuum. They need a way
> to access the outside world to perform useful tasks. This is where runtimes
> come in."*

Each sentence depends on the one before. The rhythm converges rather than
fans out. Read it aloud: the third sentence lands because the first two built
toward it.

**Epistemic honesty.** Name the hard thing honestly before promising a
solution. The admission after the promise is more credible than confidence
that elides the difficulty.

> Bun modules page: *"Module resolution in JavaScript is a complex topic…
> Bun aims to provide a consistent and predictable module resolution system
> that works out of the box. Unfortunately it's still quite complex."*

The promise is real; the caveat is immediate. Readers trust prose that
doesn't oversell.

**Dry measurement.** When something is fast, the number carries the
conviction. Prose stays dry.

> Bun: *"28x faster than npm run (6ms vs 170ms of overhead)"* — no
> adjectives, no exclamation marks. The ratio and the raw numbers say it.

**Negative framing for deferred operations.** Pin down exactly what has
*not* happened yet. Especially for lazy or transactional operations where a
common mistake is assuming something already ran.

> Bun SQLite: *"At this stage, we haven't inserted any cats!"* — immediately
> before the explanation of how `db.transaction()` wraps without executing.
> The negation defines the moment.

---

## The tells to cut

These are the fingerprints of machine-written prose. Find them; fix each by
recovering the plain true sentence underneath.

| Tell | What it looks like | The fix |
|------|-------------------|---------|
| **"X, not Y" antithesis** | "a test, not a demo"; "named fields, not opaque bytes" | State the thing it implies. "A hundred thousand actors surfaces bugs a handful never will." |
| **Em-dash as pivot** | a dash where a period or comma belongs; often two per sentence | Restructure. Most dash-pivots want a full stop. A dash earns its place only for a genuine aside. |
| **Back-to-back tricolons** | three matched beats, then three more a line later | One list of three is fine. Break the rhythm when it repeats. |
| **Italic reveal** | "the production seam *is* the test seam" | Drop the italics and let the sentence land. If it needs the emphasis, the sentence is wrong. |
| **Hedging preamble** | "It's worth noting", "Importantly", "Generally speaking" | Delete. The point either stands or it does not. |
| **Explain-three-times** | the same idea restated at rising resolution across a paragraph | Explain it once, at the right resolution. Trust the reader. |
| **Marketing grandeur** | "this is how it is made to show its work" | Cut to the claim, or cut entirely. |
| **Over-signposting** | "the heart of it", "the whole point", "the elegance is that" | Show the thing; let the reader judge what is central. |
| **Vague connective verbs** | "Effect *allows* you to…", "this *enables* composition" | Name the specific effect. "Effect tracks errors in the type, so the compiler rejects unhandled failures." |
| **Benefits list** | **Readability.** **Code Organization.** **Type Safety.** | No contrast, no example, no tension. Either show the property in action or cut it. |
| **Enthusiasm markers** | "easily!", "simply!", "powerful!" | Remove. The measurement or the contrast does this work instead. |

---

## The operative test

For every flourish, ask one question:

> Could this device decorate any sentence, or is it true to this exact thing?

`fsync() with the covers off` describes only fsync, so it stays. `a test,
not a demo` is a reusable antithesis that could dress up any noun, so it
goes — replaced by the concrete reason it was gesturing at. Earned whimsy
survives. Templates do not.

---

## What to keep

Do not flatten the voice. Keep any image that passes the operative test:
specific to its subject, in a human voice, surprising because it is true.
Examples worth protecting: "shutdown by geometry", "Readiness nests like
Russian dolls", "the index-enum class of bug is structurally extinct",
"the wrench left no trace". The goal is fewer flourishes, each earned,
so the surviving voice reads sharper than the padded original did.

---

## The RFC register

The voice pass fixes sentences. When a document is a *specification* an
implementer must follow, its structure matters as much as its prose, and a
heavier mode applies. Reach for it when asked to make a document read like
an RFC, to present technical detail clearly, or when a design has grown into
one long essay that buries its rules. A freshly authored RFC must clear this
bar too: technically airtight but unreadable by a newcomer has failed.

This mode MAY restructure: reorder sections, weave definitions into the prose
where they are first needed, move a worked example to an appendix, turn a
paragraph of obligations into a table. It still never changes a technical
claim, and it still leaves code semantics alone.

The conventions, drawn from the IETF RFC tradition:

- **Open with an abstract.** Two or three sentences naming what the document
  specifies, before any history or motivation.
- **Mark a binding rule, sparingly.** Where a requirement truly constrains
  an implementer, a capitalized MUST or SHOULD says so more precisely than
  "needs to" or a bare "should". Spend them on the few rules that bind.
- **Introduce terms gradually, in prose.** Define each term in the sentence
  that first needs it, then reuse it freely. A glossary up front reads like
  a data sheet and stalls the reader before the ideas begin. Run a
  *first-use audit*: list every domain term, identifier, and named example;
  confirm each is defined before its first load-bearing use.
- **Give sections descriptive titles and stable anchors; do not number
  them.** In a literate document, prose order is not assembly order and
  sections move, so a number that read "Section 8" yesterday is wrong today.
- **Set the load-bearing rule apart.** One normative sentence in a blockquote
  carries more than the same sentence inside a paragraph.
- **Put structured detail in a table.** An interface's callbacks, a wire
  layout's fields, an option matrix. A table is read faster than the prose
  that would list the same rows.
- **Label parallel bullets.** When several cases share a shape, lead each
  with a bold term so the list scans.
- **Move the worked example to an appendix.** The normative body states the
  rules; the appendix shows them running. Keeping the example out of the body
  lets a reader find a rule without reading a story.

The two modes compose. Restructure into the RFC shape first, then run the
voice pass over the prose that remains.

---

## Checking prose with Harper

Harper is a Rust-based grammar checker with ~270 rules covering agreement,
homophones, wrong prepositions, filler words, weasel words, hedging, long
sentences, and idiom errors. It runs in under a millisecond per file.

Install harper-cli via mise (the project's tool version manager):

```sh
mise use --global harper-cli
```

The skill ships a user dictionary at `references/dictionary.txt` that
suppresses false positives for domain vocabulary (`C99`, `IO`, `lifecycle`,
and similar). When Harper flags a word that is correct technical usage, add
it to the dictionary — never silence the lint by removing the rule.

The script below is the project's `prose-check`. Run it before and after
every voice pass; the before-counts are the baseline, the after-counts show
what moved. Running it is not optional: a review without a before-count has
no baseline to compare against.

```sh
#!/usr/bin/env sh
# prose-check — grammar and style audit for technical writing
# Usage: sh prose-check FILE [FILE ...]
#
# Requires harper-cli (mise use --global harper-cli).
# Dictionary: .claude/skills/technical-writing/references/dictionary.txt

# Resolve the skill dictionary relative to the project root.
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)/.claude/skills/technical-writing"
DICT="$SKILL_DIR/references/dictionary.txt"

for FILE in "$@"; do
  printf '\n══ %s ══\n' "$FILE"

  # Harper covers grammar, agreement, homophones, wrong prepositions,
  # filler words, weasel words, hedging, long sentences, and ~260 more rules.
  printf '\nGrammar (Harper):\n'
  if command -v harper-cli >/dev/null 2>&1; then
    if [ -f "$DICT" ]; then
      harper-cli lint --user-dict-path "$DICT" "$FILE" || true
    else
      harper-cli lint "$FILE" || true
      printf '  (no dictionary found at %s)\n' "$DICT"
    fi
  else
    printf '  harper-cli not found — install: mise use --global harper-cli\n'
  fi

  # Style tells: these should approach zero.
  # Em-dashes have a budget (~2 per 250-word page); the rest have no budget.
  printf '\nStyle tells (should approach zero):\n'
  printf '  em-dashes        %3d  (budget: ~2 per page)\n' \
    "$(grep -o '—' "$FILE" 2>/dev/null | wc -l | tr -d ' ')"
  printf '  "X, not Y"       %3d\n' \
    "$(grep -oE ', not [a-z]' "$FILE" 2>/dev/null | wc -l | tr -d ' ')"
  printf '  italic reveals   %3d  (*is* / *are* / *was*)\n' \
    "$(grep -oE ' \*(is|are|was|were)\* ' "$FILE" 2>/dev/null | wc -l | tr -d ' ')"
  printf '  hedging preamble %3d  (worth noting / importantly / note that)\n' \
    "$(grep -oiE "(worth noting|importantly,|note that|keep in mind|recall that)" \
       "$FILE" 2>/dev/null | wc -l | tr -d ' ')"
  printf '  "in order to"    %3d  -> "to"\n' \
    "$(grep -oiE 'in order to' "$FILE" 2>/dev/null | wc -l | tr -d ' ')"

  # These are not always wrong — apply the operative test.
  printf '\nInvestigate (not always wrong — apply the operative test):\n'
  printf '  allows/enables   %3d  vague connective: name the specific effect\n' \
    "$(grep -oiE '\b(allows|enables|permits)\b' "$FILE" 2>/dev/null | wc -l | tr -d ' ')"
  printf '  there is/are     %3d  check: is the real subject buried?\n' \
    "$(grep -oiE '\bthere (is|are|was|were)\b' "$FILE" 2>/dev/null | wc -l | tr -d ' ')"
  printf '  benefits bullets %3d  bold term + period with no contrast or example\n' \
    "$(grep -oE '^\*\*[^*]+\*\*\.' "$FILE" 2>/dev/null | wc -l | tr -d ' ')"

  printf '\n'
done
```

Harper catches the errors; the pattern counts catch the tells. Together they
give a baseline that makes "before vs. after" concrete.

---

## Workflow

Three rounds. Complete each before moving to the next.

### Round 1 — Baseline and structure

1. **Run `sh prose-check FILE` and record every count.** This is the before
   state. Do not skip this step; without a before-count the after-count proves
   nothing. In the RFC register, also run the first-use audit: list domain
   terms and confirm each is defined before its first load-bearing use.

2. If the document is a specification, apply the RFC register first: reorder
   sections, extract definitions, move worked examples to an appendix, replace
   obligation paragraphs with tables. Leave fenced code blocks and `<a id>`
   anchors untouched.

3. Re-run the build gate in a literate repo to confirm the restructure didn't
   disturb a tangle:
   ```sh
   ./mdc check FILE.md
   ```

### Round 2 — Voice pass

4. Read the document once through without editing. Mark every tell and every
   passage that doesn't pass the operative test.

5. Edit each flagged passage. Recover the plain true sentence underneath the
   tell and write it in place. Check the named moves: is the problem stated
   before the solution? Does a causal narrative precede the API? Are concepts
   introduced by contrast or by pre-teaching the structure?

6. Keep meaning byte-for-byte true. When a rewrite would change a technical
   claim, stop and flag it rather than proceeding.

### Round 3 — Verify

7. **Re-run `sh prose-check FILE` and show the counts alongside the before
   state.** Em-dashes must be within budget; "X, not Y" and italic reveals
   must approach zero. A review that omits the after-count is not complete.

8. In a literate repo, rebuild and recompile after prose edits:
   ```sh
   ./mdc tangle SRC.md OUT && cc -std=c99 -Wall -Wextra -pedantic -Werror -c OUT -o /dev/null
   ```

9. Read the document aloud in your head. If a sentence sounds like it is
   reaching, it is. Apply the operative test to every surviving flourish.

---

## Cautions

- Never edit inside fenced code blocks or inline code spans.
- Preserve every `<a id>` anchor and every link target.
- Keep technical claims byte-for-byte true. This is a voice pass, not a fact
  edit. When a rewrite would change a claim, stop and flag it.
- In the RFC register: reorder sections and recast prose into tables freely,
  but preserve every anchor and verify the build gate after, since a restructure
  touches more of the file than a sentence edit.
- Apply the skill to its own output. The prose this skill produces should pass
  the operative test too.

---

## References

The named moves and tell taxonomy were derived from close reading of the
following documentation corpora, two rounds each with different page subsets:

**Bun documentation** — https://bun.sh/docs  
Pages analyzed: index, installation, runtime/modules, bundler, quickstart
(round 1); SQLite, file I/O, HTTP server, testing (round 2).  
Moves grounded here: problem before solution, closing rhythm, epistemic
honesty, dry measurement, negative framing for deferred operations.  
Annotated analysis with exact quotes: `references/bun-docs.md`

**Effect.ts documentation** — https://effect.website/docs  
Pages analyzed: why-effect, getting-started/the-effect-type, concurrency/fibers
(round 1); error-management/expected-errors, building-pipelines, requirements-
management/layers, stream/introduction, scheduling/schedule-combinators (round 2).  
Moves grounded here: definitional contrast, pre-teach the structure, name the
insight, causal narrative.  
Annotated analysis with exact quotes: `references/effect-ts-docs.md`

**Harper grammar checker** — https://github.com/Automattic/harper  
272 lint rules in Rust, covering agreement, homophones, wrong prepositions,
idiom errors, filler words, weasel words, hedging, and long sentences.
Implementation: Brill tagger + ExprLinter pattern expressions over enriched
token sequences. The prose-check script uses `harper-cli lint`.

**Pacer, M. and Suchow, J.** "Linting science prose and the science of prose
linting." *Proceedings of the 15th Python in Science Conference (SciPy)*, 2016.  
https://suchow.io/assets/docs/pacer2016proselint.pdf  
Benchmark: proselint yields 1 false positive per 10 true positives; Microsoft
Word yields 2 false positives per 1 true positive. Cited for precision/recall
tradeoffs in rule-based prose checking. Also documents domain-context blindness
as a structural limit: the same rule fires correctly in one genre and
incorrectly in another.

**RAND Corporation.** "Contributions to Research on Automated Writing Scoring
and Feedback Systems." Research brief RBA1062-1.  
https://www.rand.org/pubs/research_briefs/RBA1062-1.html  
Finding: AES systems "rarely provide guidance for substantive aspects of
writing." Scores reflect measurable proxies (lexical diversity, sentence
length) rather than the full writing construct. Cited for the ceiling of
automated prose checking.

**Wiechetek, L. et al.** "Rules Ruling Neural Networks — When Linguistics
Helps NLP." *RANLP 2021.*  
https://aclanthology.org/2021.ranlp-1.171/  
Rule-based: 81% precision / 61% recall. Neural: 79% precision / 98% recall.
Rule-based systems win on precision — fewer false alarms. Cited for why a
prose linter should restrict itself to high-precision checks.

**Zinsser, W.** *On Writing Well*, 6th ed. HarperCollins, 1998.  
The authority behind "no clutter", "respect the reader", and the lean toward
the concrete. The operative test ("could this device decorate any sentence?")
is this skill's reformulation of Zinsser's clutter criterion applied to
technical flourishes specifically.

**ax project motivation** — `MOTIVATION.md` at the project root.  
The canonical "why" for the `ax` project: the problem (hidden lifecycles
in tools that model state as tables and callbacks), the solution grammar
(actors, directives, transitions, effects, ports), and the argument for
embeddable lifecycle-first design. When reviewing `ax` documentation,
cross-check that "problem before solution" is satisfied — the motivation
must appear before the API. `MOTIVATION.md` is the test.
