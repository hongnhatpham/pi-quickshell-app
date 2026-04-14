import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    required property var theme
    required property bool collapsed
    required property bool diffFocus

    function tint(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    color: root.theme.backgroundRaised
    radius: root.theme.radius
    border.width: 1
    border.color: root.tint(root.theme.outline, 0.72)

    readonly property var threadRows: [
        { title: "Main thread", meta: "current workspace", active: true },
        { title: "Design shell scaffold", meta: "next build step", active: false },
        { title: "Delegation runtime notes", meta: "reference", active: false }
    ]

    readonly property var taskRows: [
        { title: "Main chat thread", depth: 0, status: "live" },
        { title: "Research QuickShell patterns", depth: 1, status: "running" },
        { title: "Inspect theme inheritance", depth: 1, status: "done" },
        { title: "Review diff behavior", depth: 1, status: "queued" }
    ]

    readonly property var runtimeRows: [
        { key: "cwd", value: "pi-quickshell-app" },
        { key: "extensions", value: "persona · delegation" },
        { key: "diff", value: root.diffFocus ? "inline + focused" : "inline only" }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: root.collapsed ? 8 : 12
        spacing: 10

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: root.collapsed ? 42 : 56
            radius: root.theme.radius
            color: root.theme.backgroundOverlay
            border.width: 1
            border.color: root.tint(root.theme.outline, 0.78)

            Column {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 2
                visible: !root.collapsed

                Text {
                    text: "workspace"
                    color: root.theme.foregroundMuted
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 0.8
                }

                Text {
                    text: "personal Pi workbench"
                    color: root.theme.foreground
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSize
                    font.weight: Font.DemiBold
                }
            }

            Text {
                anchors.centerIn: parent
                visible: root.collapsed
                text: "A3"
                color: root.theme.cream
                font.family: root.theme.fontFamily
                font.pixelSize: root.theme.textSize
                font.weight: Font.DemiBold
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            Column {
                width: parent.width
                spacing: 12

                Repeater {
                    model: [
                        { title: "Threads", rows: root.threadRows, kind: "threads" },
                        { title: "Delegation", rows: root.taskRows, kind: "tasks" },
                        { title: "Runtime", rows: root.runtimeRows, kind: "runtime" }
                    ]

                    delegate: Column {
                        id: sectionBlock
                        required property var modelData
                        readonly property string sectionKind: modelData.kind
                        width: parent.width
                        spacing: 6

                        Text {
                            visible: !root.collapsed
                            text: modelData.title
                            color: root.theme.foregroundMuted
                            font.family: root.theme.fontFamily
                            font.pixelSize: root.theme.textSizeTiny
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: 0.9
                        }

                        Repeater {
                            model: modelData.rows

                            delegate: Rectangle {
                                required property var modelData
                                readonly property string sectionKind: sectionBlock.sectionKind
                                width: parent.width
                                implicitHeight: root.collapsed ? 38 : (sectionKind === "runtime" ? 42 : 46)
                                radius: root.theme.radiusTight
                                color: sectionKind === "threads" && modelData.active
                                    ? root.tint(root.theme.accent, 0.12)
                                    : root.theme.backgroundOverlay
                                border.width: 1
                                border.color: sectionKind === "threads" && modelData.active
                                    ? root.tint(root.theme.accentBright, 0.72)
                                    : root.tint(root.theme.outline, 0.72)

                                Rectangle {
                                    visible: !root.collapsed && sectionKind === "tasks"
                                    width: 3
                                    radius: 1
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    anchors.margins: 8
                                    color: modelData.status === "running"
                                        ? root.theme.oliveBright
                                        : (modelData.status === "done"
                                            ? root.theme.indigoBright
                                            : (modelData.status === "queued"
                                                ? root.theme.amberBright
                                                : root.theme.accentBright))
                                }

                                Item {
                                    anchors.fill: parent
                                    anchors.margins: root.collapsed ? 0 : 10
                                    anchors.leftMargin: root.collapsed ? 0 : (sectionKind === "tasks" ? 14 + (modelData.depth || 0) * 16 : 10)

                                    Text {
                                        anchors.centerIn: parent
                                        visible: root.collapsed
                                        text: sectionKind === "threads"
                                            ? (modelData.active ? "•" : "◦")
                                            : (sectionKind === "tasks"
                                                ? ((modelData.depth || 0) > 0 ? "└" : "↺")
                                                : "⋯")
                                        color: root.theme.foregroundSoft
                                        font.family: root.theme.fontFamily
                                        font.pixelSize: root.theme.textSize
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        visible: !root.collapsed
                                        spacing: 2

                                        Text {
                                            text: sectionKind === "runtime"
                                                ? modelData.key
                                                : modelData.title
                                            color: root.theme.foreground
                                            font.family: root.theme.fontFamily
                                            font.pixelSize: root.theme.textSize
                                            font.weight: (sectionKind === "threads" && modelData.active) ? Font.DemiBold : Font.Normal
                                        }

                                        Text {
                                            visible: sectionKind !== "tasks"
                                            text: sectionKind === "runtime"
                                                ? (modelData.value || "")
                                                : (modelData.meta || "")
                                            color: root.theme.foregroundMuted
                                            font.family: root.theme.fontFamily
                                            font.pixelSize: root.theme.textSizeTiny
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
