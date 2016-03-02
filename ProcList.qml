import QtQuick 2.5




Image {
    id: root
    source: "qrc:/icons/bg.png"

//    signal nobtn
    function sendSig(s){
        mc.sendSignal(mc.procModel[listView1.currentIndex].pid, s);
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
        spacing: 5
        maximumFlickVelocity: 6000
        model: mc.procModel
        focus: true
        Component.onCompleted: mc.getProcList()
        //        headerPositioning: ListView.OverlayHeader
        header: Row {
            height: listView1.height/mc.intValue("user/itemNum")
            width: listView1.width
            Item {
                height: parent.height
                width: parent.width/3
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Process")
                    color : mc.colorValue("user/textColor")
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mc.sortProc(0);
                    }
                }
            }

            Item {

                height: parent.height
                width: parent.width/6
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "ppid "
                    color : mc.colorValue("user/textColor")
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mc.sortProc(4);
                    }
                }
            }

            Item {

                height: parent.height
                width: parent.width/6
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "pid"
                    color : mc.colorValue("user/textColor")
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mc.sortProc(3);
                    }
                }
            }
            Item {

                height: parent.height
                width: parent.width/6
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("memory")
                    color : mc.colorValue("user/textColor")
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mc.sortProc(2);
                    }
                }
            }
            Item {
                height: parent.height
                width: parent.width/6
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("user")
                    color : mc.colorValue("user/textColor")
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mc.sortProc(1);
                    }
                }
            }
        }

        delegate: Rectangle {
            id: listItem
            height: listView1.height/mc.intValue("user/itemNum")
            width: listView1.width
            opacity: ListView.isCurrentItem ? 1.0:0.5
            MouseArea {
                anchors.fill: parent
                onClicked: listView1.currentIndex = index;
            }

            Item {
                id: procName
                height: parent.height
                width: parent.width/3
                anchors.left: parent.left
                Text {
                    anchors.top: parent.top
                    text: model.modelData.name
                    color : mc.colorValue("user/textColor")

                }

            }
            Item {
                id: procPpid
                height: parent.height
                width: parent.width/6
                anchors.left: procName.right
                Text {
                    anchors.bottom: parent.bottom
                    text: model.modelData.ppid.toString()
                    color : Qt.lighter(mc.colorValue("user/textColor"))
                }
            }

            Item {
                id: procPid
                height: parent.height
                width: parent.width/6
                anchors.left: procPpid.right
                Text {
                    anchors.bottom: parent.bottom
                    text: model.modelData.pid.toString()
                    color : Qt.lighter(mc.colorValue("user/textColor"))
                }

            }
            Item {
                id: procMem
                height: parent.height
                width: parent.width/6
                anchors.left: procPid.right
                Text {
                    anchors.bottom: parent.bottom
                    text: model.modelData.mem.toString()
                    color : Qt.lighter(mc.colorValue("user/textColor"))
                }

            }

            Item {
                id: procUser
                height: parent.height
                width: parent.width/6
                anchors.left: procMem.right
                Text {
                    anchors.bottom: parent.bottom
                    text: model.modelData.user
                    color : Qt.lighter(mc.colorValue("user/textColor"))
                }

            }


        }
        ScrollBar {
            flickable: listView1
        }
    }

    Rectangle {
        id: rectangle2
        height: root.height/14
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
            rows: 1
            columns: 3
            property real btnWid: width/3
            property real btnHei: height
            property int  fs: btnHei/3

            MyButton {
                id: myButton1
                text: qsTr("Refresh")
                width: parent.btnWid
                height: parent.btnHei
                fontsize: parent.fs
                onClicked: mc.getProcList()
            }

            MyButton {
                id: myButton2
                text: qsTr("Send Signal")
                width: parent.btnWid
                height: parent.btnHei
                fontsize: parent.fs
                enabled: mc.hasRoot()
                onClicked:  {
                    var obj = Qt.createComponent("qrc:/SignalList.qml").createObject(root, {"x":0, "y":0, "width": root.width, "height": root.height});
                    obj.sig.connect(sendSig);
                }
            }

            MyButton {
                id: myButton3
                text: qsTr("More Info")
                width: parent.btnWid
                height: parent.btnHei
                fontsize: parent.fs
//                onClicked: root.nobtn()
            }
            /*
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
            */
        }
    }

}
