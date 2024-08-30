#!/bin/bash

# 检查是否指定了输出文件
OUTPUT_FILE="index.md"
if [ "$#" -eq 1 ]; then
    OUTPUT_FILE="$1"
fi

# 创建 Markdown 文件的头部
cat <<EOF > "$OUTPUT_FILE"
# Markdown Files Index

EOF

num=0;
# 递归函数来生成树状结构
generate_tree() {
    local dir="$1"
    local indent="$2"

    # 忽略 .git 目录
    # if [[ "$(basename "$dir")" == ".git" ]]; then
    #     echo $dir "$(basename "$dir")"
    #     return
    # fi

    # 按字母顺序遍历目录中的所有项目，不包含隐藏目录
    for file in "$dir"/*; do
        if [ -d "$file" ]; then
            # 目录处理
            local dir_name=$(basename "$file")
            # 递归检查子目录是否包含 Markdown 文件
            if find "$file" -type f -name "*.md" | grep -q .; then
                echo "${indent}- **$dir_name**" >> "$OUTPUT_FILE"
                generate_tree "$file" "${indent}    "
            fi
        elif [ -f "$file" ] && [[ "$file" == *.md ]]; then
            # Markdown 文件处理
            let num+=1
            local file_name=$(basename "$file")
            local relative_path="${file#./}"
            # 转义特殊字符，并处理空格
            local escaped_path=$(printf '%s' "$relative_path" | sed 's/ /%20/g')
            echo "${indent}- [$file_name]($escaped_path)" >> "$OUTPUT_FILE"
        fi
    done
}

# 生成树状结构的索引
generate_tree "." ""

echo "Index has been generated and saved as $OUTPUT_FILE"
echo "total ${num}"
