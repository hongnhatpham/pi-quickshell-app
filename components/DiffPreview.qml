import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property var theme
    property bool expanded: false

    function tint(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    color: root.theme.backgroundOverlay
    radius: root.theme.radiusTight
    border.width: 1
    border.color: root.tint(root.theme.outline, 0.72)
    implicitHeight: expanded ? 208 : 116

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: "changed files"
                color: root.theme.foregroundMuted
                font.family: root.theme.fontFamily
                font.pixelSize: root.theme.textSizeTiny
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 0.8
            }

            Rectangle {
                Layout.preferredWidth: 64
                Layout.preferredHeight: 22
                radius: root.theme.radiusTight
                color: root.tint(root.theme.accent, 0.14)
                border.width: 1
                border.color: root.tint(root.theme.accentBright, 0.56)

                Text {
                    anchors.centerIn: parent
                    text: root.expanded ? "focused" : "inline"
                    color: root.theme.cream
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "Theme.qml · AppWindow.qml"
                color: root.theme.foregroundSoft
                font.family: root.theme.fontFamily
                font.pixelSize: root.theme.textSizeTiny
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 14

            Column {
                spacing: 4

                Text {
                    text: "+ 84"
                    color: root.theme.oliveBright
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSize
                    font.weight: Font.DemiBold
                }

                Text {
                    text: "insertions"
                    color: root.theme.foregroundMuted
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }
            }

            Column {
                spacing: 4

                Text {
                    text: "- 12"
                    color: root.theme.terracottaBright
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSize
                    font.weight: Font.DemiBold
                }

                Text {
                    text: "removals"
                    color: root.theme.foregroundMuted
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: root.theme.radiusTight
            color: root.theme.background
            border.width: 1
            border.color: root.tint(root.theme.outline, 0.65)

            Column {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 2

                Text {
                    text: "@@ app shell scaffold"
                    color: root.theme.foregroundMuted
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }

                Text {
                    text: "+ FloatingWindow { title: \"ARIA-03 Workbench\" }"
                    color: root.theme.oliveBright
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }

                Text {
                    text: "+ Sidebar { threads, delegation, runtime }"
                    color: root.theme.oliveBright
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }

                Text {
                    text: "+ InspectorDrawer { extensions, settings, runtime }"
                    color: root.theme.oliveBright
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }

                Text {
                    visible: root.expanded
                    text: "- Panel-style transient geometry"
                    color: root.theme.terracottaBright
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }

                Text {
                    visible: root.expanded
                    text: "+ conversation-first center pane with inline diff preview"
                    color: root.theme.oliveBright
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }
            }
        }
    }
}
