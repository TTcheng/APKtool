import QtQuick 2.0
import QtQuick.Controls 1.3

Rectangle {
    id: root
    property int btnHei: height/12
    property int btnWid: width/8
    signal sig(int s)

    Grid {
        id: grid1
        height: parent.height/3
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        spacing: 0
        rows: 4
        columns: 8

        Repeater {
            model: 31
            MyButton {
                height: btnHei
                width: btnWid
                text: (index+1).toString()
                onClicked: { root.sig(index+1); root.destroy();}
            }
        }
        MyButton {
            height: btnHei
            width: btnWid
            text: qsTr("back")
            onClicked: root.destroy()
        }
    }

    TextArea {
        id: textArea1
        anchors.top: grid1.bottom
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        readOnly: true
        text: " 1    HUP Hangup   2    INT Interrupt
 3    QUIT Quit   4    ILL Illegal instruction
 5    TRAP Trap   6    ABRT Aborted
 7    BUS Bus error
 8    FPE Floating point exception
 9    KILL Killed   10   USR1 User signal 1
11   SEGV Segmentation fault
12   USR2 User signal 2
13   PIPE Broken pipe   14   ALRM Alarm clock
15   TERM Terminated   16   STKFLT Stack fault
17   CHLD Child exited   18   CONT Continue
19   STOP Stopped (signal)   20   TSTP Stopped
21   TTIN Stopped (tty input)
22   TTOU Stopped (tty output)
23   URG Urgent I/O condition
24   XCPU CPU time limit exceeded
25   XFSZ File size limit exceeded
26   VTALRM Virtual timer expired
27   PROF Profiling timer expired
28   WINCH Window size changed
29   IO I/O possible   30   PWR Power failure
31   SYS Bad system call"
    }

}
