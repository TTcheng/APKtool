import QtQuick 2.0
import per.pqy.filedialog 1.0


Image {
    id: root
    signal chooseFile(string type, string filepath)

    property string ftype: null
    source: "image://ThemeProvider/bg"

    MyFileDialog {
        id: fd
        Component.onCompleted: {setcurrentPath(mc.currentPath);setFilter("*.png,*.jpg"); }
        onFileModelChanged: {
            myButton2.enabled = false;
        }
        onClickFile: {
            myButton2.enabled = true;
        }
    }

    Text {
        id: text1
        x: 229
        text: qsTr("Choose a file")
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        textFormat: Text.PlainText
        color: mc.colorValue("user/textColor")
//        font.pixelSize: 12
    }

    MyButton {
        id: myButton1
        y: 451
        width: parent.width/4
        height: width/2
        text: qsTr("Cancel")
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        onClicked: root.destroy()
    }

    MyButton {
        id: myButton2
        x: 459
        y: 466
        width: parent.width/4
        height: width/2
        text: qsTr("Choose")
        anchors.verticalCenter: myButton1.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
        onClicked:{ root.chooseFile(ftype, fd.currentPath+"/"+fd.fileModel[listView1.currentIndex].name); root.destroy(); }
    }

    ListView {
        id: listView1
        flickDeceleration: 3000
        maximumFlickVelocity: 8000
        clip: true
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: myButton1.top
        anchors.bottomMargin: 10
        anchors.top: text1.bottom
        anchors.topMargin: 10
        model: fd.fileModel
        delegate: Image{
            id: listItem
            height: listView1.height/9
            width: listView1.width
            source: "image://ThemeProvider/itembg"
            opacity: ListView.isCurrentItem ? 1.0:0.7
            MouseArea {
                           anchors.fill: parent
                           onClicked: {listView1.currentIndex = index; fd.singlePress(model.modelData.name); }
            }
            Image {
                                 id: icon
                                 anchors.left: parent.left
                                 anchors.top: parent.top
                                 anchors.bottom: parent.bottom
                                 anchors.margins: listItem.height/10
                                 width: height
                                 asynchronous: true
                                 cache: false
                                 source: "image://FileImageProvider/"+fd.currentPath+"/"+model.modelData.name
            }
            Text {
                text: model.modelData.name
                color: mc.colorValue("user/textColor")
                height: parent.height*2/3
                font.pixelSize: height*4/7
                anchors.left: icon.right
                anchors.verticalCenter: parent.verticalCenter
            }

        }
    }

}
