import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import "../utils" as Utils
import "root:/"
import QtQuick.Effects

RowLayout {

    Rectangle {
        id: statusIconBar
        Layout.preferredWidth: 50 // Math.max(60, Utils.HyprlandUtils.maxWorkspace * 28)
        Layout.preferredHeight: 24
        radius: 10
        color: Theme.get.backgroundStrongColor

        MouseArea {
            anchors.fill: parent
            onClicked: GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen
        }

        Row {
            anchors.centerIn: parent
            spacing: 10

            Sound {}
        }
    }
}
