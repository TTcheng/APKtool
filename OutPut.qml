import QtQuick 2.0
import QtQuick.Controls 1.4

Image {
    id: root
    property int  fontSize: width/40 < 20?20:width/40
    property color textColor: mc.colorValue("user/textColor")
    property alias durationText: duration.text
    property alias cmdText: command.text
    property alias outputText: output.text
    source: "qrc:/icons/bg.png"
    MouseArea{
        anchors.fill: parent
    }

    Text {
        id: duration
        x: 290
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        textFormat: Text.PlainText
        wrapMode: Text.WordWrap
        color: root.textColor
        font.pixelSize: root.fontSize*2
    }

    Text {
        id: command
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: duration.bottom
        anchors.topMargin: 20
        textFormat: Text.PlainText
        wrapMode: Text.WordWrap
        font.pixelSize: fontSize
        color: root.textColor
    }

    TextArea {
        id: output
        anchors.bottom: button1.top
        anchors.bottomMargin: 20
        clip: true
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: command.bottom
        anchors.topMargin: 20
        activeFocusOnPress: false
        readOnly: true
        font.pixelSize: fontSize
        backgroundVisible: false
        textColor: root.textColor
    }

    MyButton {
        id: button1
        width: parent.width/3
        height: parent.height/15
        text: qsTr("Copy")
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        onClicked: {output.selectAll(); output.copy(); output.deselect();}
    }

    MyButton {
        id: button2
        width: parent.width/3
        height: parent.height/15
        text: qsTr("OK")
        anchors.verticalCenter: button1.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        onClicked: root.destroy()
    }

}
