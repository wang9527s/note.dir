#!/bin/bash

set e

init-deepin() {
    echo "init deepin"

    gsettings set com.deepin.dde.dock display-mode "efficient"      # "fashion"   "efficient"
    gsettings set com.deepin.dde.dock position "left"               # "top" 或 "bottom" 或 "left" 或 "right"

    uos-set-no-password true
    uos-set-auto-login true
}

set-wbash() {
    if [ e "$HOME/.wbash" ];
    then
        echo "$HOME/.wbash already exists"
        return
    fi

    echo "开始配置wbash"
    # 下载wbash
    if [ ! -f "wbash.zip" ]; then
        git clone https://github.com/GitHub-wang9527/wbash.git ~/.wbash
    else
        unzip wbash.zip
        mv wbash ~/.wbashrc
    fi

    bashrc="$HOME/.wbash/wbashrc"
    updatebash="$HOME/wbash./wang/update-bashrc"

    # bash $updatebash "source $bashrc" ~/.bashrc
    bash $updatebash "source $bashrc" ~/.zshrc
}

set-zsh() {
    if [ e "$HOME/.oh-my-zsh" ];
    then
        echo "$HOME/.oh-my-zsh already exists"
        return
    fi

    if [ ! -f "oh-my-zsh.zip" ];
    then 
        echo "下载 oh-my-zsh"
        curl -O https://raw.githubusercontent.com/GitHub-wang9527/env/main/zsh/oh-my-zsh.zip
    fi

    echo "解压oh-my-zsh"
    unzip oh-my-zsh.zip
    rm oh-my-zsh.zip

    mv oh-my-zsh ~/.oh-my-zsh
    mv ~/.oh-my-zsh/.zshrc ~

    echo "配置zsh"
    # sudo chsh -s /bin/zsh 
    echo " if [ -t 1 ]; then zsh; fi"  >> ~/.bashrc 
}

# 设置开机启动ssh （下面两个都可以）
sudo update-rc.d ssh enable			
# sudo systemctl enable ssh.service

# 安装必备包
sudo apt update
sudo apt install gedit git wget curl unzip zsh

set-zsh()
set-wbash()

# 查看系统版本，还有多种方法 
#   cat /etc/os-*
#   uname
#   lsb_release -a
if [[ `hostnamectl |grep "Operating System"` =~ "Deepin" ]];
then 
    init-deepin();
fi
