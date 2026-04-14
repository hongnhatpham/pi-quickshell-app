#!/usr/bin/env python3
import json
import os
from pathlib import Path
from typing import Any

HOME = Path(os.environ.get("HOME", "/tmp"))
STATE_DIR = HOME / ".local" / "state" / "pi-subagent-orchestrator"
SNAPSHOT_PATH = STATE_DIR / "tasks.json"
EVENTS_PATH = STATE_DIR / "events.jsonl"


def load_snapshot() -> dict[str, Any]:
    if not SNAPSHOT_PATH.exists():
        return {"tasks": [], "recentEvents": [], "updatedAt": None}
    try:
        return json.loads(SNAPSHOT_PATH.read_text())
    except Exception:
        return {"tasks": [], "recentEvents": [], "updatedAt": None}


def load_recent_events(limit: int = 12) -> list[dict[str, Any]]:
    if not EVENTS_PATH.exists():
        return []
    events: list[dict[str, Any]] = []
    try:
        for line in EVENTS_PATH.read_text().splitlines():
            line = line.strip()
            if not line:
                continue
            try:
                events.append(json.loads(line))
            except Exception:
                continue
    except Exception:
        return []
    return events[-limit:]


def summarize_counts(tasks: list[dict[str, Any]]) -> dict[str, int]:
    counts = {"queued": 0, "running": 0, "done": 0, "failed": 0, "cancelled": 0}
    for task in tasks:
        status = task.get("status")
        if status in counts:
            counts[status] += 1
    return counts


def flatten_tasks(tasks: list[dict[str, Any]], max_rows: int = 18) -> list[dict[str, Any]]:
    by_id = {task.get("id"): task for task in tasks if task.get("id")}
    roots = [task for task in tasks if not task.get("parentId")]
    roots.sort(key=lambda item: item.get("createdAt", ""), reverse=True)
    rows: list[dict[str, Any]] = []

    def walk(task: dict[str, Any], depth: int) -> None:
        if len(rows) >= max_rows:
            return
        title = task.get("title") or task.get("id") or "task"
        latest = task.get("latestNote") or task.get("resultSummary") or task.get("errorMessage") or ""
        rows.append({
            "id": task.get("id", ""),
            "title": title,
            "depth": depth,
            "status": task.get("status") or "queued",
            "meta": latest,
        })
        for child_id in task.get("childIds", []) or []:
            child = by_id.get(child_id)
            if child:
                walk(child, depth + 1)

    for root in roots:
        walk(root, 0)
        if len(rows) >= max_rows:
            break
    return rows


def main() -> None:
    snapshot = load_snapshot()
    tasks = snapshot.get("tasks") or []
    payload = {
        "snapshotPath": str(SNAPSHOT_PATH),
        "eventsPath": str(EVENTS_PATH),
        "updatedAt": snapshot.get("updatedAt"),
        "counts": summarize_counts(tasks),
        "taskRows": flatten_tasks(tasks),
        "recentEvents": [
            {
                "at": event.get("at", ""),
                "kind": event.get("kind", ""),
                "taskId": event.get("taskId", ""),
                "message": event.get("message", ""),
            }
            for event in load_recent_events()
        ],
    }
    print(json.dumps(payload))


if __name__ == "__main__":
    main()
