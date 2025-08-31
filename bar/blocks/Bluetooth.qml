import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "../"

BarBlock {
  id: bluetoothBlock
  property string bluetoothStatus: "off"
  property string connectedDevice: ""
  property bool bluetoothEnabled: false
  property string bluetoothIcon: bluetoothEnabled ? (connectedDevice ? "󰂯" : "󰂯") : "󰂲"
  
  content: BarText {
    symbolText: connectedDevice ? `${bluetoothIcon} ${connectedDevice}` : bluetoothIcon
  }

  onClicked: function() {
    if (bluetoothEnabled) {
      bluetoothToggleProc.command = ["bluetoothctl", "power", "off"]
    } else {
      bluetoothToggleProc.command = ["bluetoothctl", "power", "on"]
    }
    bluetoothToggleProc.running = true
  }

  // Check Bluetooth power status
  Process {
    id: bluetoothStatusProc
    command: ["sh", "-c", "bluetoothctl show | grep 'Powered:' | awk '{print $2}'"]
    running: true

    stdout: SplitParser {
      onRead: function(data) {
        const powered = data.trim()
        bluetoothEnabled = powered === "yes"
        bluetoothStatus = powered === "yes" ? "on" : "off"
      }
    }

    onExited: function(exitCode) {
      if (exitCode !== 0) {
        bluetoothEnabled = false
        bluetoothStatus = "unavailable"
      }
    }
  }

  // Get connected devices
  Process {
    id: connectedDeviceProc
    command: ["sh", "-c", "bluetoothctl devices Connected | head -1 | cut -d' ' -f3-"]
    running: bluetoothEnabled

    stdout: SplitParser {
      onRead: function(data) {
        const device = data.trim()
        connectedDevice = device || ""
      }
    }

    onExited: function(exitCode) {
      if (exitCode !== 0) {
        connectedDevice = ""
      }
    }
  }

  // Toggle Bluetooth power
  Process {
    id: bluetoothToggleProc
    running: false

    onExited: function(exitCode) {
      // Refresh status after toggle
      bluetoothStatusProc.running = true
    }
  }

  // Refresh timer
  Timer {
    interval: 3000
    running: true
    repeat: true
    onTriggered: {
      bluetoothStatusProc.running = true
      if (bluetoothEnabled) {
        connectedDeviceProc.running = true
      }
    }
  }

  // Tooltip showing detailed info
  ToolTip {
    id: tooltip
    visible: bluetoothBlock.mouseArea.containsMouse
    delay: 1000
    text: {
      if (!bluetoothEnabled) return "Bluetooth: Off"
      if (connectedDevice) return `Bluetooth: Connected to ${connectedDevice}`
      return "Bluetooth: On (No devices connected)"
    }
  }
}