---
description: Turn a task into a grounded, minimal, implementation-ready plan. Do not implement.
argument-hint: "<task>"
---

## Task

Plan this work:

$ARGUMENTS

## Rules

- Read-only. No edits, no code, no destructive actions.
- Be terse, specific, and decisive.
- Output one recommended path, not a menu.
- Stay at planning level. No pseudo-code, patch prose, or line-by-line implementation detail.
- Ground the plan in inspected repo evidence, relevant docs, and focused research only when needed.
- Reuse before adding. Extend existing code, interfaces, tests, and patterns before introducing new structure.
- Define proof before sequencing work.
- Use subagents as the default internal planning loop: `scout` -> `reuse-checker` -> `proof-planner` -> `breaker`.
- Keep subagent use silent. Fold findings into the plan. Verify any load-bearing claim directly.
- Resolve what you can from the repo, docs, research, and subagents before asking the user.
- Ask questions only if the wrong default would materially change scope, architecture, sequencing, validation, or risk.
- If questions are needed, ask them once, grouped by theme, with a default assumption for each, then stop.
- If not blocked, proceed with explicit assumptions.
- If revising, rewrite the full plan, not a delta.

## Process

1. **Ground**
   - Read the request and any referenced files or docs.
   - Inspect the relevant code, tests, interfaces, constraints, conventions, and nearby prior art.
   - Run `scout` first to compress the surface into likely touchpoints, flows, tests, configs, and the smallest next files to inspect.
   - Let `scout` narrow the reading set, not replace direct inspection.
   - Use external research only when local context is insufficient or current outside facts matter.

2. **Reuse**
   - Define the done state in observable terms.
   - Identify the key constraint, main risk, and any irreversible decision.
   - Run `reuse-checker` on the candidate path.
   - Default to extending, adapting, consolidating, or deleting-before-adding.
   - Introduce new structure only when inspected evidence shows reuse does not fit.

3. **Prove**
   - Define proof of success before sequencing the work.
   - Run `proof-planner` to sharpen the done state, choose the fastest convincing checks, and attach proof to each major phase.
   - For code work, use red -> green -> refactor when it materially improves execution.
   - Prefer existing tests, harnesses, fixtures, scripts, and manual checks over new ceremony.

4. **Break**
   - Run `breaker` on the draft plan.
   - Surface hidden dependencies, edge cases, sequencing traps, caller impact, contract changes, migration concerns, rollout issues, and likely failure modes.
   - Remove speculative abstractions, decorative refactors, and nice-to-have scope.
   - If `breaker` finds a material issue, revise the plan: narrow scope, reorder work, add missing proof, or choose the simpler fallback.
   - If it exposes an unresolved question that cannot be settled locally and would materially change the plan, convert it into blockers.

5. **Write**
   - Give the minimum credible path from current state to done.
   - Order steps by dependency and risk.
   - Make each phase outcome-based.
   - Include proof for each major phase.
   - Name the primary risk, weakest assumption, and simplest fallback plainly.

## Standard

Accept only plans that are grounded, minimal, ordered, decisive, reuse-first, proof-first, pressure-tested, and honest.

Reject generic advice, option lists, vague steps, invented abstractions without evidence, refactors without concrete payoff, implementation detail disguised as planning, proof deferred to the end, or ceremonial subagent use.

## Output

If blocked, output exactly:

### Blockers

- **[Theme]** Question?  
  Default if unanswered: ...

Otherwise output exactly:

### Outcome

- 1-2 bullets describing what will be true when this is done

### Plan

1. **[Phase]** — outcome  
   Reuse/touchpoints: ...  
   Proof: ...
2. **[Phase]** — outcome  
   Reuse/touchpoints: ...  
   Proof: ...
3. Continue only as needed

### Risks

- **Primary risk:** ...
- **Weakest assumption:** ...
- **Simplest fallback:** ...

### Status

`Ready to implement.`
