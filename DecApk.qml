import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root
    signal nobtn
    signal decapk(string options)
    property int itemHeightMargin: height/20
    property int  fontSize: width/40
    MouseArea {
        anchors.fill: parent
    }

    Image {
        id: rectangle1
//        color: "#f5ffffff"
//        border.width: 0
        source: "qrc:/icons/bg.png"
        anchors.right: parent.right
        anchors.rightMargin: 50
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        anchors.top: parent.top
        anchors.topMargin: 50

        RadioButton {
            id: rb1
            text: qsTr("Decompile All")
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    exclusiveGroup: tabPositionGroup
                    property int tag: 0
                    checked: true
                }

                RadioButton {
                    id: rb2
                    text: qsTr("Decompile classes.dex")
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: rb1.bottom
                    anchors.topMargin: root.itemHeightMargin/2
                    property int tag: 1
                    exclusiveGroup: tabPositionGroup
                }

                RadioButton {
                    id: rb3
                    text: qsTr("Decompile resource")
                    anchors.top: rb2.bottom
                    anchors.topMargin: root.itemHeightMargin/2
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    property int tag: 2
                    exclusiveGroup: tabPositionGroup
                }
                ExclusiveGroup { id: tabPositionGroup }

        CheckBox {
            id: checkBox1
            text: "-b,--no-debug-info"
            anchors.topMargin: root.itemHeightMargin
            anchors.top: rb3.bottom
            anchors.left: parent.left
            anchors.leftMargin: 20
        }

        Text {
            id: text2
            y: 66
            text: qsTr("don't write out debug info (.local, .param, .line, etc.)")
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: checkBox1.verticalCenter
            anchors.left: checkBox1.right
            anchors.leftMargin: 20
            textFormat: Text.PlainText
            wrapMode: Text.WordWrap
            font.pixelSize: root.fontSize
        }

        CheckBox {
            id: checkBox2
            text: "-k,--keep-broken-res"
            anchors.top: checkBox1.bottom
            anchors.topMargin: root.itemHeightMargin
            anchors.left: parent.left
            anchors.leftMargin: 20
        }

        Text {
            id: text3
            y: 109
            font.pixelSize: root.fontSize
            text: qsTr("Use if there was an error and some resources were dropped, e.g.You will have to fix them manually before building.")
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: checkBox2.verticalCenter
            anchors.left: checkBox2.right
            anchors.leftMargin: 20
            textFormat: Text.PlainText
            wrapMode: Text.WordWrap
        }

        CheckBox {
            id: checkBox3
            text: "-m,--match-original"
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: checkBox2.bottom
            anchors.topMargin: root.itemHeightMargin
        }

        Text {
            id: text4
            y: 153
            font.pixelSize: root.fontSize
            text: qsTr("Keeps files to closest to original as possible. Prevents rebuild.")
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: checkBox3.verticalCenter
            anchors.left: checkBox3.right
            anchors.leftMargin: 20
            textFormat: Text.PlainText
            wrapMode: Text.WordWrap
        }

        TextField {
            id: textField1
            text: ""
            placeholderText: qsTr("Input extra apktool options here")
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.top: checkBox3.bottom
            anchors.topMargin: root.itemHeightMargin
            anchors.left: parent.left
            anchors.leftMargin: 20
//            font.pixelSize: 12
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

        MyButton {
            id: button1
            width: parent.width/3
            height: parent.height/12
            text: qsTr("Cancel")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            onClicked: root.nobtn()
        }

        MyButton {
            id: button2
            width: parent.width/3
            height: parent.height/12
            text: qsTr("Decompile")
            anchors.verticalCenter: button1.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
            onClicked: {
                var opt = " d -f ";
                if(tabPositionGroup.current.tag===1){
                    opt += "-r ";
                }else if(tabPositionGroup.current.tag===2){
                    opt += "-s ";
                }
                if(checkBox1.checked){
                    opt += "-b ";
                }
                if(checkBox2.checked){
                    opt += "-k ";
                }
                if(checkBox3.checked){
                    opt += "-m ";
                }
                opt += textField1.getText(0, textField1.length);
                root.decapk(opt);
            }
        }
    }


}
