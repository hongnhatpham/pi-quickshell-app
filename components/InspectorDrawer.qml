import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    required property var theme
    required property var sessionBridge
    required property var delegationStore

    function tint(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    color: root.theme.backgroundRaised
    radius: root.theme.radius
    border.width: 1
    border.color: root.tint(root.theme.outline, 0.72)

    readonly property var sections: [
        {
            title: "Extensions",
            rows: [
                { key: "organic persona", value: "loaded" },
                { key: "delegation", value: "loaded" },
                { key: "quickshell app", value: "scaffold" }
            ]
        },
        {
            title: "Runtime",
            rows: [
                { key: "cwd", value: root.sessionBridge.projectPath },
                { key: "theme", value: "niri/alacritty inherited" },
                { key: "window", value: "FloatingWindow" },
                { key: "session", value: root.sessionBridge.sessionFile },
                { key: "status", value: root.sessionBridge.statusText }
            ]
        },
        {
            title: "Delegation",
            rows: [
                { key: "status", value: root.delegationStore.statusText },
                { key: "queued", value: String(root.delegationStore.counts.queued || 0) },
                { key: "running", value: String(root.delegationStore.counts.running || 0) },
                { key: "failed", value: String(root.delegationStore.counts.failed || 0) },
                { key: "snapshot", value: root.delegationStore.snapshotPath },
                { key: "events", value: root.delegationStore.eventsPath },
                { key: "updated", value: root.delegationStore.updatedAt || "unknown" }
            ]
        },
        {
            title: "Recent delegation events",
            rows: root.delegationStore.recentEvents && root.delegationStore.recentEvents.length
                ? root.delegationStore.recentEvents.map(event => ({
                    key: (event.kind || "event").replace("task.", ""),
                    value: event.message || ""
                }))
                : [{ key: "events", value: "No recent delegation events" }]
        }
    ]

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 38
            radius: root.theme.radiusTight
            color: root.theme.backgroundOverlay
            border.width: 1
            border.color: root.tint(root.theme.outline, 0.72)

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: "inspector"
                    color: root.theme.foreground
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSize
                    font.weight: Font.DemiBold
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: root.delegationStore.statusText
                    color: root.delegationStore.activeCount > 0 ? root.theme.oliveBright : root.theme.foregroundMuted
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }
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
                    model: root.sections

                    delegate: Rectangle {
                        id: sectionCard
                        required property var modelData
                        width: parent.width
                        implicitHeight: sectionColumn.implicitHeight + 20
                        radius: root.theme.radius
                        color: root.theme.backgroundOverlay
                        border.width: 1
                        border.color: root.tint(root.theme.outline, 0.7)

                        Column {
                            id: sectionColumn
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 8

                            Text {
                                text: sectionCard.modelData.title
                                color: root.theme.foregroundMuted
                                font.family: root.theme.fontFamily
                                font.pixelSize: root.theme.textSizeTiny
                                font.capitalization: Font.AllUppercase
                                font.letterSpacing: 0.8
                            }

                            Repeater {
                                model: sectionCard.modelData.rows

                                delegate: Rectangle {
                                    required property var modelData
                                    width: parent.width
                                    implicitHeight: 38
                                    radius: root.theme.radiusTight
                                    color: root.theme.background
                                    border.width: 1
                                    border.color: root.tint(root.theme.outline, 0.66)

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 8
                                        spacing: 8

                                        Text {
                                            Layout.preferredWidth: 86
                                            text: modelData.key
                                            color: root.theme.foregroundMuted
                                            font.family: root.theme.fontFamily
                                            font.pixelSize: root.theme.textSizeTiny
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            Layout.fillWidth: true
                                            text: modelData.value
                                            color: root.theme.foregroundSoft
                                            font.family: root.theme.fontFamily
                                            font.pixelSize: root.theme.textSizeTiny
                                            elide: Text.ElideMiddle
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
