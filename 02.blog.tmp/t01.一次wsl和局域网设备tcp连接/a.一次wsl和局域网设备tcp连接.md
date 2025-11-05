
想在wsl连接物理机和局域网的tcp server。  
目前wsl(192.168.142.14)和物理机(192.168.31.250)可以建连，正常收发数据
wsl可以和局域网设备C(192.168.31.145)，可以建连，但wsl发送的数据，C无法收到

**powershell**管理员权限启动，并设置

```bash
netsh interface portproxy add v4tov4 listenport=5016 listenaddress=192.168.31.250 connectport=5016 connectaddress=192.168.142.14  
route add 192.168.142.0 mask 255.255.255.0 192.168.31.250

New-NetFirewallRule -DisplayName "Allow WSL2 TCP 5016" -Direction Inbound -Protocol TCP -LocalPort 5016 -Action Allow
New-NetFirewallRule -DisplayName "Allow WSL2 TCP 5016" -Direction Outbound -Protocol TCP -LocalPort 5016 -Action Allow
```

设置完成后，重启wsl，C还是收不到wsl发送的数据


**nc测试** （不靠谱）

C上设置 ```nc 0.0.0.0 5016```

wsl 两个终端分别执行

```bash
echo "Hello, server!" | nc 192.168.31.250 5016
sudo tcpdump -i eth0 port 5016
```

**C上换一个demo**

替换成c/c++重新编写的tcp server，wsl和C可以建连 通信了

**清除配置**后，重启wsl，还是可以。emm

```bash
netsh interface portproxy delete v4tov4 listenport=5016 listenaddress=192.168.31.250
route delete 192.168.142.0 mask 255.255.255.0 192.168.31.250
Remove-NetFirewallRule -DisplayName "Allow WSL2 TCP 5016"
```


**最靠谱的是py和cpp学的tcp client/server**
