#!/bin/bash

set -e

ToolChainPath="$HOME/.toolchain/gcc-sigmastar-9.1.0-2019.11-x86_64_arm-linux-gnueabihf/gcc-sigmastar-9.1.0-2019.11-x86_64_arm-linux-gnueabihf/bin"

export CC="$ToolChainPath/arm-linux-gnueabihf-gcc"
export CXX="$ToolChainPath/arm-linux-gnueabihf-g++"
export AR="$ToolChainPath/arm-linux-gnueabihf-gcc-ar"
export RANLIB="$ToolChainPath/arm-linux-gnueabihf-gcc-ranlib"
export LD="$ToolChainPath/arm-linux-gnueabihf-ld"
export STRIP="$ToolChainPath/arm-linux-gnueabihf-strip"

HOST=arm-linux-gnueabihf

# libpcap 版本
LIBPCAP_VER=1.10.5
TCPDUMP_VER=4.99.3

mkdir -p ~/tcpdump && cd ~/tcpdump

if [ ! -f "libpcap-$LIBPCAP_VER.tar.gz" ]; then
    wget https://www.tcpdump.org/release/libpcap-$LIBPCAP_VER.tar.gz
fi

if [ ! -f "tcpdump-$TCPDUMP_VER.tar.gz" ]; then
    wget https://www.tcpdump.org/release/tcpdump-$TCPDUMP_VER.tar.gz
fi

tar xf libpcap-$LIBPCAP_VER.tar.gz
tar xf tcpdump-$TCPDUMP_VER.tar.gz

# 安装目录统一
INSTALL_DIR="$HOME/tcpdump/build"
mkdir -p "$INSTALL_DIR"

# 编译 libpcap
cd libpcap-$LIBPCAP_VER
./configure --host=$HOST --prefix=$INSTALL_DIR --disable-shared
make -j$(nproc)
make install
cd ..

# 编译 tcpdump
cd tcpdump-$TCPDUMP_VER
./configure --host=$HOST --prefix=$INSTALL_DIR --with-pcap=$INSTALL_DIR --disable-shared
make -j$(nproc)
make install
cd ..
