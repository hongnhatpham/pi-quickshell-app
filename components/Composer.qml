import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    required property var theme
    required property var sessionBridge

    function tint(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    function submit() {
        if (root.sessionBridge.sendPrompt(promptInput.text))
            promptInput.text = "";
    }

    color: root.theme.backgroundRaised
    radius: root.theme.radius
    border.width: 1
    border.color: root.tint(root.theme.outline, 0.72)
    implicitHeight: 92

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
            border.color: promptInput.activeFocus
                ? root.tint(root.theme.accentBright, 0.48)
                : root.tint(root.theme.foregroundSoft, 0.14)

            TextArea {
                id: promptInput
                anchors.fill: parent
                anchors.margins: 8
                wrapMode: TextEdit.Wrap
                color: root.theme.foreground
                font.family: root.theme.fontFamily
                font.pixelSize: root.theme.textSize
                placeholderText: "Ask Pi, inspect workers, or drill into diffs from here…"
                placeholderTextColor: root.theme.foregroundMuted
                selectionColor: root.tint(root.theme.accentBright, 0.28)
                selectByMouse: true
                readOnly: root.sessionBridge.running

                Keys.onPressed: event => {
                    if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && !(event.modifiers & Qt.ShiftModifier)) {
                        event.accepted = true;
                        root.submit();
                    }
                }
            }
        }

        ColumnLayout {
            Layout.preferredWidth: 120
            Layout.fillHeight: true
            spacing: 8

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 36
                radius: root.theme.radiusTight
                color: root.sessionBridge.running ? root.theme.backgroundOverlay : root.tint(root.theme.accent, 0.16)
                border.width: 1
                border.color: root.sessionBridge.running
                    ? root.tint(root.theme.outline, 0.76)
                    : root.tint(root.theme.accentBright, 0.72)

                Text {
                    anchors.centerIn: parent
                    text: root.sessionBridge.running ? "working" : "send"
                    color: root.sessionBridge.running ? root.theme.foregroundMuted : root.theme.cream
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 0.8
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: !root.sessionBridge.running
                    onClicked: root.submit()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 28
                radius: root.theme.radiusTight
                color: root.theme.backgroundOverlay
                border.width: 1
                border.color: root.tint(root.theme.outline, 0.72)

                Text {
                    anchors.centerIn: parent
                    text: root.sessionBridge.running ? "turn in progress" : `turns ${root.sessionBridge.completedTurns}`
                    color: root.theme.foregroundSoft
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 28
                radius: root.theme.radiusTight
                color: root.theme.backgroundOverlay
                border.width: 1
                border.color: root.tint(root.theme.outline, 0.72)

                Text {
                    anchors.centerIn: parent
                    text: root.sessionBridge.running ? "locked" : (root.sessionBridge.lastError.length ? "clear session" : "session ready")
                    color: root.sessionBridge.running
                        ? root.theme.foregroundMuted
                        : (root.sessionBridge.lastError.length ? root.theme.terracottaBright : root.theme.foregroundMuted)
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: !root.sessionBridge.running
                    onClicked: root.sessionBridge.clearConversation()
                }
            }
        }
    }
}
