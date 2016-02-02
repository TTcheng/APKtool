import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: root
    signal cpbtn(bool cover)
    signal cutbtn(bool cover)
    signal nobtn
    Rectangle {
        id: row
        height: parent.height/16
        width: parent.width/2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: height

        color: "#99ffffff"
        MyButton {
            id: cpBtn
            anchors.left: parent.left
            width: parent.width/3
            text: qsTr("Copy")
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            onClicked: root.cpbtn(checkbox1.checked)
        }

        MyButton {
            id: noBtn
            anchors.right: parent.right
            width: parent.width/3
            text: qsTr("Cancel")
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            onClicked: root.nobtn()
        }

        MyButton {
            id: cutBtn
            text: qsTr("Cut")
            anchors.right: noBtn.left
            anchors.rightMargin: 0
            anchors.left: cpBtn.right
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            onClicked: root.cutbtn(checkbox1.checked)
        }

    }

    Rectangle {
        id: rectangle1
        anchors.bottom: row.top
        anchors.bottomMargin: height/2
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#aaffffff"
        height:  parent.height/18
        width: parent.width/2

        CheckBox {
            id: checkbox1
            anchors.fill: parent
            text: qsTr("Cover existing files")
            checked: true

        }
    }
}
