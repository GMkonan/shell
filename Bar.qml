import Quickshell
import Quickshell.Io
import QtQuick.Controls
import QtQuick
import "Widgets" as Widgets

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

      Widgets.Clock {
        id: clockWidget
        // anchors.left: parent
        //
        // color: "red"
        // horizontalAlignment: Text.AlignHCenter
        // verticalAlignment: Text.AlignVCenter
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
