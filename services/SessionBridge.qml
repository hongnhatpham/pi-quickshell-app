import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property string projectPath: "/mnt/storage/01 Projects/pi-quickshell-app"
    readonly property string stateDir: `${Quickshell.env("HOME") || "/tmp"}/.local/state/pi-quickshell-app`
    readonly property string sessionFile: `${stateDir}/main-session.jsonl`

    property var messages: []
    property var activity: []
    property bool running: false
    property string lastError: ""
    property int activeAssistantIndex: -1
    property int completedTurns: 0
    property string lastPrompt: ""
    property var processCommand: []

    readonly property string statusText: {
        if (running)
            return "Pi running";
        if (lastError.length)
            return "Pi error";
        if (completedTurns > 0)
            return `Pi ready · ${completedTurns} turn${completedTurns === 1 ? "" : "s"}`;
        return "Pi idle";
    }

    function appendMessage(role, text, kind) {
        const next = root.messages.slice();
        next.push({
            role: role,
            text: text || "",
            kind: kind || "message",
            timestamp: Date.now()
        });
        root.messages = next;
        return next.length - 1;
    }

    function replaceMessageText(index, text) {
        if (index < 0 || index >= root.messages.length)
            return;

        const next = root.messages.slice();
        const current = Object.assign({}, next[index]);
        current.text = text || "";
        next[index] = current;
        root.messages = next;
    }

    function appendAssistantDelta(delta) {
        if (!delta || !delta.length)
            return;

        if (root.activeAssistantIndex < 0)
            root.activeAssistantIndex = root.appendMessage("assistant", "", "assistant");

        const current = root.messages[root.activeAssistantIndex];
        root.replaceMessageText(root.activeAssistantIndex, `${current && current.text ? current.text : ""}${delta}`);
    }

    function appendActivity(text, tone) {
        if (!text || !text.trim().length)
            return;

        let next = root.activity.slice();
        next.push({
            text: text.trim(),
            tone: tone || "muted",
            timestamp: Date.now()
        });
        if (next.length > 18)
            next = next.slice(next.length - 18);
        root.activity = next;
    }

    function extractTextParts(message) {
        if (!message || !message.content)
            return [];

        const texts = [];
        for (let index = 0; index < message.content.length; index += 1) {
            const part = message.content[index];
            if (part && part.type === "text" && part.text)
                texts.push(part.text);
        }
        return texts;
    }

    function parseEvent(line) {
        let event;
        try {
            event = JSON.parse(line);
        } catch (error) {
            root.appendActivity(`unparsed event · ${line.slice(0, 140)}`, "warning");
            return;
        }

        if (event.type === "message_update" && event.assistantMessageEvent) {
            const update = event.assistantMessageEvent;
            if (update.type === "text_delta" && typeof update.delta === "string") {
                root.appendAssistantDelta(update.delta);
            } else if (update.type === "text_end" && typeof update.content === "string") {
                if (root.activeAssistantIndex < 0)
                    root.activeAssistantIndex = root.appendMessage("assistant", update.content, "assistant");
                else
                    root.replaceMessageText(root.activeAssistantIndex, update.content);
            }
            return;
        }

        if (event.type === "message_end" && event.message && event.message.role === "assistant") {
            const texts = root.extractTextParts(event.message);
            if (texts.length) {
                const joined = texts.join("\n\n").trim();
                if (root.activeAssistantIndex < 0)
                    root.activeAssistantIndex = root.appendMessage("assistant", joined, "assistant");
                else
                    root.replaceMessageText(root.activeAssistantIndex, joined);
            }
            return;
        }

        if (event.type === "tool_execution_update") {
            const toolName = event.toolName || "tool";
            root.appendActivity(`tool · ${toolName}`, "info");
            return;
        }

        if (event.type === "tool_execution_end" || event.type === "tool_result_end") {
            const toolName = event.toolName || "tool";
            root.appendActivity(`done · ${toolName}`, "muted");
            return;
        }

        if (event.type === "error") {
            root.lastError = event.error || "Unknown Pi error";
            root.appendActivity(root.lastError, "error");
        }
    }

    function sendPrompt(prompt) {
        const trimmed = (prompt || "").trim();
        if (!trimmed.length || root.running)
            return false;

        root.lastPrompt = trimmed;
        root.lastError = "";
        root.appendMessage("user", trimmed, "user");
        root.activeAssistantIndex = root.appendMessage("assistant", "", "assistant");
        root.appendActivity(`prompt · ${trimmed.slice(0, 96)}`, "accent");

        root.processCommand = [
            "pi",
            "--mode", "json",
            "-p",
            "--session", root.sessionFile,
            trimmed
        ];
        root.running = true;
        piProcess.running = true;
        return true;
    }

    function clearConversation() {
        if (root.running)
            return false;

        root.messages = [];
        root.activity = [];
        root.lastError = "";
        root.lastPrompt = "";
        root.activeAssistantIndex = -1;
        root.completedTurns = 0;
        resetSessionProcess.running = true;
        return true;
    }

    Process {
        id: resetSessionProcess
        command: ["bash", "-lc", `mkdir -p \"${root.stateDir}\" && rm -f \"${root.sessionFile}\"`]
        running: true
    }

    Process {
        id: piProcess
        command: root.processCommand
        workingDirectory: root.projectPath
        running: false

        stdout: SplitParser {
            splitMarker: "\n"

            onRead: data => {
                const line = data.trim();
                if (!line.length)
                    return;
                root.parseEvent(line);
            }
        }

        stderr: SplitParser {
            splitMarker: "\n"

            onRead: data => {
                const line = data.trim();
                if (!line.length)
                    return;
                root.lastError = line;
                root.appendActivity(line, "error");
            }
        }

        onStarted: {
            root.appendActivity("pi session started", "info");
        }

        onExited: exitCode => {
            root.running = false;
            piProcess.running = false;

            if (exitCode === 0) {
                root.completedTurns += 1;
                root.appendActivity("pi session turn complete", "success");
            } else {
                if (!root.lastError.length)
                    root.lastError = `Pi exited with code ${exitCode}`;
                root.appendActivity(root.lastError, "error");
                const current = root.activeAssistantIndex >= 0 ? root.messages[root.activeAssistantIndex] : null;
                if (!current || !current.text || !current.text.length)
                    root.replaceMessageText(root.activeAssistantIndex, root.lastError);
            }

            root.activeAssistantIndex = -1;
        }
    }
}
