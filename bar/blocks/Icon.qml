import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "blocks" as Blocks
import "utils" as Utils
import "../"
import "root:/"

BarBlock {
    id: root
    Layout.preferredWidth: 30

    content: BarText {
        text: ""
        pointSize: 12
        color: Theme.get.iconColor
    }

    PopupWindow {
        id: sidebarWindow
        width: 350
        height: 300
        visible: false
        color: "transparent"

        anchor {
            item: root
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
                    anchors.fill: parent
                    radius: 5
                    color: Theme.get.bg

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 0

                        RowLayout {
                            Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                            spacing: 3

                            Rectangle {
                                width: 80
                                height: 80
                                radius: width / 2
                                clip: true
                                color: "transparent"

                                // Image {
                                //     anchors.fill: parent
                                //     source: "path/to/your/image.png"
                                //     fillMode: Image.PreserveAspectCrop
                                // }
                            }
                        }

                        // TOP ROW - Buttons
                        RowLayout {
                            Layout.alignment: Qt.AlignTop | Qt.AlignRight
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
                                font.pixelSize: 24
                                font.bold: true
                                contentItem: Text {
                                    text: powerButton.text
                                    font: powerButton.font
                                    color: "white"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
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
                                font.pixelSize: 24
                                font.bold: true
                                contentItem: Text {
                                    text: rebootButton.text
                                    font: rebootButton.font
                                    color: "white"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                ToolTip.visible: hovered
                                ToolTip.text: "Reboot"
                                ToolTip.delay: 500
                                onClicked: {
                                    Quickshell.execDetached(["bash", "-c", `reboot || loginctl reboot`]);
                                }
                            }
                        }

                        // Spacer to push SystemTray2 to bottom
                        Item {
                            Layout.fillHeight: true
                        }

                        // BOTTOM ROW - SystemTray2
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                            SystemTray2 {}
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
