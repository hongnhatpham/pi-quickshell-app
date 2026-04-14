import QtQuick
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
    implicitHeight: 76

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        Rectangle {
            Layout.preferredWidth: 26
            Layout.preferredHeight: 26
            radius: root.theme.radiusTight
            color: root.tint(root.theme.accent, 0.16)
            border.width: 1
            border.color: root.tint(root.theme.accentBright, 0.66)

            Text {
                anchors.centerIn: parent
                text: ">"
                color: root.theme.cream
                font.family: root.theme.fontFamily
                font.pixelSize: root.theme.textSize
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: root.theme.radiusTight
            color: root.theme.background
            border.width: 1
            border.color: root.tint(root.theme.foregroundSoft, 0.14)

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: "Ask Pi, inspect workers, or drill into diffs from here…"
                color: root.theme.foregroundMuted
                font.family: root.theme.fontFamily
                font.pixelSize: root.theme.textSize
            }
        }

        Rectangle {
            Layout.preferredWidth: 98
            Layout.preferredHeight: 34
            radius: root.theme.radiusTight
            color: root.theme.backgroundOverlay
            border.width: 1
            border.color: root.tint(root.theme.outline, 0.76)

            Text {
                anchors.centerIn: parent
                text: "send"
                color: root.theme.foregroundSoft
                font.family: root.theme.fontFamily
                font.pixelSize: root.theme.textSizeTiny
                font.capitalization: Font.AllUppercase
                font.letterSpacing: 0.8
            }
        }
    }
}
