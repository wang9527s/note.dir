# Qt Quick——QML基础_图片动画，立体旋转（待修改）

标签（空格分隔）： Qt

---

```qml
import QtQuick 2.0

Rectangle{
	/*矩形的尺寸和图片的尺寸吻合*/
	width: animg.width
	height: animg.height
	
	//transform有3个属性:Rotation选择、Scale缩放、Translate平移
	transform: Rotation {
		/* 设置图像原点 */
		origin.x:animg.width/2
		origin.y: animg.height/2
		axis {		//绕轴转动
			x:0
			y:1
			z:0
		}
		NumberAnimation on angle {
			form: 0
			to :360
			duration: 20000
			loops: animation.Infinite
		}
	}
	AnimatedImage{
		id: animg
		source: "./images/bee.gif"	//照片路径
	}
}
```




作者 [@wangbin][3]     
2018 年 8月 28日 