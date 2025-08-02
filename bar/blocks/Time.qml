import QtQuick
import "../"
import "../../"

BarBlock {
    id: text
    // color: "#cba6f7"
    // color: Theme.get.barBgColor
    content: BarText {
        // 
        symbolText: `${Datetime.time}`
    }
}
