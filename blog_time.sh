#!/bin/bash
# blog_stamp.sh — 文件末尾追加 <small> 创建/更新 戳
# 用法: blog_stamp.sh <file|dir> [-r]   (-r 仅对 dir 递归)
# created=git 首次提交日期(新文件用今天)
# 先删任何旧戳 (HTML注释/<sub>/<small>, 任意位置), 再末尾追加

today=$(date +%Y-%m-%d)

created_of() {
  # created = git 首次提交日期; 无则用今天
  local d
  d=$(git log --diff-filter=A --follow --date=short --format='%ad' -- "$1" 2>/dev/null | tail -1)
  echo "${d:-$today}"
}

updated_of() {
  local d
  d=$(git log -1 --date=short --format='%ad' -- "$1" 2>/dev/null)
  echo "${d:-$today}"
}

update_file() {
  local file=$1 created updated new tmp last
  created=$(created_of "$file")
  # update时间，采用git最后一次commit时间，或者今天
  updated=$(updated_of "$file")
  # updated=$today
  new=$(printf '<div align="right"><font color="#999"><small>📅 Created: %s  ·  ✏️ Update: %s</small></font></div>' "$created" "$updated")
  tmp=${TMPDIR:-/tmp}/.bt_stamp.$$

  awk '
    /<!-- blog: created=.*updated=.* -->/ {next}
    /<(sub|small)>.*[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].*<\/(sub|small)>/ {next}
    { lines[++n]=$0 }
    END { while(n>0 && lines[n]=="") n--; for(i=1;i<=n;i++) print lines[i] }
  ' "$file" > "$tmp"
  mv "$tmp" "$file"

  # 末尾追加: 空行 + 戳 (内容已以换行结尾)
  printf '\n%s\n' "$new" >> "$file"
}

# 解析参数: -r 递归, 其余当 path
path= recursive=0
while [ $# -gt 0 ]; do
  case "$1" in -r) recursive=1 ;; *) path=$1 ;; esac
  shift
done

[ -n "$path" ] || { echo "Usage: $0 <file|dir> [-r]" >&2; exit 2; }
[ -e "$path" ] || { echo "Error: 不存在: $path" >&2; exit 1; }

# 收集文件列表
if [ -f "$path" ]; then
  files=$path
else
  depth=(-maxdepth 1); [ "$recursive" = "1" ] && depth=()
  files=$(find "$path" "${depth[@]}" -type f -name '*.md' | sort)
fi

## 使命已结束
echo "使命已结束"
exit
while IFS= read -r f; do
  [ -z "$f" ] && continue
  update_file "$f"
done <<< "$files"
