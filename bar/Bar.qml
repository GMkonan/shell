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

            RowLayout {
                id: allBlocks
                spacing: 0
                anchors.fill: parent

                // Left side
                RowLayout {
                    id: leftBlocks
                    spacing: 10
                    Layout.alignment: Qt.AlignLeft

                    Layout.leftMargin: 10
                    Layout.fillWidth: true

                    Blocks.Icon {}
                    Blocks.Workspaces {}
                }

                // Without this filler item, the active window block will be centered
                // despite setting left alignment
                // Center Items
                RowLayout {

                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true

                    Blocks.Date {}
                }

                // Right side
                RowLayout {
                    id: rightBlocks
                    spacing: 0

                    Layout.rightMargin: 10

                    Layout.alignment: Qt.AlignRight
                    Layout.fillWidth: true

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
                    Blocks.Memory {}
                    // Blocks.Sound {}
                    Blocks.Battery {}
                    Blocks.StatusIcons {}
                    Blocks.Time {}
                    // Will deal with sidebar later
                    // Sidebar {}
                }
            }
        }
    }
}
