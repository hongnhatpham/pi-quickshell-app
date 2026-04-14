import QtQuick
import Quickshell
import "components" as Components

ShellRoot {
    Theme {
        id: theme
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
        }
    }

    Connections {
        target: Quickshell

        function onLastWindowClosed() {
            Qt.quit();
        }
    }
}
