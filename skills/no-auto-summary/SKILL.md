---
name: no-auto-summary
description: Prevents automatic creation of summary or documentation files after completing tasks. Use this skill when the user explicitly does NOT want documentation files (like README.md, SUMMARY.md, DOCUMENTATION.md, etc.) to be automatically generated after task completion. This skill should be active in all work sessions to prevent proactive documentation generation.
---

# No Auto Summary

## Core Principle

Do NOT proactively create summary, documentation, or wrap-up files unless the user explicitly requests them.

## Files to Avoid Creating

Never automatically create these types of files after completing a task:

- README.md (unless specifically requested)
- SUMMARY.md
- DOCUMENTATION.md
- CHANGELOG.md
- NOTES.md
- TASK_SUMMARY.md
- PROJECT_OVERVIEW.md
- Any other similar documentation or summary files

## When Documentation IS Appropriate

Only create documentation files when:

1. The user explicitly asks for documentation
2. The user specifically requests a README, summary, or similar file
3. The task itself IS to create documentation
4. The project genuinely needs initial setup documentation (e.g., a new tool/library with no existing docs)

## Workflow

After completing any coding task:

1. ✅ Implement the requested changes
2. ✅ Test and verify the implementation
3. ✅ Report completion to the user
4. ❌ Do NOT create a summary document
5. ❌ Do NOT create a README or documentation file
6. ❌ Do NOT suggest creating documentation unless asked

## Communication

When a task is complete, simply inform the user that the task is done. Focus on:

- What was implemented
- Any relevant technical details
- How to use or test the changes (verbally, not in a file)

Do NOT follow up with "Would you like me to create documentation?" or similar prompts unless documentation was part of the original request.
