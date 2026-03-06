#!/bin/bash

set -e

rm -rf iperf-3.18
unzip iperf-3.18.zip
cd iperf-3.18

ToolChainPath="$HOME/.toolchain/gcc-sigmastar-9.1.0-2019.11-x86_64_arm-linux-gnueabihf/gcc-sigmastar-9.1.0-2019.11-x86_64_arm-linux-gnueabihf/bin"

export CC="$ToolChainPath/arm-linux-gnueabihf-gcc"
export AR="$ToolChainPath/arm-linux-gnueabihf-gcc-ar"

$CC -v

./configure \
        --host=arm-linux-gnueabihf \
        --disable-shared \
        --enable-static \
        --prefix=$(pwd)/install

make -j8
make install

$ToolChainPath/arm-linux-gnueabihf-strip install/bin/iperf3