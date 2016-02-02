import QtQuick 2.0


Rectangle {
    id: setting
    color: "grey"
    signal clicked(int btn)
    Column {
        id: column1
        anchors.fill: parent
        spacing: 1
        property int btnWid: width
        property int btnHei: (height-4)/5


        MyButton {
            width: parent.btnWid
            height: parent.btnHei

            text: qsTr("Task")
            onClicked: setting.clicked(1)
        }
        MyButton {
            width: parent.btnWid
            height: parent.btnHei

            text: qsTr("Register")
            onClicked:setting.clicked(2)
        }
        MyButton {
            width: parent.btnWid
            height: parent.btnHei

            text: qsTr("Help")
            onClicked:setting.clicked(3)
        }
        MyButton {
            width: parent.btnWid
            height: parent.btnHei

            text: qsTr("Theme")
            onClicked:setting.clicked(4)
        }
        /*
        MyButton {
            width: parent.btnWid
            height: parent.btnHei

            text: qsTr("Data Movement")
            onClicked:setting.clicked(5)
        }
        */
        MyButton {
            width: parent.btnWid
            height: parent.btnHei

            text: qsTr("Quit")
            onClicked: setting.clicked(6)
        }
    }

}

