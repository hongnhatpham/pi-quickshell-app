# pi-quickshell-app

A separate QuickShell desktop app for chatting with Pi and observing delegated workers in one place.

This is intentionally **not** part of `niri-quickshell-bar`.

The bar remains the ambient shell surface. This repo is the primary workbench: a launchable app window for conversation, task observation, inline diffs, and runtime/settings inspection.

## Why this exists

The existing bar is good for quick status and small popups. It is not the right container for:

- full chat sessions
- streaming model output
- spawned subagent/task trees
- observable code diffs
- loaded extension inspection
- session and runtime settings

This app is the larger surface where those things can live comfortably.

## Product direction

### Audience
Personal use only.

### Scope
Real chat + real observation from the start.

That means v1 should support:
- actual Pi chat inside the app
- live subagent/task observation
- inline or adjacent code diff viewing
- settings/extensions inspection

### Visual direction
Match the current machine language already established across:
- Niri
- the QuickShell bar
- Alacritty

This should feel like the same desktop family:
- warm industrial
- sharp geometry
- compact and calm
- IBM Plex Mono / terminal-adjacent typography
- restrained orange accent energy
- no generic AI dashboard styling

### Layout reference
Use the layout grammar of `t3-code` as a reference point, especially:
- a left collapsible sidebar
- a main chat area
- clear diff visibility
- a settings surface

But this should **not** become a visual clone. It should be reinterpreted through the user’s existing Niri/QuickShell/Alacritty theme.

## Initial UI shape

### Left sidebar
- chat threads
- current main thread
- spawned subagents
- running/completed delegated tasks
- collapsible / resizable behavior

### Main pane
- primary chat timeline
- streaming assistant output
- tool/task updates
- inline code diffs and expandable diff views
- file references and status markers

### Settings pane / inspector
- loaded extensions
- agent/runtime settings
- cwd/session details
- delegation status and storage paths
- future soul/runtime visibility if useful

## Core integrations

- Pi chat session streaming
- delegated worker observation via persisted task/event store
- extension/settings inspection from live Pi config
- later launcher integration from the Niri QuickShell bar

## Repo structure

```text
pi-quickshell-app/
  README.md
  .impeccable.md
  .gitignore
  shell.qml
  Theme.qml
  components/
  services/
  docs/
    product-spec.md
    architecture.md
    implementation-plan.md
    layout-synthesis.md
```

## Current status

This repository now contains:
- the initial product, architecture, and implementation documentation
- project design context in `.impeccable.md`
- a first standalone QuickShell app shell scaffold using `ShellRoot` + `FloatingWindow`
- a themed UI for:
  - left collapsible sidebar
  - conversation-first center pane
  - inline diff preview
  - toggleable runtime/settings inspector
  - bottom composer
- an initial real Pi session bridge in `services/SessionBridge.qml`
  - prompts are sent through the actual `pi` CLI
  - output is streamed from `--mode json`
  - a dedicated session file is used so consecutive prompts continue the same conversation within the app runtime

What is still missing:
- delegated task store observation in the sidebar
- real extension/settings ingestion instead of placeholder rows
- smarter diff extraction from actual tool activity
