import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    required property var theme
    required property bool diffFocus

    function tint(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha);
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
                    text: root.diffFocus ? "diffs surfaced inline and in focus panes" : "diffs surfaced inline"
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

                Rectangle {
                    width: parent.width
                    implicitHeight: introColumn.implicitHeight + 20
                    radius: root.theme.radius
                    color: root.theme.backgroundRaised
                    border.width: 1
                    border.color: root.tint(root.theme.outline, 0.7)

                    Column {
                        id: introColumn
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 6

                        Text {
                            text: "You"
                            color: root.theme.foregroundMuted
                            font.family: root.theme.fontFamily
                            font.pixelSize: root.theme.textSizeTiny
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: 0.8
                        }

                        Text {
                            text: "Let's build the first real QuickShell app shell and keep chat, delegated tasks, and diffs together in one window."
                            wrapMode: Text.Wrap
                            color: root.theme.foreground
                            font.family: root.theme.fontFamily
                            font.pixelSize: root.theme.textSize
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    implicitHeight: replyColumn.implicitHeight + 22
                    radius: root.theme.radius
                    color: root.theme.background
                    border.width: 1
                    border.color: root.tint(root.theme.foregroundSoft, 0.10)

                    Column {
                        id: replyColumn
                        anchors.fill: parent
                        anchors.margins: 11
                        spacing: 8

                        Text {
                            text: "ARIA-03"
                            color: root.theme.accentBright
                            font.family: root.theme.fontFamily
                            font.pixelSize: root.theme.textSizeTiny
                            font.capitalization: Font.AllUppercase
                            font.letterSpacing: 0.8
                        }

                        Text {
                            text: "This first scaffold uses a standalone FloatingWindow, a collapsible task-aware sidebar, a conversation-first center pane, and a toggleable inspector. The diff stays in the thread first and can expand into a sharper focused surface later."
                            wrapMode: Text.Wrap
                            color: root.theme.foreground
                            font.family: root.theme.fontFamily
                            font.pixelSize: root.theme.textSize
                        }

                        Rectangle {
                            width: parent.width
                            implicitHeight: 34
                            radius: root.theme.radiusTight
                            color: root.tint(root.theme.indigo, 0.16)
                            border.width: 1
                            border.color: root.tint(root.theme.indigoBright, 0.56)

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 8

                                Text {
                                    text: "subagent"
                                    color: root.theme.indigoBright
                                    font.family: root.theme.fontFamily
                                    font.pixelSize: root.theme.textSizeTiny
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: "theme inheritance complete · sidebar grammar confirmed · QuickShell window primitive under review"
                                    color: root.theme.foregroundSoft
                                    font.family: root.theme.fontFamily
                                    font.pixelSize: root.theme.textSizeTiny
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        DiffPreview {
                            width: parent.width
                            theme: root.theme
                            expanded: root.diffFocus
                        }
                    }
                }
            }
        }

        Composer {
            Layout.fillWidth: true
            theme: root.theme
        }
    }
}
