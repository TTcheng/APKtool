import QtQuick 2.5




Image {
    id: root
    source: "qrc:/icons/bg.png"

    signal nobtn
    function createOutput(cmd, output, duration){
        var compoment = Qt.createComponent("qrc:/OutPut.qml");
        var obj = compoment.createObject(root, {"x":0, "y":100, "width": root.width, "height": root.height-200,
                                             "cmdText": cmd, "outputText": output, "durationText": qsTr("cost time: %1").arg(duration)});
    }
    ListView {
        id: listView1
        anchors.bottom: rectangle2.top
        anchors.bottomMargin: 0
        clip: true
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        orientation: ListView.Vertical
        spacing: 1
        maximumFlickVelocity: 6000
        model: mc.taskModel
//        highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
        focus: true
        delegate: Image {
            id: listItem
            height: listView1.height/8
            width: listView1.width
            opacity: ListView.isCurrentItem ? 1.0:0.5
            source: "qrc:/icons/itembg.png"
            MouseArea {
                anchors.fill: parent
                onClicked: listView1.currentIndex = index
            }

            Image {
                id: icon
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: parent.height/10
                width: height
//                asynchronous: true
                source: "image://FileImageProvider/"+model.modelData.state
                Connections {
                    target: model.modelData
                    onStateChanged: {icon.source = "";icon.source = "image://FileImageProvider/"+model.modelData.state;}
                }
            }
            Text {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    left: icon.right
                }
                wrapMode: Text.WordWrap
                text: model.modelData.cmd
                color: mc.colorValue("user/textColor")
                font.pixelSize: parent.height/6
            }
        }
        ScrollBar {
            flickable: listView1
        }
    }

    Rectangle {
        id: rectangle2
        height: root.height/7
        color: "#00000000"
        border.width: 1
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        Grid {
            id: grid1
            anchors.fill: parent
            spacing: 1
            rows: 2
            columns: 3
            property real btnWid: width/3
            property real btnHei: height/2
            property int  fs: btnHei/3

            MyButton {
                id: myButton1
                text: qsTr("Stop selected")
                width: parent.btnWid
                height: parent.btnHei
                fontsize: parent.fs
                enabled:  mc.taskModel.length===0?false:(mc.taskModel[listView1.currentIndex].state === "task_running")
                onClicked: mc.taskModel[listView1.currentIndex].stopTask()
            }

            MyButton {
                id: myButton2
                text: qsTr("Read output")
                width: parent.btnWid
                height: parent.btnHei
                fontsize: parent.fs
                enabled:  mc.taskModel.length===0?false:(mc.taskModel[listView1.currentIndex].state !== "task_running")
                onClicked: createOutput(mc.taskModel[listView1.currentIndex].cmd, mc.taskModel[listView1.currentIndex].output, mc.taskModel[listView1.currentIndex].duration)
            }

            MyButton {
                id: myButton3
                text: qsTr("Remove task")
                width: parent.btnWid
                height: parent.btnHei
                fontsize: parent.fs
                enabled: mc.taskModel.length===0?false:true
                onClicked: mc.removeTask(listView1.currentIndex)
            }

            MyButton {
                id: myButton4
                text: qsTr("Remove finished")
                width: parent.btnWid
                height: parent.btnHei
                fontsize: parent.fs
                enabled: mc.taskModel.length===0?false:true
                onClicked: mc.removeFinishedTasks()
            }

            MyButton {
                id: myButton5
                text: qsTr("Stop all")
                width: parent.btnWid
                height: parent.btnHei
                fontsize: parent.fs
                enabled: mc.taskModel.length===0?false:true
                onClicked: mc.stopAllTasks();
            }

            MyButton {
                id: myButton6
                text: qsTr("Back")
                width: parent.btnWid
                height: parent.btnHei
                fontsize: parent.fs
                onClicked: root.nobtn()
            }
        }
    }

}
