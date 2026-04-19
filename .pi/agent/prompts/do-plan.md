---
description: Ground first. Stress-test silently. Then output the minimum viable plan. Do not implement.
argument-hint: "<instructions>"
---

## Task

Plan this work:

$ARGUMENTS

## Rules

- Read-only. No edits, no code, no destructive actions.
- Be extremely concise. No fluff, no performative thoroughness.
- Output one recommended path, not a menu.
- Do not implement, pseudo-implement, or describe patch-level edits.
- Prefer repo evidence over guesses.
- Prefer reuse over invention.
- Ask questions only if the wrong default would cause material rework, risk, or scope drift.
- If questions are needed, ask them once, in a grouped batch by theme, with a default assumption for each.
- If blocked by questions, stop after asking them.
- If revising, rewrite the full plan, not a delta.
- Never ask for info that can be recovered from the repo, docs, or focused research.

## Process

1. Ground
   - Read referenced files/docs.
   - Inspect the relevant code, tests, interfaces, constraints, conventions, and prior art.
   - Use online research only if local context is insufficient or current external facts matter.

2. Decide
   - Define the done state.
   - Identify the key constraint and main risk.
   - Choose the simplest viable approach that fits the existing system.

3. Stress-test silently
   - Walk the decision tree internally.
   - Surface hidden dependencies, edge cases, migration concerns, and likely failure modes.
   - Kill weak branches early.
   - Prefer extending existing primitives over adding new structure.
   - For code work, use red -> green -> refactor when it meaningfully improves execution.
   - Otherwise use the equivalent validation-first loop: define proof first, then the minimum path to it.

4. Blockers
   - If an unanswered question would materially change scope, architecture, sequencing, validation, or risk, ask one grouped batch and stop.
   - Otherwise proceed with explicit assumptions.

5. Write the plan
   - Output the minimum path from current state -> working outcome.
   - Sequence by dependency and risk.
   - Make every phase outcome-based.
   - Include proof, not just activity.

## Standard

A strong PLAN is:

- **Grounded** — based on inspected evidence, not plausible guesses
- **Minimal** — smallest credible path to done
- **Ordered** — dependencies and risk handled early
- **Decisive** — one best path
- **Validation-first** — proof of success is built into the plan
- **Reuse-first** — extends existing patterns before inventing new ones
- **Honest** — names assumptions, risks, and unknowns briefly

Reject:

- generic advice
- long option lists
- vague steps like "add validation" or "handle edge cases"
- invented abstractions without evidence they are needed
- refactors without a concrete payoff
- implementation detail disguised as planning

## Output

If blocked, output exactly:

### Blockers

- **[Theme]** Question?  
  Default if unanswered: ...

Otherwise output exactly:

### Outcome

- 1-2 bullets: what will be true when this is done

### Plan

1. **[Phase]** — outcome  
   Reuse/touchpoints: ...  
   Proof: ...
2. **[Phase]** — outcome  
   Reuse/touchpoints: ...  
   Proof: ...
3. Continue only as needed

### Risks

- Biggest risk: ...
- Weakest assumption: ...
- Simplest fallback: ...

### Status

`Ready to implement.`
