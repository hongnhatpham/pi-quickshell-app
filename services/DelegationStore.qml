import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    readonly property string snapshotPath: `${Quickshell.env("HOME") || "/tmp"}/.local/state/pi-subagent-orchestrator/tasks.json`
    readonly property string eventsPath: `${Quickshell.env("HOME") || "/tmp"}/.local/state/pi-subagent-orchestrator/events.jsonl`

    property var counts: ({ queued: 0, running: 0, done: 0, failed: 0, cancelled: 0 })
    property var taskRows: []
    property var recentEvents: []
    property string updatedAt: ""
    property string lastError: ""

    readonly property int activeCount: Number((counts && counts.running) || 0) + Number((counts && counts.queued) || 0)
    readonly property string statusText: {
        if (lastError && lastError.length)
            return "Delegation error";
        if (activeCount > 0)
            return `Delegation ${activeCount} active`;
        if ((counts && counts.failed) > 0)
            return `Delegation idle · ${counts.failed} failed`;
        return "Delegation idle";
    }

    function refresh() {
        if (snapshotProcess.running)
            snapshotProcess.running = false;
        snapshotProcess.running = true;
    }

    readonly property string scriptPath: decodeURIComponent(Qt.resolvedUrl("../scripts/delegation_snapshot.py").toString().replace("file://", ""))

    Process {
        id: snapshotProcess
        command: ["/usr/bin/python3", root.scriptPath]
        running: true

        stdout: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                const trimmed = text.trim();
                if (!trimmed.length)
                    return;
                try {
                    const parsed = JSON.parse(trimmed);
                    root.counts = parsed.counts || { queued: 0, running: 0, done: 0, failed: 0, cancelled: 0 };
                    root.taskRows = parsed.taskRows || [];
                    root.recentEvents = parsed.recentEvents || [];
                    root.updatedAt = parsed.updatedAt || "";
                    root.lastError = "";
                } catch (error) {
                    root.lastError = "Failed to parse delegation snapshot";
                    console.warn(root.lastError, error);
                }
            }
        }

        stderr: StdioCollector {
            waitForEnd: true
            onStreamFinished: {
                const message = text.trim();
                if (message.length) {
                    root.lastError = message;
                    console.warn("Delegation snapshot stderr", message);
                }
            }
        }
    }

    Timer {
        interval: 2500
        repeat: true
        running: true
        triggeredOnStart: false
        onTriggered: root.refresh()
    }
}
