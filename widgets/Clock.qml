// import QtQuick
// import "root:/Data" as Data
// Text {
//   text: Data.Time.time
// }
//
import QtQuick
// import QtQuick.Controls
// import Quickshell

Item {
  id: clockRoot
  width: 50
  height: 50

  Rectangle {
    id: clockBackground
    width: 50
    height: 50
    color: "blue"

    Text {
      id: clockText
      anchors.centerIn: parent
      font.pixelSize: 14
      font.bold: true
      color: "red"
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: Qt.formatTime(new Date(), "HH:mm")
    }

  }

  Timer {
    interval: 60000
    running: true
    repeat: true
    onTriggered: clockText.text = Qt.formatTime(new Date(), "HH:mm")
  }
}
