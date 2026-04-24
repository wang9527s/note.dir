#!/bin/bash

set -e

# 后续修改了xcode的默认版本
# XCODE_LOW="/Applications/Xcode-16.0.0.app"
# if [ ! -d "$XCODE_LOW" ]; then
#     echo "错误: 未找到 $XCODE_LOW，请先安装 Xcode 16.0"
#     echo "  可通过 'xcodes install 16.0' 或从 Apple Developer 下载"
#     exit 1
# fi
# 使用指定版本 Xcode 编译
# export DEVELOPER_DIR="$XCODE_LOW/Contents/Developer"
# echo "==> 使用 Xcode: $XCODE_LOW"

WORKSPACE="LyraMiWear.xcworkspace"
DERIVED_DATA="build/DerivedData"
PRODUCTS="$DERIVED_DATA/Build/Products/Release-watchos"
OUTPUT_DIR="../Frameworks"

# 检查 xcodeproj 是否存在
if [ ! -d "LyraMiWear.xcodeproj" ]; then
    echo "==> xcodeproj 不存在，执行 xcodegen generate..."
    xcodegen generate
fi

# 检查 Pods 是否存在
if [ ! -d "Pods" ]; then
    echo "==> Pods 不存在，执行 pod install..."
    rm -rf Podfile.lock
    pod install
fi

echo "==> 编译 LyraMiWear + Pod frameworks..."
rm -rf "$DERIVED_DATA"
xcodebuild -workspace "$WORKSPACE" \
    -scheme LyraMiWear \
    -sdk watchos \
    -configuration Release \
    -derivedDataPath "$DERIVED_DATA" \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    ARCHS="arm64 arm64_32" \
    -quiet

mkdir -p "$OUTPUT_DIR"

# 拷贝 LyraMiWear.framework
rm -rf "$OUTPUT_DIR/LyraMiWear.framework"
cp -R "$PRODUCTS/LyraMiWear.framework" "$OUTPUT_DIR/"
echo "  LyraMiWear.framework"

# 拷贝所有 Pod framework
for pod_dir in "$PRODUCTS"/*/; do
    fw_name=$(basename "$pod_dir")
    if [ -d "$pod_dir/${fw_name}.framework" ]; then
        rm -rf "$OUTPUT_DIR/${fw_name}.framework"
        cp -R "$pod_dir/${fw_name}.framework" "$OUTPUT_DIR/"
        echo "  ${fw_name}.framework"
    fi
done

echo "==> 完成"
