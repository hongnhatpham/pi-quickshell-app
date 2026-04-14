# Layout Synthesis and First Scaffold

This document folds together the current design direction, delegated research, and the first implementation decisions for the app shell.

## What we are borrowing from `t3-code`

We are borrowing **layout grammar**, not visual identity.

Useful structural patterns:
- left collapsible sidebar as a persistent navigation/operations rail
- conversation-first center pane
- inline work/activity blocks in the main thread
- two-step diff visibility:
  - compact inline changed-file summary
  - focused diff surface when the user wants more detail
- dense section/row settings layout

## What we are explicitly not borrowing

- web-product softness
- shadcn-ish pills/cards everywhere
- tooltip-heavy explanatory chrome
- SaaS/admin settings sprawl
- too many competing side panes or productized controls

## What we are carrying over from the current QuickShell bar

Source of truth:
- `~/projects/niri-quickshell-bar/shell/Theme.qml`
- `~/projects/niri-quickshell-bar/docs/spec.md`
- `~/.config/alacritty/alacritty.toml`

Carry over directly:
- palette
- IBM Plex Mono typography
- tight 2px/4px radius language
- compact spacing rhythm
- restrained hover behavior
- strong surface hierarchy
- limited accent usage

Core tokens:
- background `#19110c`
- backgroundRaised `#281b15`
- backgroundOverlay `#221713`
- backgroundElevated `#2f2119`
- foreground `#efd0ad`
- foregroundSoft `#ddbea0`
- foregroundMuted `#ad8971`
- accent `#df6d0a`
- accentBright `#f39a36`
- outline `#4c3529`
- semantic accents from terracotta / olive / amber / indigo / plum / slate / cream

## Standalone QuickShell app primitive

For a real launchable app window, the right base primitive is:
- `ShellRoot`
- `FloatingWindow`

This is the correct direction for the app shell.

Why not `PanelWindow`:
- `PanelWindow` is the layer-shell/panel primitive used for the bar and overlays
- it is right for anchored shell surfaces
- it is not the right mental model for a persistent desktop workbench window

Evidence already present locally:
- `~/projects/niri-quickshell-bar/lockscreen/test.qml` uses `FloatingWindow`
- the bar and overlays use `PanelWindow`

## Recommended v1 pane map

## Left sidebar
Purpose:
- threads
- delegated task tree
- runtime strip

Rules:
- collapsible
- resizable
- dense
- hierarchy-first, not dashboard-first

## Center pane
Purpose:
- primary chat timeline
- inline tool and task updates
- inline diff previews
- composer at bottom

Rules:
- conversation remains the center of gravity
- diffs stay in-thread first
- detailed diff view is an escalation, not a replacement

## Right inspector
Purpose:
- loaded extensions
- runtime/session facts
- cwd/project info
- delegation store visibility

Rules:
- toggleable drawer
- row/section based
- dense and factual
- not a separate settings world

## First scaffold decision

The first real scaffold should include:
- `shell.qml`
- `Theme.qml`
- `components/AppWindow.qml`
- `components/Sidebar.qml`
- `components/ChatPane.qml`
- `components/InspectorDrawer.qml`
- `components/Composer.qml`
- `components/DiffPreview.qml`

This scaffold should be launchable and visually coherent even before real Pi session wiring lands.

## Interaction stance

- no helper-copy footers by default
- no modal-first diff behavior
- no rounded-card sludge
- keep keyboard-friendly focus states
- keep the UI compact enough for personal everyday use

## Current conclusion

We know enough to build the app shell now.

The remaining unknown is not the product shape. It is only the exact runtime plumbing for streaming Pi sessions and live data models.
