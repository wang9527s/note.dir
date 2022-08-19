
## 加快编译速度
> [&emsp;&emsp;如何加快C++代码的编译速度](https://zhuanlan.zhihu.com/p/29346995)  

```cpp
1、在头文件中使用前置声明，而不是直接包含头文件
    即：头文件尽量在cpp文件中
2、使用Pimpl模式
    这点可以pass
3、模块化
    减少文件之间和项目之间的依赖
4、预编译头
    ？？似乎不太好用（预编译头都我来说更烦，项目小）
5、include目录尽量保持简洁


```
## 信号槽
```cpp
1、void on_okButton_clicked();setupUi()中连接了信号槽
2、信号的参数可以比槽函数多
3、connect(comboBox, 
    static_cast<void(QComboBox::*)(int)>(QComboBox::currentIndexChanged),
    
    [=](int index){});
4、信号传参，自定义数据类型
//不注册的话，编译无错；但发射信号无法触发槽函数
qRegisterMetaType<QList<UserItemData_T>>("QList<UserItemData_T>");
```
## 嗯哼

```cpp
见了鬼，今天又遇到了，lambda槽函数，程序崩溃。//connect(TopSession::instance(), &TopSession::sigOperateTop
这让我想起了我之前无法在新程序上复现的bug，lamdbda中创建ui类崩溃、启动定时器失败


和服务器通信使用回调有点烦，可以尝试qt的本地事件循环
遇到过奇怪的bug，新的信息触发槽函数中执行setPage(1)，会出现滚动条；但新的信息触发槽函数，在槽函数中发送信号，在另外的槽函数中setPage(1)就没有问题。

样式表:
	不能频繁切换，初始化的时候统一设置。不可以频繁的设置样式表进行状态切换（切图）
	注意pt和px：px是像素（我一直使用的）；px是物理像素，pt是逻辑像素
可以宏定义（全局变量）作为版本切换
QLabel可以用作富文本
海康大华sdk通道播放，大华云台
软件重启：scc.exe启动restart.exe，restart.exe循环监测内存直到scc.exe退出后启动scc.exe
气泡文字：QPainter自绘，QFontMetricsF::width()判断文字长度
点击任务栏的关闭图标会执行closeEvent()函数
vs生成后事件，移动pdb和dll到bin目录（似乎直接生成到bin目录中也不错）
QLineEdit正则表达式，只允许输入数字
dump日志指向完全不相干的模块，实际上是内存越界
QLineEdit+QListView：账号输入自动提示
自定义QMenu：显示的时候setFocus，focusOutEvent触发后隐藏界面
蒙版+截图：QApplication::primaryScreen()::grabWindow()  获取桌面图片

Qt的bug
	gis：百度地图滚轮失效（qt5.12.0失效，5.12.6解决）
	webrtc卡死gis（好像是5.7之后解决）
	QFile::copy()函数，将一个文件复制到其他目录并且命名为from600to6008_2019-10-24_17:16:09.jpg。失败，原因是文件名过长（？？？）
	QPixmap(path+','+name);读取图片文件,许多文件会被损坏掉,有些文件却可以读取成功。其实是我把'/'写成了',' 但不明白为什么会有的图片文件读取成功,有的图片文件被损坏
	找不到 \bin\moc.exe。发现是解决方案中的QTDIR宏对应的路径为空。解决：将工程属性中的qtdir换成正确的（实际上大部分情况下很难解决）
	错误1 moc (D:\Qt\Qt5.12.0\5.12.0\msvc2017\bin\moc.exe)。原因：signals后少了一个冒号。
	远程调试发现，有道词典会卡死qtreewidget，使用QAbstractNativeEventFilter过滤一条消息
	
盒子模型 margin border padding content
	
多态（基类指针指向子类对象） 
	一般来说，调用的是基类的方法；但如果基类的方法是虚函数， 则调用子类方法。

```


foreach和for(:)
foreach()   : 不可以修改元素，可以删除元素
遍历qlist等, 会生成一个副本；
for(:)      : 不可以删除元素





