# Qt Quick——QML基础_语言组成（待修改）

标签（空格分隔）： Qt

---

> * 一个QML基本上由根元素和子元素组成

##新建一个QML工程
&emsp;&emsp;建一个Qt Quick Application程序，然后修改main.qml文件。修改Windows中的内容，修改如下：
```qml
import QtQuick 2.6//导入组件：类库、JS文件、QML文件
import QtQuick.Window 2.2

Window {//在VS中 没有Window，有Rectangle。所以不要修改根元素的名字
    visible: true
    /*声明属性：
        <属性名称>:<属性值>
    */
    x:0;y:0
    width: 360
    height: 480
    title: qsTr("Hello World")

    Image{
        source:"file:///F:/Workspace/Qt/QtQuick/image/sunny.png"
       // source:"../image/sunny.png"
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {// 鼠标点击事件
            Qt.quit()
        }
    }
    Text{
        id:text
        y:image.height +20
        property int age: 12
        /*自定义变量
            property type name: value
            property 类型 变量名:变量值
        */
        text:"This is Qt Quick   "+12
    }
}

/*在Image子元素中
　　在VS+Qt中：使用相对路径，可以加载jpg图片不能加载png图片
　　在Qt Creator中：使用 绝对路径file可以加载png、jpg图片
　　资源文件没有试*/

```

##QML文件语法
###一、元素
1、可视化元素（界面）
```qml
//基础元素对象
    Item{}    
//矩形框
　　Rectangle{
　　　　radius:8　　//使用半径属性设定圆角矩形
　　Text　　　　
　　　　text:"A very long text"
　　　　clide:Text.ElideMiddle//文字无法全部显现时，中间省略。"A ver... text"
　　　　style:Text.Sunken
　　　　StyleColor:"#ff4444"//字体红色阴影
　　}
//图片
　　image{
　　　　fillMode:Image.PressverAspectCrop
　　　　clip:true
　　　　Behavor on rotation{
　　　　　　NumberAnimation:250//动作花费时间250ms
　　　　}
　　　　image.rotation+=90//旋转90°
　　}
//鼠标区域
　　MouseEvent{}
```
　　　

2、非可视化元素
　　Timer定时器

3、注意事项
    1、属性绑定和赋值
　　绑定：text:"my age is "+age;//存在与整个周期，随着age变化而变化
　　赋值：label.text="hello world"//赋值，并且取消之前的绑定
　　　　　　id.text


作者 [@wangbin][3]     
2018 年 8月 30日 