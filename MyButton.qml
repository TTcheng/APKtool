import QtQuick 2.0
import QtQuick.Controls 1.4

Image {
    id: button
    opacity: enabled?(ma.pressed?0.4:0.8):0.3
    //    radius: 128
    //    antialiasing: false
    property alias text: name.text
    property alias fontsize: name.font.pixelSize
    signal clicked

    source: "image://ThemeProvider/buttonbg"
    clip: true
    MouseArea {
        id: ma
        anchors.fill: parent
        onClicked: button.clicked()
    }

    Text {
        id: name
        anchors.centerIn: parent
        wrapMode: Text.WrapAnywhere
        color: "black"
    }



}

