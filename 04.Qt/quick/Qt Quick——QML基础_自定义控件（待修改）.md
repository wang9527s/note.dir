# Qt Quick——QML基础_自定义控件（待修改）

标签（空格分隔）： Qt

---

##1、定义控件
&emsp;&emsp;新建一个QML工程，修改main.qml。
&emsp;&emsp;如下，修改Window中的内容。其中Button是自定义的控件
```qml
import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    visible: true
//    width: 360
//    height: 360
    Button {
        id: button
        x: 12; y: 12
        text: "main Start"
        onClicked: {
            status.text = "Button clicked!"
        }
    }

    Text {
        id: status
        x: 12; y: 76
        width: 116; height: 26
        text: "waiting ..."
        horizontalAlignment: Text.AlignHCenter
    }
}
```

##2、使用
&emsp;&emsp;在main.qml所在的目录中新建一个Button,qml文件
```qml
//Botton.qml
import QtQuick 2.0
/*
    文件名即自定义控件名
    使用别名导出属性：相当于函数的变量形参
        不同的是导出的属性，调用控件是可以不使用(赋值)
*/
Rectangle {
    id: root

    property alias text: label.text//导出自定义属性
    signal clicked

    width: 116; height: 26
    color: "red"
    border.color: "slategrey"

    Text {
        id: label
        anchors.centerIn: parent
        text: "Start"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }
    }
}
```

作者 [@wangbin][3]     
2018 年 9月 2日 

