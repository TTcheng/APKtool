import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4


Item {
    id: root
    signal nobtn
    signal recapk(string options, string aapt, bool rootPerm)
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

        CheckBox {
            id: checkBox1
            text: "-c,--copy-original"
            anchors.topMargin: root.itemHeightMargin
            anchors.top: aapt50.bottom
            anchors.left: parent.left
            anchors.leftMargin: 20
        }

        Text {
            id: text2
            y: 66
            text: qsTr("Copies original AndroidManifest.xml and META-INF.")
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
            text: "-f,--force-all"
            checked: true
            anchors.top: checkBox1.bottom
            anchors.topMargin: root.itemHeightMargin
            anchors.left: parent.left
            anchors.leftMargin: 20
        }

        Text {
            id: text3
            y: 109
            font.pixelSize: root.fontSize
            text: qsTr("Skip changes detection and build all files.")
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: checkBox2.verticalCenter
            anchors.left: checkBox2.right
            anchors.leftMargin: 20
            textFormat: Text.PlainText
            wrapMode: Text.WordWrap
        }

        TextField {
            id: textField1
            text: ""
            anchors.topMargin: root.itemHeightMargin
            placeholderText: qsTr("Input extra apktool options here")
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.top: checkBox2.bottom
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
            height: parent.height/15
            text: qsTr("Cancel")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            onClicked: {
                root.nobtn();
            }
        }

        MyButton {
            id: button2
            width: parent.width/3
            height: parent.height/15
            text: qsTr("Recompile")
            anchors.verticalCenter: button1.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
            onClicked: {

                var opt = " b ";
                if(checkBox1.checked){
                    opt += "-c ";
                }
                if(checkBox2.checked){
                    opt += "-f ";
                }
                opt += textField1.getText(0, textField1.length);
                opt += " ";
                root.recapk(opt, tabPositionGroup.current.text, checkBox3.checked);
            }
        }

        RadioButton {
            id: aapt60
            text: "aapt6.0"
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 20
            exclusiveGroup: tabPositionGroup
            Component.onCompleted: checked = mc.aapt=== text
        }

        RadioButton {
            id: aapt51
            x: 20
            text: "aapt5.1"
            anchors.top: aapt60.bottom
            anchors.topMargin: root.itemHeightMargin/2
            exclusiveGroup: tabPositionGroup
            Component.onCompleted: checked = mc.aapt=== text
        }

        RadioButton {
            id: aapt50
            text: "aapt5.0"
            anchors.top: aapt51.bottom
            anchors.topMargin: root.itemHeightMargin/2
            anchors.left: parent.left
            anchors.leftMargin: 20
            exclusiveGroup: tabPositionGroup
            Component.onCompleted: checked = mc.aapt=== text
        }
        ExclusiveGroup { id: tabPositionGroup }

        CheckBox {
            id: checkBox3
            text: qsTr("run as root")
            anchors.top: textField1.bottom
            anchors.topMargin:  root.itemHeightMargin
            anchors.left: parent.left
            anchors.leftMargin: 20
            enabled: mc.hasRoot()
            checked: true
        }

    }


}
