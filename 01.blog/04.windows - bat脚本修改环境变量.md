## bat脚本修改环境变量

&emsp;&emsp;新项目中dll太多，qt本身无法设置dll路径，只可以设置插件路径。最根本的方法还是修改环境变量。

&emsp;&emsp;像新建一个类似QTDIR的环境变量WANGPATH，然后将其添加到Path中。每次脚本执行的时候，更新WANGPATH的值并检查Path中是否存在WANGPATH，不存在则添加。

&emsp;&emsp;参考: [wmic使用手册](https://blog.csdn.net/qq_39621009/article/details/122349526?spm=1001.2101.3001.6650.9&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-9-122349526-blog-104923785.t0_edu_mix&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-9-122349526-blog-104923785.t0_edu_mix&utm_relevant_index=10)

## 过程

### 申请管理员权限

&emsp;&emsp;修改环境变量，需要以管理员方式运行bat脚本，太繁琐，在脚本启动的时候直接申请管理员权限。方法如下

```bat
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"
```

### 删除环境变量

```bat
wmic ENVIRONMENT where "name='WANGPATH'" delete
```

### 添加环境变量

```bat
:: 方法1
wmic ENVIRONMENT create name="WANGPATH",username="<system>",VariableValue="D:\wang"

:: 方法2
set ENV_Path=%WANGPATH%
setx /M WANGPATH D:\wang;%cd%\dll_qt
```

### 对Path环境变量的判断

+ 获取环境变量

&emsp;&emsp;```echo $Path```会将$Path中变量部分的自动转换为对应的路径，无法判断是否存在WANGPATH，不符合要求。

```bat
echo $Path

wmic ENVIRONMENT where "name='Path' and UserName='<system>'" get VariableValue
```

&emsp;&emsp;使用wmic可以获取到想要的结果，但没找到处理wmic输出结果的方法，只能将结果重定向到文件中

+ 判断文件中是否包含某一个关键字

```bat
find "WANGPATH" "envPathContent" && set exist=1 && echo "envPathContent file contain WANGPATH"
```

&emsp;&emsp;上述例子可以判断，但我需要```if else```

```bat
exist=0
set exist=0
find "WANGPATH" "envPathContent" && set exist=1 && echo "contain"
if %exist% equ 1 (
	echo "log: env Path contain WANGPATH"
) else (
	echo "log: env Path not contain WANGPATH"
	echo "log: update env"
)
```

### 更新Path变量

```bat
:: %%WANGPATH%% 添加的是 %WANGPATH%；  %WANGPATH%添加的是$WANGPATH
wmic ENVIRONMENT where "name='PATH' and username='<system>'" set VariableValue="%PATH%;%%WANGPATH%%"
```

### 最终效果

```bat
@echo off

:: 申请管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cd /d "%~dp0"


:: 设置 WANGPATH 环境变量
echo "log: update env WANGPATH"
wmic ENVIRONMENT where "name='WANGPATH'" delete

set ENV_Path=%WANGPATH%
setx /M WANGPATH D:\wang;%cd%\dll_qt


:: 如果path环境变量中不包含%WANGPATH%，则添加。
wmic ENVIRONMENT where "name='Path' and UserName='<system>'" get VariableValue > envPathContent
exist=0
set exist=0
find "WANGPATH" "envPathContent" && set exist=1 && echo "contain"
if %exist% equ 1 (
	echo "log: env Path contain WANGPATH"
) else (
	echo "log: env Path not contain WANGPATH"
	echo "log: update env"
	:: %%WANGPATH%% 添加的是 %WANGPATH%；  %WANGPATH%添加的是$WANGPATH
	wmic ENVIRONMENT where "name='PATH' and username='<system>'" set VariableValue="%PATH%;%%WANGPATH%%"
)
del envPathContent

pause
```