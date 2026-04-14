import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    required property var theme

    property bool sidebarCollapsed: false
    property bool inspectorOpen: true
    property bool diffFocus: true
    property real sidebarWidth: theme.sidebarWidth

    function tint(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha);
    }

    color: root.theme.background
    radius: root.theme.radius + 2
    border.width: 1
    border.color: root.tint(root.theme.outline, 0.92)

    Rectangle {
        anchors.fill: parent
        anchors.margins: 10
        radius: root.theme.radius + 3
        color: root.tint(root.theme.shadow, 0.16)
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: 1
        radius: root.theme.radius + 2
        color: root.tint(root.theme.backgroundOverlay, 0.95)
        border.width: 1
        border.color: root.tint(root.theme.foregroundSoft, 0.08)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: root.theme.headerHeight
            radius: root.theme.radius
            color: root.theme.backgroundRaised
            border.width: 1
            border.color: root.tint(root.theme.outline, 0.72)

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 8

                Rectangle {
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 28
                    radius: root.theme.radiusTight
                    color: sidebarToggle.pressed ? root.theme.backgroundElevated : root.theme.backgroundOverlay
                    border.width: 1
                    border.color: root.tint(root.theme.outline, 0.86)

                    Text {
                        anchors.centerIn: parent
                        text: root.sidebarCollapsed ? "›" : "‹"
                        color: root.theme.foregroundSoft
                        font.family: root.theme.fontFamily
                        font.pixelSize: root.theme.textSize
                    }

                    MouseArea {
                        id: sidebarToggle
                        anchors.fill: parent
                        onClicked: root.sidebarCollapsed = !root.sidebarCollapsed
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 10
                    Layout.preferredHeight: 10
                    radius: root.theme.radiusTight
                    color: root.theme.accent
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: "ARIA-03 workbench"
                        color: root.theme.foreground
                        font.family: root.theme.fontFamily
                        font.pixelSize: root.theme.titleSize
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: "pi-quickshell-app · personal workspace · real chat + live delegation"
                        color: root.theme.foregroundMuted
                        font.family: root.theme.fontFamily
                        font.pixelSize: root.theme.textSizeTiny
                    }
                }

                RowLayout {
                    spacing: 6

                    Repeater {
                        model: [
                            { label: root.diffFocus ? "Diff focus on" : "Diff focus off", active: root.diffFocus, action: function() { root.diffFocus = !root.diffFocus; } },
                            { label: root.inspectorOpen ? "Inspector on" : "Inspector off", active: root.inspectorOpen, action: function() { root.inspectorOpen = !root.inspectorOpen; } }
                        ]

                        delegate: Rectangle {
                            required property var modelData
                            radius: root.theme.radiusTight
                            color: modelData.active ? root.tint(root.theme.accent, 0.18) : root.theme.backgroundOverlay
                            border.width: 1
                            border.color: modelData.active ? root.tint(root.theme.accentBright, 0.7) : root.tint(root.theme.outline, 0.76)
                            implicitWidth: buttonLabel.implicitWidth + 18
                            implicitHeight: 28

                            Text {
                                id: buttonLabel
                                anchors.centerIn: parent
                                text: parent.modelData.label
                                color: parent.modelData.active ? root.theme.cream : root.theme.foregroundSoft
                                font.family: root.theme.fontFamily
                                font.pixelSize: root.theme.textSizeTiny
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: parent.modelData.action()
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Sidebar {
                Layout.preferredWidth: root.sidebarCollapsed ? root.theme.sidebarCollapsedWidth : root.sidebarWidth
                Layout.fillHeight: true
                theme: root.theme
                collapsed: root.sidebarCollapsed
                diffFocus: root.diffFocus
            }

            Rectangle {
                Layout.preferredWidth: root.sidebarCollapsed ? 0 : 8
                Layout.fillHeight: true
                color: "transparent"
                visible: !root.sidebarCollapsed

                Rectangle {
                    anchors.centerIn: parent
                    width: 2
                    height: parent.height - 24
                    radius: 1
                    color: resizeHover.hovered ? root.tint(root.theme.accentBright, 0.65) : root.tint(root.theme.outline, 0.85)
                }

                HoverHandler {
                    id: resizeHover
                    cursorShape: Qt.SizeHorCursor
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.SizeHorCursor
                    property real pressX: 0
                    property real originWidth: 0
                    onPressed: mouse => {
                        pressX = mouse.x;
                        originWidth = root.sidebarWidth;
                    }
                    onPositionChanged: mouse => {
                        if (!pressed)
                            return;
                        root.sidebarWidth = Math.max(250, Math.min(420, originWidth + mouse.x - pressX));
                    }
                }
            }

            ChatPane {
                Layout.fillWidth: true
                Layout.fillHeight: true
                theme: root.theme
                diffFocus: root.diffFocus
            }

            InspectorDrawer {
                Layout.preferredWidth: root.inspectorOpen ? root.theme.inspectorWidth : 0
                Layout.fillHeight: true
                visible: width > 0
                theme: root.theme
            }
        }
    }
}
