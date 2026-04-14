# Implementation Plan

## Phase 0 — foundation and documentation
Current phase.

Deliverables:
- repository initialization
- product spec
- architecture plan
- implementation roadmap
- design context captured in `.impeccable.md`

## Phase 1 — app shell and theme system
Goal: create the standalone QuickShell app window and lock the visual language.

Deliverables:
- launchable app window
- app frame, header, sidebar, main pane, composer, inspector shell
- theme tokens imported from existing QuickShell/Alacritty values
- spacing, typography, surface, and focus rules
- resize/collapse behavior for sidebar and inspector

Key constraint:
Do not drift away from the current desktop family.

## Phase 2 — real Pi chat session integration
Goal: make the app actually useful as a conversation surface.

Deliverables:
- launch Pi chat from inside the app
- stream structured output into the main chat timeline
- render user/assistant messages
- support ongoing response updates
- basic session controls

Needs investigation:
- best process model for driving Pi from a QuickShell app
- whether a helper bridge is needed to normalize JSON event streams for QML

## Phase 3 — delegated worker observation
Goal: make task trees visible and navigable in the app.

Deliverables:
- load and watch task snapshot/event log
- render delegated tasks in the sidebar
- show root/child hierarchy
- surface running/queued/done/failed states
- jump from chat references to task inspection surfaces

Data sources:
- `~/.local/state/pi-subagent-orchestrator/tasks.json`
- `~/.local/state/pi-subagent-orchestrator/events.jsonl`

## Phase 4 — diff visibility
Goal: make code edits legible without leaving the conversation.

Deliverables:
- inline compact diffs in the chat timeline
- expandable focused diff view
- changed-file grouping
- strong file path visibility
- sensible behavior for long or multi-file changes

Design rule:
Diffs should be part of the conversation flow first, and only secondarily a separate detail surface.

## Phase 5 — settings and extensions inspector
Goal: expose runtime truth from inside the app.

Deliverables:
- loaded extensions list
- relevant Pi settings view
- cwd/project info
- delegation storage paths and runtime details
- future room for soul/runtime visibility if useful

Likely sources:
- `~/.pi/agent/settings.json`
- `pi list` or equivalent normalized source if needed

## Phase 6 — workflow refinement
Goal: make the app pleasant enough for daily use.

Deliverables:
- keyboard navigation
- density tuning
- state persistence for sidebar/inspector widths
- better failure states
- basic empty/loading states
- visual polish aligned with the shell theme

## Phase 7 — bar integration
Goal: connect the workbench back into the shell without merging repos.

Deliverables:
- launcher entry from the QuickShell bar
- optional running-task indicator
- optional unread/activity marker

## Working UI plan

## Sidebar
Sections:
- conversations
- active delegated tasks
- task tree / spawned workers

Requirements:
- collapsible
- resizable if practical
- compact, high-signal rows

## Main view
Sections:
- conversation timeline
- inline task updates
- inline diffs
- composer

Requirements:
- streaming friendly
- strong hierarchy between assistant text, task events, and diffs
- avoid dashboard-card sprawl

## Inspector
Sections:
- extensions
- settings
- runtime/session info

Requirements:
- quickly accessible
- informative, not decorative

## Risks to watch early

### 1. Event plumbing complexity
Real streaming chat plus live delegation observation can get messy quickly.

### 2. QML rendering complexity for diffs
Diff UIs can turn brittle if the data model is sloppy.

### 3. Too much visual borrowing from `t3-code`
Use its layout logic, not its brand identity.

### 4. Overbuilding settings before chat works
The main chat flow must become real early.

## First build milestone worth calling “alive”
The app is meaningfully alive when it can:
- open as a separate window
- send a real prompt to Pi
- stream the answer live
- show delegated tasks updating in the sidebar
- show at least a basic inline diff for file edits
- open a settings/extensions view
