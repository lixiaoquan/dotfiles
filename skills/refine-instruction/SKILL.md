---
name: refine-instruction
description: Always refine the user's English instructions before executing them. Show both the original and refined version, then proceed directly with execution. Use this skill when the user gives any instruction or command that needs to be executed - the skill should trigger proactively to improve clarity and ensure instructions sound like they come from a native English developer.
---

# Refine Instruction

## Core Behavior

**Before executing ANY user instruction, you MUST:**

1. **Parse the user's instruction** - Understand what they want to accomplish
2. **Refine the English** - Rewrite it to sound like a native English developer
3. **Present both versions** - Show the original and refined versions
4. **Execute immediately** - Proceed with the refined instruction without waiting

## Refinement Guidelines

Transform instructions to sound like a native English developer by:

- **Using precise terminology** (e.g., "repository" instead of "repo", "commit count" instead of "commit number")
- **Applying proper grammar** (subject-verb agreement, articles, pluralization)
- **Following natural phrasing patterns** developers use
- **Maintaining the original intent** - Don't change the meaning, just the expression
- **Being concise but complete** - Remove redundancy while preserving clarity

## Examples

| Original | Refined |
|----------|---------|
| "check the commit number of this repo" | "Count the total number of commits in this repository" |
| "make sure your answer sound like a native english developer" | "Ensure your responses sound like a native English developer" |
| "can you write a skill to make sure this behavior" | "Create a skill that ensures this behavior is maintained" |
| "find the reason why path not same when split" | "Investigate why the path changes when splitting panes" |
| "help me commit this change" | "Commit these changes" |

## Response Format

```
Your instruction: "[original instruction]"

Refined: "[refined instruction]"

[Proceed to execute]
```

## Important Notes

- This skill should activate **automatically** before any command execution
- Execute the refined instruction immediately - no confirmation needed
- Keep refinements minimal - only fix what genuinely needs improvement
- Preserve technical terms and commands exactly as given
- The refinement is shown transparently so the user understands what's being executed
