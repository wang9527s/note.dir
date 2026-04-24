#!/bin/bash
# build_app.sh — 生成主工程 Xcode 项目文件
set -e

cd "$(dirname "$0")"

echo "==> 生成 WatchDemo.xcodeproj..."
xcodegen generate

# 使用指定版本xcode
# open -a /Applications/Xcode-16.0.0.app ./WatchDemo.xcodeproj

echo "==> 完成，使用 Xcode 打开 WatchDemo.xcodeproj"
