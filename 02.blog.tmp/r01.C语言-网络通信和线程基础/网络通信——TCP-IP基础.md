### TCP/IP 四层模型各层的功能
 
#### 1、应用层：负责实现一切与应用程序相关的功能

&emsp;&emsp;协议：TFTP（简单文件传输协议）、HTTP（超文本传输协议）、DNS（域名服务器协议）、NFS（网络文件系统协议）、TELNET（远程登录协议）是Internet远程登录的标准协议和主要主要方式、SSH安全外壳协议(Secure Shell)是目前较可靠专为远程登录会话和其他网络服务提供安全性的协议。
&emsp;&emsp;比如 xShell软件用的是SSH协议。TELNET和SSH用于远程登录

#### 2、传输层：负责提供可靠的传输服务 

&emsp;&emsp;协议：TCP（控制传输协议）、UDP（用户数据报协议）

#### 3、网络层：负责网络间的寻址数据传输

&emsp;&emsp;协议：    IP（网际协议）、ICMP（网际控制消息协议）、ping  
&emsp;&emsp;路由器  
&emsp;&emsp;IP数据包
#### 4、物理接口层（物理层、数据链路层）：负责实际数据的传输

&emsp;&emsp;协议：ARP（地址解析协议）、RARP（反向地址解析协议）、HDLC（高级链路控制协议）、PPP（点对点协议）、SLIP（串行线路接口协议）。

----------

### socket 套接字

1、是一个通用编程接口fd = socket()
> * 用于通信：消息队列、共享内存、管道、信号、socket
    同步互斥：信号量
    
2、是一种特殊的文件描述符   
3、文件IO的接口依然适用于网络编程（lseek）  
4、并不仅限于TCP/IP协议  
5、Socket类型：  
&emsp;&emsp;流式套接字(SOCK_STREAM)：TCP  
&emsp;&emsp;数据报套接字(SOCK_DGRAM)：UDP  
&emsp;&emsp;原始套接字(SOCK_RAW)：可以对较低层次协议如IP、ICMP直接访问。  
6、Socket的位置：  
&emsp;&emsp;介于应用层和传输之间的一套编程接口


### 字节序

#### 1、大端序与小端序

&emsp;&emsp;小端序：数据低位对应存储低位，一般存在操作系统
&emsp;&emsp;大段序一般用在网络通信，网络字节序都是大端字节序。

#### 2、主机字节序和网络字节序的转换

从socket读出后要转化为主机字节序，然后再处理。  
主机字节序到网络字节序  
&emsp;&emsp;u_long htonl (u_long hostlong);  IP  
&emsp;&emsp;u_short htons (u_short short);  port  
网络字节序到主机字节序  
&emsp;&emsp;u_long ntohl (u_long hostlong);  
&emsp;&emsp;u_short ntohs (u_short short);
