import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root
    signal rgst(string regKey)
    //    signal bugreport
    signal nobtn
    Component.onCompleted: textfield.forceActiveFocus()
    MouseArea {
        anchors.fill: parent
    }


    TextField {
        width: parent.width*5/7
        height:  parent.height/20
        anchors.top: parent.top
        anchors.topMargin: parent.height/10
        anchors.horizontalCenter: parent.horizontalCenter
        Component.onCompleted: paste()

        id: textfield
        placeholderText: qsTr("Input your key, please.")
        font.pixelSize: parent.width/20
        //            textColor: "orange"
        horizontalAlignment: TextEdit.AlignHCenter
        style: TextFieldStyle {
            textColor: "orange"
            background: Rectangle {
                radius: 2
                opacity: 0.1
                implicitWidth: 100
                implicitHeight: 24
                border.color: "#333"
                border.width: 1
            }
        }


    }



    Rectangle {
        id: row
        height: parent.height/15
        width: parent.width*5/7
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: textfield.bottom
        anchors.topMargin:  parent.height/10
        //        antialiasing: false
        color: "#88ffffff"
        MyButton {
            id: yesBtn

            anchors.left: parent.left
            width: parent.width/3
            text: qsTr("Register")
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            onClicked: root.rgst(textfield.getText(0,12))
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
    }

}
