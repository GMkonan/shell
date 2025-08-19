import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "blocks" as Blocks
import "utils" as Utils
import "./bar"
import "root:/"

BarBlock {
    id: root
    Layout.preferredWidth: 30

    // Placeholder for now
    // will probably use applications button as trigger?
    content: BarText {
        text: ""
        pointSize: 12
        color: Theme.get.iconColor
    }

    PopupWindow {
        id: sidebarWindow
        width: 300
        height: 1020 // not the best but for now height is hardcoded
        visible: false
        color: "transparent"

        anchor {
            item: root
            // edges: Edges.Top
            gravity: Edges.Bottom
            rect.y: parentWindow.height + 5
        }

        FocusScope {
            anchors.fill: parent
            focus: true

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onExited: {
                    if (!containsMouse) {
                        closeTimer.start();
                    }
                }
                onEntered: closeTimer.stop()

                Timer {
                    id: closeTimer
                    interval: 500
                    onTriggered: sidebarWindow.visible = false
                }

                Rectangle {
                    // match the size of the window
                    anchors.fill: parent

                    radius: 5
                    color: Theme.get.bg

                    Row {

                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.topMargin: 5
                        spacing: 3
                        RoundButton {
                            id: powerButton
                            text: "⏻"

                            implicitWidth: 32
                            implicitHeight: 32

                            background: Rectangle {
                                anchors.fill: parent
                                radius: parent.width / 2
                                color: powerButton.hovered ? Theme.get.buttonBackgroundColor : "transparent"
                            }

                            // Text styling
                            font.pixelSize: 24
                            font.bold: true

                            contentItem: Text {
                                text: powerButton.text
                                font: powerButton.font
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            // Hover and press animations
                            PropertyAnimation on scale {
                                id: scaleAnimation
                                duration: 100
                                easing.type: Easing.OutQuad
                            }

                            // onPressed: {
                            //     scaleAnimation.to = 0.95;
                            //     scaleAnimation.start();
                            // }

                            ToolTip.visible: hovered
                            ToolTip.text: "Power Off"
                            ToolTip.delay: 500

                            onClicked: {
                                Quickshell.execDetached(["bash", "-c", `systemctl poweroff || loginctl poweroff`]);
                            }
                        }

                        RoundButton {
                            id: rebootButton
                            text: "↻"
                            implicitWidth: 32
                            implicitHeight: 32

                            background: Rectangle {
                                anchors.fill: parent
                                radius: parent.width / 2
                                color: rebootButton.hovered ? Theme.get.buttonBackgroundColor : "transparent"
                            }

                            // Text styling
                            font.pixelSize: 24
                            font.bold: true

                            contentItem: Text {
                                text: rebootButton.text
                                font: rebootButton.font
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            // Hover and press animations
                            PropertyAnimation on scale {
                                id: scaleAnimation2
                                duration: 100
                                easing.type: Easing.OutQuad
                            }

                            // onPressed: {
                            //     scaleAnimation.to = 0.95;
                            //     scaleAnimation.start();
                            // }

                            ToolTip.visible: hovered
                            ToolTip.text: "Reboot"
                            ToolTip.delay: 500
                            onClicked: {
                                Quickshell.execDetached(["bash", "-c", `reboot || loginctl reboot`]);
                            }
                        }
                    }
                }
            }
        }
    }
    onClicked: function () {
        sidebarWindow.visible = !sidebarWindow.visible;
    }
}
