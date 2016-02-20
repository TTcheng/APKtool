import QtQuick 2.0

Rectangle {
    id: root
    signal nobtn
    color: "#bddcde"

    MyButton {
        id: myButton1
        height: parent.height/18
        text: qsTr("OK")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        onClicked: root.nobtn()
    }

    Flickable {
        id: flickable1
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: myButton1.top
        anchors.bottomMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 0
        contentWidth: textEdit1.paintedWidth
        contentHeight: textEdit1.paintedHeight
        clip: true

        TextEdit {
            id: textEdit1

            width: flickable1.width
            height: flickable1.height
            text: "
        本版本采用Qt库重写，风格上与之前的版本完全不一样，因此写点说明给新用户参考。
关于注册：
	从6.0开始，本程序需要用户购买注册码。未注册版本仍然可以使用，但是每重新启动一次程序，等待界面将多加1秒，直到20秒。\
注册码的购买途径: 向支付宝账号pangqingyuan1991@gmail.com转账2元即可获得临时注册码，临时注册码仅在24小时内可以注册，\
请及时使用，注册后将永久去除等待界面。如果您清除了本软件的数据（包括但不限于卸载、恢复出厂、刷机等），注册信息将失效，需要重新购买注册码。\
一旦发现注册算法已被破解，作者有权利在更新版本中升级注册验证算法。注册可能会有网络延迟，可连续点击几次注册，或者切换其他网络再尝试。

反编译apk/jar：
	点击apk文件，选择反编译即可。注意jar指的是安卓系统的jar库,里面含有classes.dex文件，不是一般的jar程序。
反编译dex/odex：
	不支持直接反编译，先合并到相应的apk或jar文件再反编译。如果是odex,还要先使用oat2dex。例如修改services.odex，\
先把services.odex, services.jar和boot.oat 复制到同一目录(路径不要包含中文)，然后点击services.odex选择oat2dex，软件会先\
分解boot.oat文件，生成dex和odex目录，然后再生成services.dex。点击services.dex和services.jar的右边勾选这两个文件，从下拉菜单中选择合并，\
即可将services.dex打包进services.jar。接着就可以反编译services.jar了。
回编译：
	长按文件夹选择回编译即可。
导入框架：
	直接浏览/system/framework目录，单击framework-res.apk选择导入框架即可，不需要复制出来。
oat2dex：
	本功能可将安卓5.0及以上版本的系统odex文件转化为dex文件，转化需要系统文件boot.oat, 位于/system/framework/的某个子目录下。不再支持旧版本的odex转化。
任务管理：
	所有添加的任务都是同步执行，所以不要添加太多任务。如果有任务在执行，右上角的齿轮会旋转，旋转速度与任务数正相关。
内存状态：
屏幕右边的柱状图显示了手机当前内存状态总内存/可用内存，刷新间隔为一秒，可以直观的展示任务进行时内存的变化情况。长按右上角齿轮可切换柱状条的显示/隐藏。
主题定制：
	软件界面主要由三张图片来渲染，背景指的是覆盖整个屏幕的图片，文件背景指的是覆盖文件矩形的图片（文件由一个个小矩形表示），按钮背景就是添加在按钮上的图片。\
背景图片可根据自己屏幕大小选择合适的分辨率，文件图片长宽比约为8:1为宜，按钮图片长宽比3:1为宜。图片大小理论上没有限制，但是越大，内存占用越高。支持jpg/png
合并：
	本功能仅是方便于修改odex，将odex转化为dex后，可以便捷的将dex打包进apk/jar文件中。但是需要说明，只能勾选两个文件，一个是dex文件，另一个是apk/jar文件。\
dex文件会自动重命名为classes.dex再打包。不支持打包其他文件。如要保留签名文件可以在回编译界面勾选-c参数。
搜索：
	可对文件夹进行字符串搜索或者文件搜索。
"
            textFormat: Text.PlainText
            readOnly: true
            font.pixelSize: root.width/40
            wrapMode: TextInput.WrapAnywhere
        }
    }

}
