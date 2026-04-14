import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    required property var theme

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
                { key: "cwd", value: "/mnt/storage/01 Projects/pi-quickshell-app" },
                { key: "theme", value: "niri/alacritty inherited" },
                { key: "window", value: "FloatingWindow" }
            ]
        },
        {
            title: "Delegation",
            rows: [
                { key: "snapshot", value: "~/.local/state/pi-subagent-orchestrator/tasks.json" },
                { key: "events", value: "~/.local/state/pi-subagent-orchestrator/events.jsonl" },
                { key: "status", value: "observer wiring next" }
            ]
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
                    text: "live runtime surface"
                    color: root.theme.foregroundMuted
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
