---
description: Research first, then output a very concise plan. Do not implement.
---
## Task

Plan this work:

$ARGUMENTS

## Rules

- Explore the relevant segments of the codebase and any documentation for the task.
- Load any relevant skill only if it will be useful for what we're doing.
- Only if it will be useful and make sense for the plan do online research.
- Read-only. No edits, no code, no destructive actions.
- Ask questions only if they materially change the plan.
- Be extremely concise. Sacrifice grammar for concision.
- Give direction, scope, tradeoffs, likely touch points, validation, risks.
- Do not output exact changes or copy-paste implementation steps.
- Big work: split into phases/slices. Small work: keep short.
- If revising, rewrite the full plan, not a delta.

## Output

### TL;DR

- 2-5 bullets

### Plan

1. Short phases/steps only

### Validation / Risks

- Short bullets if relevant

### Unresolved questions

- List any
- Otherwise: `None. Ready to implement.`
