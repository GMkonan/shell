import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "blocks" as Blocks
import "utils" as Utils
import "root:/"
import Quickshell.Services.Mpris

Scope {
    IpcHandler {
        target: "bar"

        function toggleVis(): void {
            // Toggle visibility of all bar instances
            for (let i = 0; i < Quickshell.screens.length; i++) {
                barInstances[i].visible = !barInstances[i].visible;
            }
        }
    }

    property var barInstances: []

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            Component.onCompleted: {
                barInstances.push(bar);
            }

            color: "transparent"

            Rectangle {
                id: highlight
                anchors.fill: parent
                color: Theme.get.backgroundColor
            }

            height: 40

            visible: true

            anchors {
                top: Theme.get.onTop
                bottom: !Theme.get.onTop
                left: true
                right: true
            }

            Item {
                anchors.fill: parent

                // Left section - anchored to left
                RowLayout {
                    id: leftBlocks
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                    spacing: 10

                    Blocks.Icon {}
                }

                // Center section - absolutely centered
                RowLayout {
                    id: centerBlocks
                    anchors.centerIn: parent
                    spacing: 0

                    Blocks.Workspaces {}
                }

                // Right section - anchored to right
                RowLayout {
                    id: rightBlocks
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 10
                    spacing: 0

                    Text {
                        Layout.rightMargin: 3
                        text: Utils.KeyboardLayoutService.currentLayout
                        font.pixelSize: 16
                        color: "#fff"
                    }

                    Text {
                        Layout.rightMargin: 3
                        text: MprisPlayer.trackTitle
                        font.pixelSize: 16
                        color: "#fff"
                    }
                    // Blocks.Memory {}
                    // Blocks.Sound {}
                    // Blocks.Bluetooth {}
                    // Blocks.Battery {}
                    Blocks.StatusGroup {}
                    // Blocks.StatusIcons {}

                    // Blocks.Date {}
                    Blocks.Time {}
                    // Will deal with sidebar later
                    // Sidebar {}
                }
            }
        }
    }
}
