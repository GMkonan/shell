import QtQuick

Row {
    Repeater {
        model: 3
        Rectangle {
            width: 100
            height: 20
            border.width: 1
            color: "yellow"
        }
    }
}
