import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    id: rootItem
    state: key.isRegisterd()?"main":"splash"
    Loader {
        id: mainLoader
    }
    states: [
        State {
            name: "splash"
            PropertyChanges {
                target: mainLoader
                source: "qrc:/Splash.qml"
            }
        },
        State {
            name: "main"
            PropertyChanges {
                target: mainLoader
                source: "qrc:/FilesList.qml"
            }
        }
    ]

    Timer {
        interval: (key.runCount()+4)*1000;
        running: true;
        onTriggered: rootItem.state = "main";
    }

}

