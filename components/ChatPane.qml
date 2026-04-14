import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    required property var theme
    required property bool diffFocus
    required property var sessionBridge

    function tint(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    function bubbleTone(role) {
        if (role === "user")
            return root.theme.backgroundRaised;
        if (role === "assistant")
            return root.theme.background;
        return root.theme.backgroundOverlay;
    }

    function bubbleBorder(role) {
        if (role === "user")
            return root.tint(root.theme.outline, 0.7);
        if (role === "assistant")
            return root.tint(root.theme.foregroundSoft, 0.10);
        return root.tint(root.theme.outline, 0.6);
    }

    color: root.theme.backgroundOverlay
    radius: root.theme.radius
    border.width: 1
    border.color: root.tint(root.theme.outline, 0.74)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 38
            radius: root.theme.radiusTight
            color: root.theme.backgroundRaised
            border.width: 1
            border.color: root.tint(root.theme.outline, 0.66)

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                Text {
                    text: "main thread"
                    color: root.theme.foreground
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSize
                    font.weight: Font.DemiBold
                }

                Text {
                    text: "·"
                    color: root.theme.foregroundMuted
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSize
                }

                Text {
                    text: root.sessionBridge.statusText
                    color: root.sessionBridge.running ? root.theme.oliveBright : root.theme.foregroundMuted
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: root.diffFocus ? "diffs inline + focus" : "diffs inline"
                    color: root.theme.foregroundMuted
                    font.family: root.theme.fontFamily
                    font.pixelSize: root.theme.textSizeTiny
                }
            }
        }

        ScrollView {
            id: threadScroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            Column {
                width: threadScroll.availableWidth
                spacing: 12

                Rectangle {
                    visible: root.sessionBridge.messages.length === 0
                    width: parent.width
                    implicitHeight: emptyStateColumn.implicitHeight + 24
                    radius: root.theme.radius
                    color: root.theme.backgroundRaised
                    border.width: 1
                    border.color: root.tint(root.theme.outline, 0.72)

                    Column {
                        id: emptyStateColumn
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Text {
                            text: "No conversation yet"
                            color: root.theme.foreground
                            font.family: root.theme.fontFamily
                            font.pixelSize: root.theme.titleSize
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: "This bridge now runs real Pi prompts into a dedicated session file for this app window. Send something and the center pane will stream actual model output instead of static placeholder text."
                            wrapMode: Text.Wrap
                            color: root.theme.foregroundSoft
                            font.family: root.theme.fontFamily
                            font.pixelSize: root.theme.textSize
                        }
                    }
                }

                Repeater {
                    model: root.sessionBridge.messages

                    delegate: Rectangle {
                        required property var modelData
                        width: parent.width
                        implicitHeight: bubbleColumn.implicitHeight + 22
                        radius: root.theme.radius
                        color: root.bubbleTone(modelData.role)
                        border.width: 1
                        border.color: root.bubbleBorder(modelData.role)

                        Column {
                            id: bubbleColumn
                            anchors.fill: parent
                            anchors.margins: 11
                            spacing: 8

                            Text {
                                text: modelData.role === "user" ? "You" : "ARIA-03"
                                color: modelData.role === "user" ? root.theme.foregroundMuted : root.theme.accentBright
                                font.family: root.theme.fontFamily
                                font.pixelSize: root.theme.textSizeTiny
                                font.capitalization: Font.AllUppercase
                                font.letterSpacing: 0.8
                            }

                            Text {
                                text: modelData.text && modelData.text.length ? modelData.text : (modelData.role === "assistant" && root.sessionBridge.running ? "…" : "")
                                wrapMode: Text.Wrap
                                color: root.theme.foreground
                                font.family: root.theme.fontFamily
                                font.pixelSize: root.theme.textSize
                            }

                            DiffPreview {
                                visible: modelData.role === "assistant" && index === root.sessionBridge.messages.length - 1 && !!modelData.text && modelData.text.length > 0
                                width: parent.width
                                theme: root.theme
                                expanded: root.diffFocus
                            }
                        }
                    }
                }

                Rectangle {
                    visible: root.sessionBridge.activity.length > 0
                    width: parent.width
                    implicitHeight: activityColumn.implicitHeight + 20
                    radius: root.theme.radius
                    color: root.theme.backgroundRaised
                    border.width: 1
                    border.color: root.tint(root.theme.outline, 0.7)

                    Column {
                        id: activityColumn
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 6

                        Text {
                            text: "session activity"
                            color: root.theme.foregroundMuted
                            font.family: root.theme.fontFamily
                            font.pixelSize: root.theme.textSizeTiny
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: 0.8
                        }

                        Repeater {
                            model: root.sessionBridge.activity

                            delegate: Rectangle {
                                required property var modelData
                                width: parent.width
                                implicitHeight: 30
                                radius: root.theme.radiusTight
                                color: modelData.tone === "error"
                                    ? root.tint(root.theme.terracotta, 0.14)
                                    : (modelData.tone === "success"
                                        ? root.tint(root.theme.olive, 0.14)
                                        : (modelData.tone === "accent"
                                            ? root.tint(root.theme.accent, 0.14)
                                            : root.theme.backgroundOverlay))
                                border.width: 1
                                border.color: modelData.tone === "error"
                                    ? root.tint(root.theme.terracottaBright, 0.56)
                                    : (modelData.tone === "success"
                                        ? root.tint(root.theme.oliveBright, 0.56)
                                        : (modelData.tone === "accent"
                                            ? root.tint(root.theme.accentBright, 0.56)
                                            : root.tint(root.theme.outline, 0.66)))

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.left: parent.left
                                    anchors.leftMargin: 8
                                    anchors.right: parent.right
                                    anchors.rightMargin: 8
                                    text: modelData.text
                                    elide: Text.ElideRight
                                    color: modelData.tone === "error"
                                        ? root.theme.terracottaBright
                                        : root.theme.foregroundSoft
                                    font.family: root.theme.fontFamily
                                    font.pixelSize: root.theme.textSizeTiny
                                }
                            }
                        }
                    }
                }
            }
        }

        Composer {
            Layout.fillWidth: true
            theme: root.theme
            sessionBridge: root.sessionBridge
        }
    }
}
