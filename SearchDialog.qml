import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4


Item {
    id: root
    signal nobtn
    property string parentDir


    Connections {
        target: mc
        onSearchModelChanged: {
            msgBox.msgStr = qsTr("Search finish!");
            msgBox.txtOpacity = 1.0;
            if(msgBoxTimer.running)
                msgBoxTimer.stop();
            msgBoxTimer.start();
        }
        onEditorClosed: rectangle2.enabled = false;
    }

    Image {
        id: rectangle1
//        color: "#ee888888"
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 20
        anchors.topMargin: 20
        anchors.fill: parent
        opacity: 0.9
        source: "qrc:/icons/bg.png"

        Rectangle {
            id: msgBox
            z: 99
            anchors.centerIn: parent
            property alias msgStr: msg.text
            property alias txtOpacity: msg.opacity
            Text {
                id: msg
                color: "#FF8000"
                opacity: 0
                anchors.centerIn: parent
                wrapMode: Text.WrapAnywhere
                Behavior on opacity {
                    NumberAnimation {from: 1.0; to: 0.0; duration: 3000; easing.type: Easing.InExpo}
                }

            }
            Timer {
                id: msgBoxTimer
                interval: 3000;
                onTriggered: msgBox.txtOpacity = 0.0
            }

        }


        CheckBox {
            id: checkBox1

            text: qsTr("Case")
            checked: true
            anchors.verticalCenter: myButton1.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MyButton {
            id: myButton2

            width: root.width/3
            height: root.height/15
            text: qsTr("Search")
            anchors.verticalCenter: myButton1.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
            onClicked: {
                var _cmd;
                if(textField1.length<1){
                    textField1.placeholderText = qsTr("Input keyword, please.");
                }
                else{
                    var _text = textField1.getText(0, textField1.length);
                    if(tabPositionGroup.current.tag === 0){
                        _cmd = "busybox grep "+_text+" "+parentDir+" -rl";
                        if(!checkBox1.checked){
                            _cmd += "i";
                        }
                    }
                    else{
                        _cmd = "busybox find "+parentDir;
                        if(checkBox1.checked){
                            _cmd += " -name ";
                        }
                        else{
                            _cmd += "-iname ";
                        }
                        _cmd += _text;
                    }
                    mc.searchFiles(_cmd);
                }


            }
        }

        MyButton {
            id: myButton1

            width: root.width/3
            height: root.height/15
            text: qsTr("Back")
            anchors.top: textField1.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 0
            onClicked: root.nobtn()
        }

        ListView {
            id: listView1
            clip: true
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: myButton1.bottom
            anchors.topMargin: 5
            spacing: 1
            flickDeceleration: 2000
            maximumFlickVelocity: 5000
            model: mc.searchModel
            delegate: Rectangle {
                id: listItem
                height: listView1.height/15
                width: listView1.width
                MouseArea {
                    id:mouseArea
                    anchors.fill: parent
                    onClicked: {rectangle2.enabled = true; listView1.currentIndex = index; }

                }
                color: ListView.isCurrentItem ? "#ff999999":"#aa505050"
                Image {
                    id: icon
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: listItem.height/10
                    width: height
                    asynchronous: true
                    cache: false
                    source: "image://FileImageProvider/"+mc.currentPath+"/"+model.modelData.name
                }

                Text {
                    id: t1
                    text: model.modelData.name
                    color: "white"
                    height: parent.height*2/3
                    width: parent.width - icon.width - listItem.height/5
                    font.pixelSize: height*3/7
                    anchors.left: icon.right
                    wrapMode: Text.WrapAnywhere
                }
                Text {
                    anchors.top: t1.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: icon.right
                    text: model.modelData.info
                    color: "white"
                    height: parent.height*1/3
                    font.pixelSize: height*5/7

                }
            }
            ScrollBar {
                flickable: listView1
            }
        }



        TextField {
            id: textField1
            height:  parent.height/20
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: radioButton1.bottom
            anchors.topMargin: 20
            placeholderText: qsTr("Search content or file name")
            style: TextFieldStyle {
                textColor: "orange"
                background: Rectangle {
                    radius: 2
                    opacity: 0.3
                    border.color: "#333"
                    border.width: 1
                }
            }
        }

        RadioButton {
            id: radioButton2
            width: (root.width-60)/2
            text: qsTr("by name")
            exclusiveGroup: tabPositionGroup
            anchors.verticalCenter: radioButton1.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 21
            property int  tag: 1
        }

        RadioButton {
            id: radioButton1
            width: (root.width-60)/2
            text: qsTr("by content")
            exclusiveGroup: tabPositionGroup
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.top: parent.top
            anchors.topMargin: 21
            checked: true
            property int  tag: 0
        }
        Rectangle {
            id: rectangle2
            anchors.fill: parent
            z: 1
            color: "#00ffffff"
            enabled: false
            MouseArea {
                anchors.fill: parent
                onClicked: rectangle2.enabled = false
            }

            Row {
                id: row1
                anchors.centerIn: parent
                width: parent.width/2
                height: parent.height/15

                MyButton {
                    id: myButton4
                    width: parent.width/2
                    height: parent.height
                    text: qsTr("Open")
                    onClicked: mc.openFile(mc.searchModel[listView1.currentIndex].name);
                }

                MyButton {
                    id: myButton3
                    width: parent.width/2
                    height: parent.height
                    text: qsTr("Edit")
                    onClicked: mc.edit(mc.searchModel[listView1.currentIndex].name);
                }


            }
        }

        ExclusiveGroup { id: tabPositionGroup }







    }

}
