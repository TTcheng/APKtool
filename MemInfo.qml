import QtQuick 2.0

Item {
    id: item1
    property alias totaltext: text1.text
    property alias freetext: text2.text
    property alias rectHei: rectangle2.height
    property color textColor: mc.colorValue("user/textColor")
    Rectangle {
        id: rectangle1
        anchors.fill: parent
        opacity: 0.2
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.lighter("gray");}
            GradientStop { position: 1.0; color: "gray";}
        }

        Rectangle {
            id: rectangle2
            opacity: 0.7
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#ffffff" }
                GradientStop { position: 1.0; color: "gray";}
            }
        }
    }

    Text {
        id: text1
        opacity: 0.4
        textFormat: Text.PlainText
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        color: item1.textColor
        //        font.pixelSize: 12
    }

    Text {
        id: text2
        x: 0
        y: 21
        anchors.top: rectangle1.top
        anchors.topMargin: rectangle1.height - rectangle2.height
        opacity: 0.4
        anchors.left: parent.left
        anchors.leftMargin: 0
        textFormat: Text.PlainText
        color: item1.textColor
        //            font.pixelSize: 12
    }

}
