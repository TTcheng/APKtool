import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import per.pqy.sysinfo 1.0


ApplicationWindow {
    id: mainwindow
    visible: true
    width: 480
    height: 800
    title: qsTr("Apktool")
    onClosing: {
        close.accepted = false;
        if(dialogLoader.source!=""&&dialogLoader.source!="qrc:/CopyDialog.qml"){
            hideDialogLoader();
        }
        else if(mc.currentPath != "/"){
            mc.singlePress(0);
        }
    }

    function hideAll(){
        hidebtmMenu();
        hideselectMenu();
        hideSettings();
    }

    function showbtmMenu(type){
        //1:copy 2:search 3:delete 4:rename 5:decompile 6:recompile 7:sign 8:open 9: import 10:oat2dex 11:new 12:edit
        btmMenu.btn1 = true;
        btmMenu.btn2 = false;
        btmMenu.btn3 = true;
        btmMenu.btn4 = true;
        btmMenu.btn5 = true;
        btmMenu.btn6 = true;
        btmMenu.btn7 = true;
        btmMenu.btn8 = true;
        btmMenu.btn9 = true;
        btmMenu.btn10 = true;
        btmMenu.btn11 = true;
        btmMenu.btn12 = true;
        if(type==="apk"){
            btmMenu.btn6 = false;
            btmMenu.btn10 = false;
            btmMenu.btn12 = false;
        }
        else if(type==="jar"){
            btmMenu.btn6 = false;
            btmMenu.btn7 = false;
            btmMenu.btn9 = false;
            btmMenu.btn10 = false;
            btmMenu.btn12 = false;
        }
        else if(type==="odex"){
            btmMenu.btn6 = false;
            btmMenu.btn7 = false;
            btmMenu.btn9 = false;
            btmMenu.btn5 = false;
            btmMenu.btn12 = false;
        }
        else if(type==="@dir@"){
            btmMenu.btn2 = true;
            btmMenu.btn5 = false;
            btmMenu.btn7 = false;
            btmMenu.btn8 = false;
            btmMenu.btn9 = false;
            btmMenu.btn10 = false;
            btmMenu.btn12 = false;
        }
        else if(type==="MultiSelect"){
            btmMenu.btn4 = false;
            btmMenu.btn5 = false;
            btmMenu.btn6 = false;
            btmMenu.btn7 = false;
            btmMenu.btn8 = false;
            btmMenu.btn9 = false;
            btmMenu.btn10 = false;
            btmMenu.btn11 = false;
            btmMenu.btn12 = false;
        }
        else {
            btmMenu.btn6 = false;
            btmMenu.btn7 = false;
            btmMenu.btn9 = false;
            btmMenu.btn5 = false;
            btmMenu.btn10 = false;
        }

        btmMenu.y = root.height - btmMenu.height;
        virtualRect.y = 0;
    }

    function hidebtmMenu(){
        virtualRect.y = root.height;
        btmMenu.y = root.height;
    }

    function showMsg(msg){
        msgBox.msgStr = msg;
        msgBox.txtOpacity = 1.0;
        if(msgBoxTimer.running)
            msgBoxTimer.stop();
        msgBoxTimer.start();
    }

    function showselectMenu(){
        selectMenu.y = 0;
    }

    function hideselectMenu(){
        selectMenu.y = -selectMenu.height;
    }

    function showhideSettings(){
        if(settings.width==0){
            settings.opacity = 1;
            settings.x = root.width/2;
            settings.width = root.width/2-seticon.width;
            settings.height = root.height*5/15;
        }
        else{
            settings.x = seticon.x;
            settings.width = 0;
            settings.height = 0;
            settings.opacity = 0;
        }
    }

    function hideSettings(){
        settings.x = seticon.x;
        settings.width = 0;
        settings.height = 0;
        settings.opacity = 0;
    }



    function menuFunction(num){
        var _copy = 1;
        var _search = 2;
        var _delete = 3;
        var _rename = 4;
        var _decompile = 5;
        var _recompile = 6;
        var _sign = 7;
        var _open = 8;
        var _import = 9;
        var _oat2dex = 10;
        var _new = 11;
        var _edit = 12;
        if(num===_copy){
            mc.saveSelected();
            dialogLoader.setSource("qrc:/CopyDialog.qml");
        }
        else if(num ===_delete){
            dialogLoader.setSource("qrc:/DeleteDialog.qml");
        }
        else if(num ===_rename){
            dialogLoader.setSource("qrc:/RenameDialog.qml", {"text":dialogLoader.origName});

        }
        else if(num ===_decompile){
            dialogLoader.setSource("qrc:/DecApk.qml");
        }
        else if(num ===_recompile){
            dialogLoader.setSource("qrc:/RecApk.qml");
        }
        else if(num === _sign){
            mc.signApk(dialogLoader.origName);
        }
        else if(num === _open){
            mc.openFile(dialogLoader.origName);
        }
        else if(num === _import){
            mc.importFramework(dialogLoader.origName);
        }
        else if(num === _oat2dex){
            mc.oat2dex(dialogLoader.origName);
        }

        else if(num === _new){
            dialogLoader.setSource("qrc:/NewDialog.qml");
        }

        else if(num ===_edit){
            //            dialogLoader.setSource("qrc:/Editor.qml");
            //mainwindow.parent.root.visible = false;
            //            mc.edit(dialogLoader.origName);

        }
        else if(num===_search){
            dialogLoader.setSource("qrc:/SearchDialog.qml",{"parentDir":dialogLoader.origName});
        }

        hidebtmMenu();
    }

    function hideDialogLoader(){
        dialogLoader.setSource("");
    }

    function settingFunctions(btn){
        hideSettings();
        if(btn===1)
            dialogLoader.setSource("qrc:/TasksList.qml");
        else if(btn===2){
            if(key.isRegisterd()){
                dialogLoader.setSource("qrc:/RegisterInfo.qml");
            }
            else{
                dialogLoader.setSource("qrc:/Register.qml");
            }
        }
        else if(btn===3){
            dialogLoader.setSource("qrc:/HelpPage.qml");
        }
        else if(btn===4){
            dialogLoader.setSource("qrc:/Themes.qml");
        }
        else if(btn===5){
//            dialogLoader.setSource("qrc:/DataMove.qml");
        }

        else if(btn===6){
            Qt.quit();
        }

    }

    function registerApp(regKey){
        if(regKey.length!==12){
            showMsg(qsTr("Invalid length of your key!"));
        }
        else{
            key.verifyKey(regKey);
        }
    }

    function showcopyMenu(){
        copyMenu.y = root.height-copyMenu.height;
    }

    function hidecopyMenu(){
        copyMenu.y = root.height;
    }

    function deleteFiles(){
        mc.deleteSelected();

        hideDialogLoader();
    }

    function copyFiles(cover){
        if(mc.copySelected(cover)){
            hideDialogLoader();
        }
        else{
            showMsg(qsTr("Can not copy to same path!"))
        }
    }

    function cutFiles(cover){
        if(mc.cutSelected(cover)){
            hideDialogLoader();
        }
        else{
            showMsg(qsTr("Can not cut to same path!"))
        }
    }

    function renameFile(oldName, newName){
        mc.rename(oldName, newName);
        hideDialogLoader();
    }

    function newFile(name, type){
        mc.createNewFile(name, type);
        hideDialogLoader();
    }

    function decApk(name, options, rootPerm){
        hideDialogLoader();
        showMsg(qsTr("Added to task list!"));
        mc.decApk(name, options, rootPerm);
    }

    function recApk(name, options, aapt, rootPerm){
        hideDialogLoader();
        showMsg(qsTr("Added to task list!"));
        mc.recApk(name, options, aapt, rootPerm);
    }

    function createOutput(cmd, output, duration){
        var compoment = Qt.createComponent("qrc:/OutPut.qml");
        var obj = compoment.createObject(dialogLoader, {"x":0, "y":100, "width": mainwindow.width, "height": mainwindow.height-200,
                                             "cmdText": cmd, "outputText": output, "durationText": qsTr("cost time: %1").arg(duration)});
    }
    function bugReport(){
        hideDialogLoader();
        if(!key.isRegisterd())
            createOutput("", qsTr("This page is showed because of register bug.\n%1").arg(key.genBugMsg()),"");
    }




    SysInfo {
        id: sysinfo
        onMeminfo:{
            meminfo.totaltext = total;
            meminfo.freetext = free;
            meminfo.rectHei = meminfo.height*ratio;
        }
        onCpuinfo: {
            cpuinfo.text = info;
        }
    }

    Connections {
        target: mc
        onNoPerm:  showMsg(qsTr("No access permission!"))
        onClickFile: showbtmMenu(type)
        onClickDir: showbtmMenu("@dir@")
        onFileModelChanged: hideAll()
        onDeleteFinished:  showMsg(qsTr("Files has been deleted!"))
        onGotKey: createOutput("",key,"")
        onCopyFinished:  showMsg(qsTr("Files has been copied!"))
        onCutFinished:  showMsg(qsTr("Files has been cut!"))
        onSameNameExist: showMsg(qsTr("File with same name exists!"))
        //        onEditorClosed: dialogLoader.setSource("")
        onTaskFinished: createOutput(cmd, output, duration)
        onNoBootClass: showMsg(qsTr("Copy boot.oat file to current path first, please. "))
        onCombineHelp: showMsg(qsTr("Unsupported operation."))
    }

    Connections {
        target: key
        onVerifySuccess: {
            showMsg(qsTr("Congratulations! You have registered this app!"));
            hideDialogLoader();
        }
        onVerifyFail: {
            showMsg(qsTr("Oops! Your key is invalid! Check it, please."));
        }
        onVerifyTimeout: {
            showMsg(qsTr("Verify timeout! Please try again."));
        }
        onRegisterBug: {
            bugReport();
        }
    }

    Loader {
        id: dialogLoader
        z: 5
        anchors.fill: parent
        property string origName
    }

    Connections {
        ignoreUnknownSignals: true
        target: dialogLoader.item
        onDeletebtn: deleteFiles();
        onNobtn: hideDialogLoader();
        onRgst: registerApp(regKey);
        onCpbtn: copyFiles(cover);
        onCutbtn: cutFiles(cover);
        onRenamebtn: renameFile(dialogLoader.origName, newName);
        onNewfilebtn: newFile(newName, type);
        onDecapk: decApk(dialogLoader.origName, options, rootPerm);
        onRecapk: recApk(dialogLoader.origName, options, aapt, rootPerm);
        //        onBugreport: bugReport();
    }

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

    Image {
        id: seticon
        source: "qrc:/icons/settings.png"
        width: root.height/15
        height: width
        z: 1
        x: root.width-width
        y: 0
        opacity: 0.7
        Behavior on rotation {
            NumberAnimation { duration: 990 }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: showhideSettings()
            onPressAndHold: {mc.genKey();meminfo.visible = ! meminfo.visible; }
        }
    }
    Timer {
        id: settingTimer
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true;
        onTriggered: { seticon.rotation+=mc.taskNum*18; sysinfo.memoryInfo(); }
    }

    Settings {
        id: settings
        opacity: 0
        width: 0
        height: 0
        x: seticon.x
        y: seticon.y+seticon.height
        z: seticon.z


        onClicked: settingFunctions(btn);

        Behavior on x {
            NumberAnimation {
                duration: 100
                easing.type: Easing.Linear
            }
        }
        Behavior on width {
            NumberAnimation {
                duration: 100
                easing.type: Easing.Linear
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: 100
                easing.type: Easing.Linear
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 100
                easing.type: Easing.Linear
            }
        }
    }
    MemInfo {
        id: meminfo
        width: parent.width/7
        height: parent.height/3
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: width
        z: 99
    }

    Text {
        id: cpuinfo
        z: 99
        opacity: 0.5
        width: meminfo.width*2
        anchors.bottom: root.bottom
        anchors.top: meminfo.bottom
        anchors.topMargin: 20
        anchors.left: meminfo.left
    }

    Image {
        id: root
        anchors.fill: parent
        //        color: "#dddddd"
        source: "image://ThemeProvider/bg"
        opacity: 0.7
        property real scrollPos: 0

        ListView {
            id: list
            anchors.fill: parent
            flickDeceleration: 3000
            maximumFlickVelocity: 8000
            spacing: 0
            clip: true
            onModelChanged: list.contentY = root.scrollPos;
            onFlickEnded: root.scrollPos = contentY;

            model: mc.fileModel
            delegate: Image {
                id: listItem
                height: root.height/15
                width: root.width
                //source: "image://ThemeProvider/itembg"
                opacity: mouseArea.pressed?0.9:1.0


                property alias checked: checkItem.checked
                MouseArea {
                    id:mouseArea
                    anchors.fill: parent
                    onClicked: { mc.unselectAll(); model.modelData.setChecked(true); dialogLoader.origName = model.modelData.name; mc.singlePress(index);}
                    onPressAndHold: { mc.unselectAll(); model.modelData.setChecked(true); dialogLoader.origName = model.modelData.name; mc.longPress(index); }
                }
                //                 color: "#88ffffff"
                //                 gradient: Gradient {
                //                     GradientStop { position: 0.0; color: "#eeeeee" }
                //                     GradientStop { position: 0.5; color: "#f3f3f3" }
                //                     GradientStop { position: 1.0; color: "#eeeeee" }
                //                 }

                Image {
                    id: icon
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: listItem.height/10
                    width: height
                    asynchronous: true
                    cache: false
                    source: "image://FileImageProvider/"+mc.currentPath+model.modelData.name
                }
                CheckBox {
                    id: checkItem
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: listItem.height/10
                    anchors.bottomMargin: listItem.height/10

                    width: height
                    Component.onCompleted: checked=model.modelData.checked
                    style: CheckBoxStyle {
                        indicator: Rectangle {
                            implicitWidth: checkItem.width/2
                            implicitHeight: checkItem.height/2
                            radius: 32
                            color: "#00000000"
                            border.color: control.activeFocus ? "darkblue" : "black"
                            border.width: 1
                            Rectangle {
                                visible: control.checked
                                color: "#555"
                                border.color: "#333"
                                radius: 32
                                //                                         anchors.margins: 4
                                anchors.fill: parent
                            }
                        }
                    }
                    onClicked: {
                        model.modelData.setChecked(checked);
                        showselectMenu();
                    }
                    Connections {
                        target: model.modelData
                        onCheckedChanged: checkItem.checked = model.modelData.checked
                    }
                }

                Text {
                    id: t1
                    text: model.modelData.name
                    color: "black"
                    height: parent.height*2/3
                    font.pixelSize: height*4/7
                    anchors.left: icon.right
                }
                Text {
                    anchors.top: t1.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: icon.right
                    text: model.modelData.info
                    color: "black"
                    height: parent.height*1/3
                    font.pixelSize: height*5/7

                }
            }
        }
        ScrollBar {
            flickable: list
        }
    }

    BtmMenu {
        id: btmMenu
        width:parent.width
        height: root.height/3
        y: root.height
        z: 1


        Behavior on y {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutExpo
            }
        }
        onClicked: menuFunction(num)
    }

    Rectangle {
        id: virtualRect
        width: parent.width
        height: root.height - btmMenu.height
        y: root.height
        z: 1
        opacity: 0
        MouseArea {
            anchors.fill: parent
            onClicked:{
                hidebtmMenu();
            }
        }

    }

    Rectangle {
        id: selectMenu
        width: root.width/2
        height: root.height*4/15+3
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: 0.8
        y: -height
        z:2
        color: "#999999"
        Behavior on y {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutExpo
            }
        }
        Column {
            anchors.fill: parent
            spacing: 1
            property real btnWid: parent.width
            property real btnHei: (parent.height-3)/4
            MyButton {
                id: button1

                text: qsTr("Select All")
                width: parent.btnWid
                height: parent.btnHei
                onClicked: mc.selectAll()
            }

            MyButton {
                id: button2

                text: qsTr("Reverse Selection")
                width: parent.btnWid
                height: parent.btnHei
                onClicked: mc.reverseSelect()
            }
            MyButton {
                id: button4

                text: qsTr("Combine")
                width: parent.btnWid
                height: parent.btnHei
                onClicked: {hideselectMenu();mc.combineApkDex();}
            }

            MyButton {
                id: button3

                text: qsTr("Finish Selection")
                width: parent.btnWid
                height: parent.btnHei
                onClicked: {
                    hideselectMenu();
                    if(!mc.noItemSelected())
                        showbtmMenu("MultiSelect");
                }
            }

        }
    }



}

