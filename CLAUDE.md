### 1. Plan Node Default

- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy

- Use subagents liberally to keep main contect window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problens, throw more compute at it via subagents
- One tack per subagent
  for focused execution

### 3. Self-Improvement Loop

- After ANY correction from the user: update tasks/lessons.md" with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification Before Done

- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)

- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, chvious fixes - don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fixing

- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests - then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

### 7. High-Level Architectural Alignment

- **Analyze Before Code**: Before writing a single line, map out the data flow. How does the data
  enter, transform, and exit the system?
- **Pattern Adherence**: Identify the existing design pattern (MVVM, Clean Architecture, etc.) and
  strictly follow its rules. No shortcuts.
- **Dependency Audit**: If adding a new library, justify why an existing one or a native solution
  isn't sufficient.

### 8. The "Adversarial" Reviewer Mode

- **Self-Critique Phase**: Once code is written, play "Devil's Advocate". Try to find 3 ways your
  own code could fail or be misinterpreted.
- **Edge Case Matrix**: Explicitly list handled edge cases: (e.g., Empty states, 404s, slow network,
  large datasets).
- **Breaking Changes**: If a change breaks an existing API or contract, you MUST highlight this in
  bold before proceeding.

### 9. Production-Grade Standards

- **Error Handling**: Use structured error handling. No generic "catch all" blocks without specific
  logging.
- **Performance Check**: For loops and data processing, analyze time complexity. Avoid UI-thread
  blocking operations in mobile contexts.
- **Security First**: Scrub all logs of PII (Personally Identifiable Information). Ensure secrets
  are never hardcoded.

### 10. Verification & "Pre-flight" Checklist

1. **Lint & Format**: Does the code pass standard linting rules?
2. **Type Safety**: Are there any 'any' types or unchecked casts that can be refined?
3. **Dry Run**: Mentally execute the code with a sample input. Does the output match expectations?
4. **Staff Engineer Approval**: "If I were a Staff Engineer reviewing this PR, would I comment on
   the readability or the test coverage?" -> If yes, fix it first.

## Task Management

1. **Plan First**: Write plan to "tasks/todo.md" with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to "tasks/todo.md"
6. **Capture Lessons**: Update
   tasks/lessons.md" after corrections

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Inpact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.