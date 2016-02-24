import QtQuick 2.0

Item {
    id: root
    signal deletebtn
    signal nobtn
    MouseArea {
        anchors.fill: parent
    }
    Rectangle {
        id: row
        height: parent.height/16
        width: parent.width*5/7
        anchors.centerIn: parent

        color: "#99ffffff"
        MyButton {
            id: yesBtn
            anchors.left: parent.left
            width: parent.width/3
            text: qsTr("YES")
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            onClicked: root.deletebtn()
        }

        MyButton {
            id: noBtn
            anchors.right: parent.right
             width: parent.width/3
             text: qsTr("NO")
             anchors.bottom: parent.bottom
             anchors.top: parent.top
             onClicked: root.nobtn()
        }

    }
    Text {
        anchors.bottom: row.top
        anchors.bottomMargin: parent.height/10
        text: qsTr("Delete selected files?")
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: parent.width/20
        font.bold: true
        color: mc.colorValue("user/textColor")
    }
}
