import QtQuick 2.0
import QtQuick.Controls 1.4
import per.pqy.key 1.0

Item {
    id: regInfo
    signal nobtn
    MouseArea {
        anchors.fill: parent
        onClicked: regInfo.nobtn()
    }

    Text {
        id: msg
        anchors.centerIn: parent
        text: qsTr("activated version\nkey: %1").arg(regInfo.key.userKey(false))
        font.pixelSize: parent.width/20
        font.bold: true
        color: "orange"
    }
}
