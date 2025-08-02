import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "blocks" as Blocks
import "utils" as Utils
import "root:/"

Scope {

    PanelWindow {
        visible: GlobalStates.sidebarRightOpen
        width: 300
        color: "transparent"
        margins {
            top: 10
            bottom: 10
            right: 1
        }
        // focusable: true
        aboveWindows: true
        anchors {
            top: true
            bottom: true
            right: true
        }

        // https://quickshell.org/docs/v0.1.0/types/Quickshell.Wayland/WlrLayershell/#layer
        // https://github.com/end-4/dots-hyprland/blob/8e366cfc8496b08497f349f194197a0f9a03c0e7/.config/quickshell/ii/modules/sidebarRight/SidebarRight.qml
        // WlrLayershell.namespace: "quickshell:sidebar"
        // WlrLayershell.layer: WlrLayer.Bottom

        function hide() {
            GlobalStates.sidebarRightOpen = false;
        }

        // HyprlandFocusGrab {
        //     id: grab
        //     windows: [sidebarRoot]
        //     active: GlobalStates.sidebarRightOpen
        //     onCleared: () => {
        //         if (!active)
        //             sidebarRoot.hide();
        //     }
        // }

        // Loader {
        //     id: sidebarContentLoader
        //     active: GlobalStates.sidebarRightOpen
        //     anchors {
        //         top: parent.top
        //         bottom: parent.bottom
        //         right: parent.right
        //         left: parent.left
        //         topMargin: 2
        //         rightMargin: 2
        //         bottomMargin: 2
        //         leftMargin: 2
        //     }
        //     width: 300
        //     height: parent.height
        //
        //     focus: GlobalStates.sidebarRightOpen
        //     Keys.onPressed: event => {
        //         if (event.key === Qt.Key_Escape) {
        //             sidebarRoot.hide();
        //         }
        //     }
        // }
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
