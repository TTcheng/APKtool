import QtQuick 2.5
import QtQuick.Controls 1.4


Item {
    id: rootItem
    state: key.isRegisterd()?"main":"splash"
    Loader {
        id: mainLoader
    }

    Connections{
        id: connect
        target: mainLoader.item
        ignoreUnknownSignals: true
        onToMain: rootItem.state = "main"
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

}

