import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import "../"
import "root:/"

Rectangle {
    id: root
    Layout.preferredWidth: statusRow.implicitWidth + 20
    Layout.preferredHeight: 30
    radius: 10
    color: mouseArea.containsMouse ? Theme.get.backgroundStrongColor : "transparent"

    property var audioSink: Pipewire.defaultAudioSink
    property string battery: ""
    property bool hasBattery: false
    property string bluetoothIcon: bluetoothEnabled ? (connectedDevice ? "󰂯" : "󰂯") : "󰂲"
    property bool bluetoothEnabled: false
    property string connectedDevice: ""
    property bool showBluetooth: bluetoothEnabled || connectedDevice !== ""

    property string networkType: "none"
    property bool networkConnected: false
    property string networkIcon: getNetworkIcon()
    property string wifiSSID: ""
    property int wifiSignal: 0

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
        onObjectsChanged: {
            audioSink = Pipewire.defaultAudioSink;
        }
    }

    RowLayout {
        id: statusRow
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: audioSink?.audio?.muted ? "󰖁" : "󰕾"
            color: Theme.get.primaryHoverColor
            font.pixelSize: 16
            font.family: "Symbols Nerd Font Mono"
        }

        Text {
            visible: networkConnected
            text: networkIcon
            color: Theme.get.primaryHoverColor
            font.pixelSize: 16
            font.family: "Symbols Nerd Font Mono"
        }

        Text {
            visible: showBluetooth
            text: bluetoothIcon
            color: Theme.get.primaryHoverColor
            font.pixelSize: 16
            font.family: "Symbols Nerd Font Mono"
        }

        Text {
            visible: hasBattery
            text: battery || "󰂂"
            color: Theme.get.primaryHoverColor
            font.pixelSize: 16
            font.family: "Symbols Nerd Font Mono"
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: togglePopup()
    }

    Behavior on color {
        ColorAnimation {
            duration: 200
        }
    }

    PopupWindow {
        id: statusPopup
        width: 300
        height: 400
        visible: false

        anchor {
            window: root.QsWindow?.window
            edges: Edges.Bottom
            gravity: Edges.Top
        }

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
                onTriggered: statusPopup.visible = false
            }

            Rectangle {
                anchors.fill: parent
                color: Theme.get.backgroundColor
                border.color: "#3c3c3c"
                border.width: 1
                radius: 8

                Column {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    Text {
                        text: "System Status"
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#3c3c3c"
                    }

                    Column {
                        width: parent.width
                        spacing: 12

                        Text {
                            text: "Audio"
                            color: "white"
                            font.pixelSize: 14
                            font.bold: true
                        }

                        Row {
                            width: parent.width
                            spacing: 10

                            Text {
                                text: audioSink?.audio?.muted ? "󰖁" : "󰕾"
                                color: Theme.get.primaryHoverColor
                                font.pixelSize: 18
                                font.family: "Symbols Nerd Font Mono"
                            }

                            Slider {
                                id: volumeSlider
                                width: parent.width - 100
                                from: 0
                                to: 1
                                value: audioSink?.audio?.volume || 0
                                onValueChanged: {
                                    if (audioSink?.audio) {
                                        audioSink.audio.volume = value;
                                    }
                                }

                                background: Rectangle {
                                    x: volumeSlider.leftPadding
                                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                    width: volumeSlider.availableWidth
                                    height: 4
                                    radius: 2
                                    color: "#3c3c3c"

                                    Rectangle {
                                        width: volumeSlider.visualPosition * parent.width
                                        height: parent.height
                                        color: Theme.get.primaryHoverColor
                                        radius: 2
                                    }
                                }

                                handle: Rectangle {
                                    x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                    width: 16
                                    height: 16
                                    radius: 8
                                    color: volumeSlider.pressed ? Theme.get.primaryHoverColor : "#ffffff"
                                    border.color: "#3c3c3c"
                                }
                            }

                            Text {
                                text: Math.round((audioSink?.audio?.volume || 0) * 100) + "%"
                                color: "white"
                                font.pixelSize: 12
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 35
                            color: muteMouseArea.containsMouse ? "#3c3c3c" : "transparent"
                            radius: 4

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                text: audioSink?.audio?.muted ? "Unmute" : "Mute"
                                color: "white"
                                font.pixelSize: 12
                            }

                            MouseArea {
                                id: muteMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    if (audioSink?.audio) {
                                        audioSink.audio.muted = !audioSink.audio.muted;
                                    }
                                }
                            }
                        }

                        Rectangle {
                            visible: hasBattery
                            width: parent.width
                            height: childrenRect.height
                            color: "transparent"

                            Column {
                                width: parent.width
                                spacing: 8

                                Text {
                                    text: "Battery"
                                    color: "white"
                                    font.pixelSize: 14
                                    font.bold: true
                                }

                                Text {
                                    text: battery
                                    color: Theme.get.primaryHoverColor
                                    font.pixelSize: 12
                                }
                            }
                        }

                        Rectangle {
                            visible: networkConnected
                            width: parent.width
                            height: childrenRect.height
                            color: "transparent"

                            Column {
                                width: parent.width
                                spacing: 8

                                Text {
                                    text: "Network"
                                    color: "white"
                                    font.pixelSize: 14
                                    font.bold: true
                                }

                                Row {
                                    spacing: 10

                                    Text {
                                        text: networkIcon
                                        color: Theme.get.primaryHoverColor
                                        font.pixelSize: 16
                                        font.family: "Symbols Nerd Font Mono"
                                    }

                                    Column {
                                        Text {
                                            text: networkType === "wifi" ? `WiFi: ${wifiSSID}` : networkType === "ethernet" ? "Ethernet Connected" : "No Connection"
                                            color: "white"
                                            font.pixelSize: 12
                                        }

                                        Text {
                                            visible: networkType === "wifi" && wifiSignal > 0
                                            text: `Signal: ${wifiSignal}%`
                                            color: "#888888"
                                            font.pixelSize: 10
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            visible: bluetoothEnabled
                            width: parent.width
                            height: childrenRect.height
                            color: "transparent"

                            Column {
                                width: parent.width
                                spacing: 8

                                Text {
                                    text: "Bluetooth"
                                    color: "white"
                                    font.pixelSize: 14
                                    font.bold: true
                                }

                                Row {
                                    spacing: 10

                                    Text {
                                        text: bluetoothIcon
                                        color: Theme.get.primaryHoverColor
                                        font.pixelSize: 16
                                        font.family: "Symbols Nerd Font Mono"
                                    }

                                    Text {
                                        text: connectedDevice ? connectedDevice : "No device connected"
                                        color: connectedDevice ? "white" : "#888888"
                                        font.pixelSize: 12
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 35
                                    color: btToggleMouseArea.containsMouse ? "#3c3c3c" : "transparent"
                                    radius: 4

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 10
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: bluetoothEnabled ? "Turn Off Bluetooth" : "Turn On Bluetooth"
                                        color: "white"
                                        font.pixelSize: 12
                                    }

                                    MouseArea {
                                        id: btToggleMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: toggleBluetooth()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Process {
        id: batteryCheck
        command: ["sh", "-c", "test -d /sys/class/power_supply/BAT*"]
        running: true
        onExited: function (exitCode) {
            hasBattery = exitCode === 0;
        }
    }

    Process {
        id: batteryProc
        command: ["sh", "-c", "echo $(cat /sys/class/power_supply/BAT*/capacity),$(cat /sys/class/power_supply/BAT*/status)"]
        running: hasBattery

        stdout: SplitParser {
            onRead: function (data) {
                const [capacityStr, status] = data.trim().split(',');
                const capacity = parseInt(capacityStr);
                let batteryIcon = "󰂂";
                if (capacity <= 20)
                    batteryIcon = "󰁺";
                else if (capacity <= 40)
                    batteryIcon = "󰁽";
                else if (capacity <= 60)
                    batteryIcon = "󰁿";
                else if (capacity <= 80)
                    batteryIcon = "󰂁";
                else
                    batteryIcon = "󰂂";

                const symbol = status === "Charging" ? "🔌" : batteryIcon;
                battery = `${symbol} ${capacity}%`;
                console.log(battery);
            }
        }
    }

    Process {
        id: bluetoothStatusProc
        command: ["sh", "-c", "bluetoothctl show | grep 'Powered:' | awk '{print $2}'"]
        running: true

        stdout: SplitParser {
            onRead: function (data) {
                const powered = data.trim();
                bluetoothEnabled = powered === "yes";
            }
        }

        onExited: function (exitCode) {
            if (exitCode !== 0) {
                bluetoothEnabled = false;
            }
        }
    }

    Process {
        id: connectedDeviceProc
        command: ["sh", "-c", "bluetoothctl devices Connected | head -1 | cut -d' ' -f3-"]
        running: bluetoothEnabled

        stdout: SplitParser {
            onRead: function (data) {
                const device = data.trim();
                connectedDevice = device || "";
            }
        }

        onExited: function (exitCode) {
            if (exitCode !== 0) {
                connectedDevice = "";
            }
        }
    }

    Process {
        id: bluetoothToggleProc
        running: false

        onExited: function (exitCode) {
            bluetoothStatusProc.running = true;
        }
    }

    Process {
        id: networkStatusProc
        command: ["sh", "-c", "nmcli -t -f DEVICE,TYPE,STATE device status | grep -E '(ethernet|wifi)' | grep -w 'connected'"]
        running: true

        stdout: SplitParser {
            onRead: function (data) {
                const lines = data.trim().split('\n');
                let hasEthernet = false;
                let hasWifi = false;

                for (const line of lines) {
                    if (!line)
                        continue;
                    const [device, type, state] = line.split(':');
                    if (state === 'connected') {
                        if (type === 'ethernet' && !device.startsWith('veth') && !device.startsWith('br-') && device !== 'docker0') {
                            hasEthernet = true;
                            networkType = "ethernet";
                            break;
                        } else if (type === 'wifi') {
                            hasWifi = true;
                            networkType = "wifi";
                        }
                    }
                }

                if (hasEthernet) {
                    networkType = "ethernet";
                } else if (hasWifi) {
                    networkType = "wifi";
                } else {
                    networkType = "none";
                }

                networkConnected = hasEthernet || hasWifi;
            }
        }

        onExited: function (exitCode) {
            if (exitCode !== 0) {
                networkConnected = false;
                networkType = "none";
            }
        }
    }

    Process {
        id: wifiDetailsProc
        command: ["sh", "-c", "nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi | grep '^yes:'"]
        running: networkType === "wifi"

        stdout: SplitParser {
            onRead: function (data) {
                const parts = data.trim().split(':');
                if (parts.length >= 3) {
                    wifiSSID = parts[1] || "Unknown";
                    wifiSignal = parseInt(parts[2]) || 0;
                }
            }
        }

        onExited: function (exitCode) {
            if (exitCode !== 0) {
                wifiSSID = "";
                wifiSignal = 0;
            }
        }
    }

    Timer {
        interval: 1000
        running: hasBattery
        repeat: true
        onTriggered: batteryProc.running = true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            bluetoothStatusProc.running = true;
            networkStatusProc.running = true;
            if (bluetoothEnabled) {
                connectedDeviceProc.running = true;
            }
            if (networkType === "wifi") {
                wifiDetailsProc.running = true;
            }
        }
    }

    function togglePopup() {
        if (root.QsWindow?.window?.contentItem) {
            statusPopup.anchor.rect = root.QsWindow.window.contentItem.mapFromItem(root, 0, -statusPopup.height - 5, root.width, root.height);
            statusPopup.visible = !statusPopup.visible;
        }
    }

    function toggleBluetooth() {
        if (bluetoothEnabled) {
            bluetoothToggleProc.command = ["bluetoothctl", "power", "off"];
        } else {
            bluetoothToggleProc.command = ["bluetoothctl", "power", "on"];
        }
        bluetoothToggleProc.running = true;
    }

    function getNetworkIcon() {
        switch (networkType) {
        case "wifi":
            return "󰖩";
        case "ethernet":
            return "󰈀";
        default:
            return "󰈂";
        }
    }
}
