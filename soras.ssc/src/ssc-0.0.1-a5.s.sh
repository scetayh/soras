#!/bin/bash

# 遇到错误即终止
#set -e

# 输出原命令
#set -x

# 设置编译信息
export ssc_version="ssc-0.0.1-a5"
export ssc_source="$1"
export ssc_target="$2"

# 写入编译信息
function Ssc_WriteCompilationInfo() {
    {
        echo '#!/bin/bash'
        echo
        echo "## compiler: ${ssc_version}"
        echo "## host: $(uname -a)"
        echo "## date: $(date +%Y%m%dT%H%M%SZ)"
    } >> "${ssc_target}"
}

# 写入包含文件标识头
function Ssc_WriteIncludeHead() {
    echo '## include >>>' >> "${ssc_target}"
}

# 写入包含文件标识尾
function Ssc_WriteIncludeTail() {
    echo '## <<<' >> "${ssc_target}"
}

# 查找包含文件标识头
function Ssc_GetIncludeHead() {
    for ((i=1; i<=$(wc -l < "${ssc_source}"); i++)); do
        [ "$(sed -n "${i}p" "${ssc_source}")" = '##include {' ] &&
            export ssc_includeHead=$((i + 1)) &&
            echo "$ssc_includeHead" &&
            break
    done
}

# 查找包含文件标识尾
function Ssc_GetIncludeTail() {
    for ((i=ssc_includeHead; i<=$(wc -l < "${ssc_source}"); i++)); do
        [ "$(sed -n "${i}p" "${ssc_source}")" = '##}' ] &&
            export ssc_includeTail=$((i - 1)) &&
            echo "$ssc_includeTail" &&
            break
    done
}

# 遍历载入每一包含文件至内存
function Ssc_LoadInclude() {
    for ((i=ssc_includeHead; i<=ssc_includeTail; i++)); do
        ssc_currentContent="$(sed -n "${i}p" "$ssc_source")"
        export ssc_currentContent
        eval "$ssc_currentContent"
    done
}

# 写入内存中的函数
function Ssc_AddInclude() {
    typeset -f >> "${ssc_target}"
}

# 写入其他内容
function Ssc_WriteMain() {
    sed -n "$((ssc_includeTail + 2)),$(($(wc -l < "${ssc_source}") + 1))p" "$ssc_source" >> "$ssc_target"
}

# 写入空白行
function Ssc_WriteBlankLine() {
    echo >> "$ssc_target"
}

# 调用各函数
Ssc_WriteCompilationInfo
Ssc_WriteBlankLine
Ssc_GetIncludeHead
Ssc_GetIncludeTail
Ssc_LoadInclude
Ssc_WriteIncludeHead
Ssc_AddInclude
Ssc_WriteIncludeTail
Ssc_WriteBlankLine
Ssc_WriteMain