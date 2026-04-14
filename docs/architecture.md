# Architecture Plan

## Project shape

This should be a separate QuickShell app project with its own window and supporting runtime glue.

High-level split:
- **UI shell**: QuickShell/QML app window and components
- **runtime bridge**: process + file-watch integration for Pi sessions, delegation state, and settings inspection
- **desktop integration**: launcher path and later bar integration

## Why separate from the bar repo

The bar repo is an ambient shell surface.
This app is a full workbench.

They have different:
- complexity
- iteration speed
- runtime responsibilities
- failure impact

The bar can later open or signal this app, but should not own its full implementation.

## Main runtime surfaces

## 1. Chat session bridge
Responsibility:
- start and manage Pi chat sessions for the app
- stream output/events into the UI
- keep the app synchronized with session state

Likely responsibilities:
- spawn Pi in structured output mode
- parse message/tool/update events
- expose app-friendly state to QML
- manage session lifecycle, cancellation, and reload actions later

Open implementation question:
- pure QML + process wrappers may be enough for first pass
- if not, add a small helper bridge process for event normalization

## 2. Delegation observability bridge
Responsibility:
- watch delegated worker state and recent events
- expose task tree, child relationships, status, and summaries to the UI

Initial data sources:
- `~/.local/state/pi-subagent-orchestrator/tasks.json`
- `~/.local/state/pi-subagent-orchestrator/events.jsonl`

Requirements:
- subtree awareness
- live status refresh
- recent event summaries
- root/child navigation from sidebar and main view

## 3. Diff extraction and presentation layer
Responsibility:
- turn tool activity into readable change views
- preserve chat context while making edits obvious

Planned behavior:
- inline compact diff snippets in the main timeline
- expandable detailed diff view when needed
- file-path-first presentation so changed files are legible at a glance

Potential sources:
- edit/write tool results
- file snapshots if needed for reconstructing hunks
- git diff as fallback or secondary verification in repo contexts

## 4. Settings/extensions inspector
Responsibility:
- show active extensions and key runtime settings from the user’s Pi environment

Initial sources:
- `~/.pi/agent/settings.json`
- package/source lists from live Pi settings
- possibly `pi list` output if needed for normalization/verification

Useful details to surface:
- loaded extensions
- package paths/sources
- current working directory
- current session/runtime assumptions
- delegation store paths

## UI composition

## App window
A standalone, launchable QuickShell window.

Primary composition:
- left collapsible sidebar
- central chat/diff workspace
- right-side settings/inspector surface or slide-over panel
- bottom composer

## Sidebar model
Should unify two things without making the UI confused:
- conversation navigation
- active delegated task visibility

Likely sections:
- conversations
- active jobs / delegated tasks
- recent failures or waiting states

## Main workspace model
The main pane should allow coexistence of:
- conversational messages
- tool messages
- child task references
- inline diffs
- focused diff inspection

This should feel like one thread, not a pile of disconnected panes.

## Settings model
Settings should be visible without feeling like a separate app.

Possible pattern:
- right-side inspector drawer
- toggleable from the header
- remembers width/open state

## Data flow sketch

1. User opens app window.
2. App initializes:
   - theme tokens
   - Pi session bridge
   - delegation store watchers
   - settings loader
3. User sends a prompt.
4. Pi session bridge streams events.
5. UI renders:
   - assistant text
   - tool invocations
   - delegated task creation/status
   - inline diffs when edits occur
6. Sidebar updates task tree and thread state in parallel.
7. Settings/inspector pane can show current extension/runtime state at any time.

## Technical priorities

### Priority 1: reliability of event flow
If streaming and state updates feel flaky, the whole app will feel fake.

### Priority 2: readable information hierarchy
Chat, tasks, diffs, and settings must coexist without the layout turning into sludge.

### Priority 3: visual continuity with the rest of the desktop
This should feel like it belongs with the existing shell, not imported from another product.

## Later integration with the bar

The bar should act as:
- launcher
- activity indicator
- maybe unread/running-task status

The bar should not become the main chat container.
