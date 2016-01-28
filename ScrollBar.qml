import QtQuick 2.0;

Item {
    id: scrollbar;
    width: 5;
    visible: (flickable.visibleArea.heightRatio < 1.0);
    anchors {
        top: flickable.top;
        right: flickable.right;
        bottom: flickable.bottom;
        margins: 1;
    }

    property Flickable flickable: null;

   Binding {
        target: handle;
        property: "y";
        value: (flickable.contentY * (scrollbar.height - handle.height) / (flickable.contentHeight - flickable.height));
    }

   Rectangle {
            id: handle;
            height: Math.max (20, (flickable.visibleArea.heightRatio * scrollbar.height));
            color: "white";
            radius: 32;
            opacity: (flickable.moving ? 0.65 : 0);
            anchors {
                left: parent.left;
                right: parent.right;
            }
            Behavior on opacity { NumberAnimation { duration: 150; } }
   }
}
