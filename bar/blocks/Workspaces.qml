import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import "../utils" as Utils
import "root:/"
import QtQuick.Effects

RowLayout {
    property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    Rectangle {
        id: workspaceBar
        Layout.preferredWidth: Math.max(60, Utils.HyprlandUtils.maxWorkspace * 28)
        Layout.preferredHeight: 24
        radius: 10
        color: Theme.get.backgroundStrongColor

        Row {
            anchors.centerIn: parent
            spacing: 10

            Repeater {
                model: Utils.HyprlandUtils.maxWorkspace || 1

                Item {
                    required property int index
                    property bool focused: Hyprland.focusedMonitor?.activeWorkspace?.id === (index + 1)

                    width: workspaceText.width
                    height: workspaceText.height

                    Text {
                        id: workspaceText
                        text: focused ? "" : ""
                        color: Theme.get.primaryHoverColor
                        font.pixelSize: 16
                        // font.bold: focused
                    }

                    // Rectangle {
                    //     visible: focused
                    //     anchors {
                    //         left: workspaceText.left
                    //         right: workspaceText.right
                    //         top: workspaceText.bottom
                    //         topMargin: -3
                    //     }
                    //     height: 2
                    //     color: "white"
                    // }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Utils.HyprlandUtils.switchWorkspace(index + 1)
                    }
                }
            }
        }
    }
}
