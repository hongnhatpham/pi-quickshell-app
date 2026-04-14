# Product Spec

## Working name
`pi-quickshell-app`

A separate QuickShell desktop app window for interacting with Pi and observing delegated workers inside a single, launchable interface.

## Positioning

This project is the primary conversation/workbench surface for ARIA-03 on this desktop.

It is **not**:
- a replacement for the bar
- another tiny popup panel
- a generic AI chat shell

It **is**:
- a proper launchable app window
- a home for chat, orchestration visibility, diffs, and settings
- a desktop-native surface aligned with the current Niri + QuickShell + Alacritty environment

## Confirmed decisions

### Repository boundary
This app lives in its own repository.

Reason:
- the bar repo should remain focused on ambient shell UI
- this app needs its own lifecycle, architecture, and iteration speed

### Audience
Personal use only.

### Scope
Option 2: real chat + real observation from the beginning.

### Layout reference
Use `t3-code` as the structural reference for:
- left collapsible sidebar
- main chat pane
- visible diffs
- settings surface

But keep the visual design rooted in the current desktop theme rather than cloning `t3-code`.

## Primary user goals

1. Chat with Pi in a first-class window rather than only through terminal sessions.
2. Watch delegated workers and task trees without leaving the main conversation surface.
3. Inspect code changes directly inside the conversational workflow.
4. See what runtime context is active: extensions, settings, current session environment.
5. Keep the whole system feeling coherent with the rest of the desktop.

## Core views

## 1. Sidebar
Purpose: navigation + observability overview.

Contents:
- main chat thread list
- active thread marker
- spawned subagents / delegated tasks
- running / queued / failed state markers
- quick collapse/expand behavior

Behavior:
- collapsible
- should preserve enough density to feel operational, not airy
- task hierarchy should be visible at a glance

## 2. Main chat view
Purpose: primary place to interact with Pi.

Contents:
- user and assistant messages
- streaming response rendering
- tool usage / worker events inline
- file references
- task references
- inline code diffs

Behavior:
- the chat remains the center of gravity
- diff content should be observable in the conversation itself
- longer diffs can expand into a more focused view without losing thread context

## 3. Settings / runtime inspector
Purpose: answer “what is this session actually running with?”

Contents:
- loaded extensions
- relevant agent settings
- runtime/session details
- cwd / current project info
- delegation status paths and environment details where useful

Behavior:
- available from within the main app
- should be fast to scan and not buried

## Interaction principles

### Conversation-first
The app should feel like a working conversation environment, not a dashboard with chat embedded into it.

### Observation without detachment
Delegated tasks and diffs should be visible without forcing the user into a separate tool unless they want one.

### Desktop-native restraint
The UI should feel like it belongs on this machine. More shell-native and composed; less SaaS.

### High signal density
This is for personal use. It can afford to be slightly denser and more operational than a mass-market app.

## Visual language

### Source of truth
- `~/.config/alacritty/alacritty.toml`
- `~/projects/niri-quickshell-bar/shell/Theme.qml`
- the current Niri shell styling decisions

### Core palette
- background: `#19110c`
- raised surface: `#281b15`
- overlay/elevated surfaces: `#221713`, `#2f2119`
- foreground: `#efd0ad`
- soft foreground: `#ddbea0`
- muted foreground: `#ad8971`
- accent: `#df6d0a`
- accent bright: `#f39a36`
- outline: `#4c3529`
- muted brown: `#654838`

Extended accents available for states:
- terracotta `#db7a2f`
- olive `#af974f`
- amber `#efae4e`
- indigo `#5a617c`
- plum `#a8767c`
- slate `#9a8171`
- cream `#f6dfc3`

### Typography
- primary family: IBM Plex Mono
- terminal-adjacent, compact, precise

### Shape
- tight corners
- max radius around 4px
- no pill-heavy treatment
- no generic rounded card language

## Non-goals for v1
- turning the bar into the main chat UI
- building a cross-platform productized app
- adding speculative collaboration/multi-user features
- overdesigning before real session wiring exists

## Success criteria for the first meaningful version
- can launch as a proper window
- can run a real Pi chat session inside the app
- can display delegated task activity live
- can show code diffs in or beside the main thread
- can inspect loaded extensions/settings
- visually feels like it belongs with the existing desktop theme
