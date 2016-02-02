import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root
    signal newfilebtn(string newName,bool type) //false: folder; true: file
    signal nobtn
    MouseArea {
        anchors.fill: parent
    }
    Component.onCompleted: keyTE.forceActiveFocus()
    Rectangle {
        id: row
        height: parent.height/16
        width: parent.width*5/7
        anchors.centerIn: parent
        color: "#99ffffff"
        MyButton {
            id: fileBtn
            anchors.left: parent.left
            width: parent.width/3
            text: qsTr("Folder")
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            onClicked: root.newfilebtn(keyTE.getText(0,keyTE.length>100?100:keyTE.length),false)
        }
        MyButton {
            id: folderBtn
            anchors.left: fileBtn.right
            text: qsTr("File")
            anchors.right: noBtn.left
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            onClicked: root.newfilebtn(keyTE.getText(0,keyTE.length>100?100:keyTE.length),true)
        }

        MyButton {
            id: noBtn
            anchors.right: parent.right
            width: parent.width/3
            text: qsTr("Cancel")
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            onClicked: {
                root.nobtn();
            }
        }

    }

    TextField {
        id: keyTE
        x: 91
        y: 189
        anchors.bottom: row.top
        anchors.bottomMargin: height

        width: parent.width*5/7
        height:  parent.height/20
        anchors.horizontalCenter: parent.horizontalCenter

        font.pixelSize: parent.width/20
        style: TextFieldStyle {
            textColor: "orange"
            background: Rectangle {
                radius: 2
                opacity: 0.1
                implicitWidth: 100
                implicitHeight: root.height/18
                border.color: "#333"
                border.width: 1
            }
        }
    }
}
