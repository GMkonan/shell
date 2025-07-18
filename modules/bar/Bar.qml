import Quickshell
import Quickshell.Io
import QtQuick.Controls
import QtQuick
import QtQuick.Layouts
import "../../widgets"
import "../../utils"
import "./components"

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData
      screen: modelData
      color: Qt.darker(Catppuccin.dark.base00, 1)

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 30

      RowLayout {
        id: allBlocks
        spacing: 0
        anchors.fill: parent


      }

      Clock {
        id: clockWidget

        anchors.horizontalCenter: parent.horizontalCenter
        // anchors.left: parent
        //
        // color: "red"
        // horizontalAlignment: Text.AlignHCenter
        // verticalAlignment: Text.AlignVCenter
      }
    //
    Item {
        id: child

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        implicitWidth: Math.max(osIcon.implicitWidth, workspaces.implicitWidth, activeWindow.implicitWidth, tray.implicitWidth, clock.implicitWidth, statusIcons.implicitWidth, power.implicitWidth)

        OsIcon {
            id: osIcon

            anchors.verticalCenter : parent.verticalCenter
            anchors.top: parent.top
            // anchors.bottom: parent.bottom
            anchors.topMargin: 8
        }

        }

    //   Rectangle {
    //     id: button
    //     width: 40
    //     height: 40
    //     color: "blue"
    //     signal entered()
    //     signal exited()
    //
    //     onContainsMouseChanged: {
    //     if (containsMouse) {
    //         entered()
    //     } else {
    //         exited()
    //     }
    // }
    //
    //     // text: "test"
    //     // onClicked: text.color = "blue";
    //   }
    }
  }


}
