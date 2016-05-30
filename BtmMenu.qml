import QtQuick 2.0

Rectangle {
    id: rectangle1
    color: "#99999999"
    signal clicked(int num)
    property alias btn1: button1.enabled
    property alias btn2: button2.enabled
    property alias btn3: button3.enabled
    property alias btn4: button4.enabled
    property alias btn5: button5.enabled
    property alias btn6: button6.enabled
    property alias btn7: button7.enabled
    property alias btn8: button8.enabled
    property alias btn9: button9.enabled
    property alias btn10: button10.enabled
    property alias btn11: button11.enabled
    property alias btn12: button12.enabled
    MouseArea {
        anchors.fill: parent
    }

    Grid {
        id: grid1
        anchors.fill: parent
        z: 1
        columns: 3
        columnSpacing: 1
        rowSpacing: 1
        property real btnWid: width/3
        property real btnHei: height/5

        MyButton {
            id: button1
            text: qsTr("Copy/Cut")
            width: parent.btnWid
            height: parent.btnHei
//            color: "#999999"
            onClicked: parent.parent.clicked(1)
        }        

        MyButton {
            id: button3
            text: qsTr("Delete")
            width: parent.btnWid
            height: parent.btnHei
//            color: "#999999"
            onClicked: parent.parent.clicked(3)
        }

        MyButton {
            id: button4
            text: qsTr("Rename")
            width: parent.btnWid
            height: parent.btnHei
//            color: "#999999"
            onClicked: parent.parent.clicked(4)
        }

        MyButton {
            id: button5
            text: qsTr("Decompile")
            width: parent.btnWid
            height: parent.btnHei
//            color: "#999999"
            onClicked: parent.parent.clicked(5)
        }

        MyButton {
            id: button6
            text: qsTr("Recompile")
            width: parent.btnWid
            height: parent.btnHei
//            color: "#999999"
            onClicked: parent.parent.clicked(6)
        }

        MyButton {
            id: button7
            text: qsTr("Sign")
            width: parent.btnWid
            height: parent.btnHei
//            color: "#999999"
            onClicked: parent.parent.clicked(7)
        }

        MyButton {
            id: button8
            text: qsTr("Open")
            width: parent.btnWid
            height: parent.btnHei
//            color: "#999999"
            onClicked: parent.parent.clicked(8)
        }

        MyButton {
            id: button9
            text: qsTr("Import")
            width: parent.btnWid
            height: parent.btnHei
//            color: "#999999"
            onClicked: parent.parent.clicked(9)
        }

        MyButton {
            id: button10
            text: qsTr("oat2dex")
            width: parent.btnWid
            height: parent.btnHei
//            color: "#999999"
            onClicked: parent.parent.clicked(10)
        }
        MyButton {
            id: button11
            text: qsTr("New")
            width: parent.btnWid
            height: parent.btnHei
  //          color: "#999999"
            onClicked: parent.parent.clicked(11)
        }
        MyButton {
            id: button12
            text: qsTr("")
            width: parent.btnWid
            height: parent.btnHei
 //           color: "#999999"
            onClicked: parent.parent.clicked(12)
        }
        MyButton {
            id: button2
            text: qsTr("Search")
            width: parent.btnWid
            height: parent.btnHei
   //         color: "#999999"
            onClicked: parent.parent.clicked(2)
        }
    }
}

