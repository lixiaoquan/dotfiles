---
name: bug-to-asana
description: Use when the user mentions a Bugzilla bug and wants it assigned/dispatched/handed to a teammate — e.g. "把bug 19579分配给小龙", "这个bug给小龙跟进", "/bug-to-asana 19579 小龙". Covers Bugzilla assigned_to changes, Asana task mirroring, or both.
---

# Bugzilla → Asana Bug Assignment

Assign a Bugzilla bug to a teammate. Two write targets, both outward-facing:

1. **Bugzilla**: change `assigned_to` to the person's email
2. **Asana**: create a task in that person's section of the tracked project

Do only the side(s) the user asked for. If "分配给某人" doesn't make clear
which system (Bugzilla / Asana / both), ASK — do not guess. (The Asana
workspace has a single member; teammates are represented by sections, so
"Asana assignment" means placing the task into their section.)

## Step 1 — Look up the person in people.md

Read `people.md` next to this file. It maps aliases → Bugzilla email +
Asana project/section GIDs. The user maintains it.

- **Always use GIDs from the table. Never search Asana by name** — section
  names are irregular (`Xiaolong:` with colon, `石永涛` in Chinese,
  `Shengxin:` in pinyin) and the workspace user list won't contain the
  teammate at all.
- Person missing, or their email cell is empty → ask the user. Never guess
  an email; a wrong guess reassigns a real bug to the wrong person.

## Step 2 — Read the bug

`GetChatBugDetail(bugID)`. Extract: title (shortDesc). Nothing else is
needed — the Asana task carries the title only, no description.

## Step 3 — Confirm both writes in one shot

Before executing anything, summarize and get user confirmation:

- Bugzilla: bug {id} `assigned_to` → {email}
- Asana: task `[Bug {id}] {title}` → {project} / {section name}

## Step 4 — Execute

1. Bugzilla: `UpdateBugZillaBug(bugID, assigned_to=<email>)`
2. Asana: **check for duplicates first** — `get_tasks(section=<section_gid>)`
   and scan task names for `[Bug {id}]`. If a task for this bug already
   exists in the section, do NOT create another; report the existing task
   instead (and optionally update it).
3. Asana (only if no duplicate): `create_tasks` with
   - `name`: `[Bug {id}] {bug title}`
   - `project_id` + `section_id` from the table
   - no `notes` — title only, no description

## Step 5 — Report

Reply with the Asana task permalink and the Bugzilla assignment result.

## Common Mistakes

- Assigning the Asana task to the person as a user — impossible here;
  placement is via section GID from people.md.
- Searching Asana sections by display name instead of using table GIDs.
- Guessing a Bugzilla email from pinyin — email cells stay empty until the
  user fills them; ask instead.
- Skipping the write confirmation, or confirming the two writes separately.
- Adding `notes`/description to the Asana task — title only, per user
  preference (the bug detail lives in Bugzilla).
