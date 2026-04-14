import QtQuick
import Quickshell
import "components" as Components
import "services" as Services

ShellRoot {
    Theme {
        id: theme
    }

    Services.SessionBridge {
        id: sessionBridge
    }

    FloatingWindow {
        id: window
        visible: true
        implicitWidth: 1480
        implicitHeight: 920
        minimumSize: Qt.size(1120, 720)
        title: "ARIA-03 Workbench"
        color: "transparent"

        Components.AppWindow {
            anchors.fill: parent
            theme: theme
            sessionBridge: sessionBridge
        }
    }

    Connections {
        target: Quickshell

        function onLastWindowClosed() {
            Qt.quit();
        }
    }
}
