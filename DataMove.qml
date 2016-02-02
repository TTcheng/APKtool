import QtQuick 2.0
import QtQuick.Controls 1.4

Rectangle {
    id: root
    signal nobtn
    MouseArea {
        id: mouseArea1
        anchors.fill: parent

        TextArea {
            id: textArea1
            text: qsTr("If your /data partition size is small, you can move app data to current path and \
save about 50MB. Or move back to /data for faster speed.")
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        MyButton {
            id: myButton1
            height: parent.height/15
            width: parent.width/4
            text: qsTr("Cancel")
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.verticalCenter: parent.verticalCenter
            onClicked: root.nobtn()
        }

        MyButton {
            id: myButton2
            height: parent.height/15
            width: parent.width/4
            text: qsTr("Move")
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.verticalCenter: myButton1.verticalCenter
            onClicked: mc.moveData();
        }
    }
}
