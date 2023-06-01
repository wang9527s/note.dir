### 函数

#### 1、创建/打开套接字：socket()

```cpp
listenfd=socket(
        AF_INET, //协议族 IPv4
        int type,  /*    套接字类型
            SOCK_STREAM、SOCK_DGRAM、SOCK_RAW
            流式套接字、数据报套接字、原始套接字
            */
        0//具体协议，0代表默认
        );//失败返回-1
```

                     
#### 2、绑定IP + port：bind()

```cpp
struct sockaddr_in seraddr;
memset(&seraddr, 0, sizeof(seraddr));
seraddr.sin_family = AF_INET;
seraddr.sin_port = htons(8888);//主机序转为网络序   结构体中存的是网络序
seraddr.sin_addr.s_addr = inet_addr("127.0.0.1");//点分十进制 转为32位 网络二进制数
    
bind(listenfd,
        (struct sockaddr *)&seraddr,//服务器端IP
        sizeof(seraddr)
        );//失败返回-1
```

#### 3、监听：listen()

&emsp;&emsp;由主动工作模式变为被动工作模式

```cpp
listen(listenfd,
        5//backlog正在等待连接 的队列的长度，
        );//失败返回-1
```

&emsp;&emsp;dos攻击一直连接别人，占用队列
    
    
#### 4、发起连接请求：connect()

```cpp
struct sockaddr_in seraddr;
memset(&seraddr, 0, sizeof(seraddr));
seraddr.sin_family = AF_INET;
seraddr.sin_port = htons(8888);
seraddr.sin_addr.s_addr = inet_addr("127.0.0.1")

connect(connfd, 
        struct sockaddr *)&seraddr,
        sizeof(seraddr)
        );

```
    
#### 5、连接：accept()

阻塞等待来自客户端的连接请求（由内核完成）

```cpp
struct sockaddr_in cliaddr;
socklen_t addrlen = sizeof(cliaddr);

//与已完成3 次握手的队列的首元素建立连接
connfd=accept(listenfd，
        (struct sockaddr *)&cliaddr//存储客户端地址的信息,(可选)
        &addrlen
        );//失败返回-1
    
printf("client ip:%s, port:%d\n", inet_ntoa(cliaddr.sin_addr), ntohs(cliaddr.sin_port));
```

#### 6、读写

```cpp
//当发送方被关闭（close(connfd)），recv会返回0
read(int fd,     
        void *buf, 
        size_t count
        );//返回值：读到的字节数 或 0（表示文件已结尾）
        
//flag为0，函数功能和read一样
recv(int sockfd, 
        void *buf, 
        size_t len, 
        int flags
        );
        
```

----------
### TCP/IP模型

#### TCP 客户端

```cpp
connfd = socket();
connect();                        参数：含有服务器IP+端口
while(1)
{
    读写逻辑与 break条件
}
close(connfd)
```

#### TCP 循环服务器    

```cpp
listenfd = socket();                
bind();                            参数：存储服务器的IP+端口
listen();    非阻塞                    
while(1)                        
{                                    
    conndfd = accept();    阻塞    参数：存储客户端的IP+端口        
    while(1)
    {
        recv()   send()
        读写逻辑与 break条件
    }
    close(connfd)
}
```

#### TCP 并发服务器

```cpp
signal()回收僵尸进程//信号回收子进程
listenfd = socket();                
bind();                                
listen();    非阻塞                    
while(1)                            
{                                    
    conndfd = accept();    阻塞            
    fork();
    {父：
        close(connfd);
    }
    {子：
        close(listenfd);
        while(1)
        {
            读写逻辑与 break条件
        }
        close(connfd);
    }
}
```

----------

### UDP模型

> * UDP比TCP少了以下函数
    服务器：listen() accept()
    客户端：connect()
> * connect() + 
send() + recv()等于sendto() + recvfrom()

#### UDP 客户端

```
sockfd = socket()
while()
{
    sendto()
    process()
    recvfrom()
}
close(sockfd)
```

#### UDP 循环服务器

```cpp
sockfd = socket()
bind()
while(1)
{
    recvfrom()//阻塞等待，一直循环
    process()
    sendto()
}
```

#### UDP    并发服务器

```cpp
sockfd = socket()
bind()
while(1)
{
    recvfrom(&cliaddr) //accept
    fork()
    {子  负责通信
        close(socked)
        fd = socket()
        connect(fd,&cliaddr)//绑定client的地址
        while(1)
        {
            send(fd)
            recv(fd)
        }
        close(fd)
    }
    {father }
}
```


----------

### IO多路复用并发服务器模型

```cpp
socket() bind() listen()
while(1)
{
    设置监听读写文件描述符集合（FD_*），并初始化
    调用select()
    if(FD_LSSET(i, &rdfs))//被监听的套接字有变化
    {
        if(i == listenfd)//    当client发起连接请求时，listenfd会发生响应
        {
            connfd = accept(listenfd);
            将connfd加入监听文件描述符集合
        }
        else if //是一个已连接过的描述符
        {
            读写操作
        }
    }
    accept()
    while(1)
}
```
