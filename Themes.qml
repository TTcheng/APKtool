import QtQuick 2.0
import QtQuick.Controls 1.4


Rectangle {
    id: root
    color: "black"
    signal nobtn
    property int itemMargin: height/18

    function fileDialog(type){
        //type means bg/buttonbg/itembg
        var compoment =  Qt.createComponent("qrc:/FileDialog.qml");
        var obj = compoment.createObject(root, {"width": root.width, "height": root.height*2/3, "anchors.centerIn": root, "ftype": type});
        obj.chooseFile.connect(setTheme);
    }

    function setTheme(type, filename){
        mc.setTheme(type, filename);
    }

    function refreshIcon(){

        myButton9.source = "";
        myButton10.source = "";
        myButton11.source = "";
        image1.source = "";
        image2.source = "";
        image4.source = "";


        myButton9.source = "image://ThemeProvider/buttonbg";
        myButton10.source = "image://ThemeProvider/buttonbg";
        myButton11.source = "image://ThemeProvider/buttonbg";
        image1.source = "image://ThemeProvider/bg";
        image2.source = "image://ThemeProvider/itembg";
        image4.source = "image://ThemeProvider/itembg";

    }

    Connections {
        target: mc
        onThemeChanged: refreshIcon()
    }
    MouseArea {
        anchors.fill: parent
    }

    MyButton {
        id: myButton1
        x: 155
        y: 19
        width: parent.width/4
        height: parent.height/18
        text: qsTr("custom")
        anchors.verticalCenter: myButton2.verticalCenter
        anchors.right: myButton2.left
        anchors.rightMargin: 0
        onClicked: fileDialog("bg")
    }

    MyButton {
        id: myButton2
        x: 213
        width: parent.width/4
        height: parent.height/18
        text: qsTr("preset")
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        onClicked: mc.setTheme("bg", "");

    }

    MyButton {
        id: myButton3
        x: 181
        y: 58
        width: parent.width/4
        height: parent.height/18
        text: qsTr("custom")
        anchors.right: myButton4.left
        anchors.rightMargin: 0
        anchors.verticalCenter: myButton4.verticalCenter
        onClicked: fileDialog("itembg")
    }

    MyButton {
        id: myButton4
        x: 272
        width: parent.width/4
        height: parent.height/18
        text: qsTr("preset")
        anchors.top: myButton2.bottom
        anchors.topMargin: itemMargin
        anchors.right: parent.right
        anchors.rightMargin: 0
        onClicked: mc.setTheme("itembg", "");
    }

    MyButton {
        id: myButton5
        x: 181
        y: 93
        width: parent.width/4
        height: parent.height/18
        text: qsTr("custom")
        anchors.verticalCenter: myButton6.verticalCenter
        anchors.right: myButton6.left
        anchors.rightMargin: 0
        onClicked: fileDialog("buttonbg")
    }

    MyButton {
        id: myButton6
        x: 261
        width: parent.width/4
        height: parent.height/18
        text: qsTr("preset")
        anchors.top: myButton4.bottom
        anchors.topMargin: itemMargin
        anchors.right: parent.right
        anchors.rightMargin: 0
        onClicked: mc.setTheme("buttonbg", "");
    }

    Image {
        id: image1
        x: 140
        width: parent.width*2/3
        anchors.top: myButton5.bottom
        anchors.topMargin: itemMargin
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        cache: false
        source: "image://ThemeProvider/bg"

        Image {
            id: image2
            height: parent.height/15
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            cache: false
            source: "image://ThemeProvider/itembg"

            Image {
                id: image3
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: image2.height/10
                width: height
                source: "qrc:/icons/folder.png"
            }

            Text {
                id: text5
                text: qsTr("Test Text")
                height: parent.height*2/3
                font.pixelSize: height*4/7
                anchors.left: image3.right
            }
        }

        Image {
            id: image4
            height: parent.height/15
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: image2.bottom
            anchors.topMargin: 1
            cache: false
            source: "image://ThemeProvider/itembg"

            Image {
                id: image5
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: image4.height/10
                width: height
                source: "qrc:/icons/file.png"
            }

            Text {
                id: text6
                text: qsTr("Test Text")
                height: parent.height*2/3
                font.pixelSize: height*4/7
                anchors.left: image5.right
            }
        }

        Text {
            anchors.centerIn: parent
            text: qsTr("This is the preview, your changes will be applied after relaunch this app.")
            font.pixelSize: parent.width/10
            width: parent.width
            wrapMode: Text.Wrap
        }

        MyButton {
            id: myButton9
            y: 354
            height: parent.height/15
            text: "Test"
            width: parent.width/3
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            cache: false
        }

        MyButton {
            id: myButton10
            y: 354
            height: parent.height/15
            text: "Test"
            width: parent.width/3
            anchors.left: myButton9.right
            anchors.leftMargin: 0
            anchors.verticalCenter: myButton9.verticalCenter
            cache: false
        }

        MyButton {
            id: myButton11
            y: 354
            height: parent.height/15
            text: "Test"
            width: parent.width/3
            anchors.left: myButton10.right
            anchors.leftMargin: 0
            anchors.verticalCenter: myButton9.verticalCenter
            cache: false
        }
    }

    Text {
        id: text1
        y: 8
        text: qsTr("background")
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: myButton2.verticalCenter
        //        font.pixelSize: 12
        color: "white"
    }

    Text {
        id: text2
        y: 32
        text: qsTr("file item background")
        anchors.verticalCenter: myButton4.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 0
        //        font.pixelSize: 12
        color: "white"
    }

    Text {
        id: text3
        y: 59
        text: qsTr("button background")
        anchors.verticalCenter: myButton6.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 0
        //        font.pixelSize: 12
        color: "white"
    }


}
