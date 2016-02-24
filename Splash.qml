import QtQuick 2.5
import QtQuick.Controls 1.4


ApplicationWindow  {
    id: win
    height: 800
    width: 480
    visible: true
    title: qsTr("Apktool")
    color: "grey"
    property int  count: key.runCount()+5


    Image {
        id: msgRect
        anchors.fill: parent
        source: "image://ThemeProvider/bg"
        Text {
            id: msg
            text: qsTr("unactivated version, Please wait for %1 seconds!").arg(win.count-1)
            anchors.bottom: canvas.top
            anchors.bottomMargin: (parent.height-canvas.height)/2
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: parent.width/30
            color: mc.colorValue("user/textColor")
        }
        Canvas {
            id:canvas
            x: 0
            y: 267
            height: width
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Behavior on rotation {
                NumberAnimation{
                    duration: (win.count-1)*1000
                }
            }
            Component.onCompleted: rotation = 360
            onPaint: {
                var context = getContext("2d");

                context.beginPath();
                context.fillStyle = "black"
                context.strokeStyle = "black"
                context.arc(width/2, height/2, width/2, Math.PI/2, -Math.PI/2, true)
                context.fill();
                context.stroke();

                context.beginPath();
                context.fillStyle = "white"
                context.strokeStyle = "white"
                context.arc(width/2, height/2, width/2, -Math.PI/2, Math.PI/2, true)
                context.fill();
                context.stroke();

                context.beginPath();
                context.fillStyle = "white"
                context.strokeStyle = "white"
                context.arc(width/2, height/2-width/4, width/4, Math.PI/2, -Math.PI/2, true)
                context.fill();
                context.stroke();

                context.beginPath();
                context.fillStyle = "black"
                context.strokeStyle = "black"
                context.arc(width/2, height/2+width/4, width/4, -Math.PI/2, Math.PI/2, true)
                context.fill();
                context.stroke();

                context.beginPath();
                context.fillStyle = "black"
                context.strokeStyle = "black"
                context.arc(width/2, height/2-width/4, width/15, 0, Math.PI*2, true)
                context.fill();
                context.stroke();

                context.beginPath();
                context.fillStyle = "white"
                context.strokeStyle = "white "
                context.arc(width/2, height/2+width/4, width/15, 0, Math.PI*2, true)
                context.fill();
                context.stroke();
            }
        }

        Timer {
            interval: 1000
            repeat: true
            running: true
            property int c: win.count-1
            onTriggered: msg.text = qsTr("unactivated version, Please wait for %1 seconds!").arg(--c)
        }

    }

}
