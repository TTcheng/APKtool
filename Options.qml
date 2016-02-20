import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.2

Rectangle {
    color: "#ffffff"
    border.width: 0

    Label {
        id: label1
        x: 0
        y: 8
        color: "#040404"
        text: "ROOT"
    }

    CheckBox {
        id: checkBox1
        x: 560
        y: 6
        text: "On"
    }

    Label {
        id: label2
        x: 2
        y: 59
        text: qsTr("Label")
    }

}
