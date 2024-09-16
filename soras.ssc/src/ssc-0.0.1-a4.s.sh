#!/bin/bash

# 遇到错误即终止
set -e

# 写入编译信息
export sscTmp_version="ssc-0.0.1-a4"
export sscTmp_sourceFile="$1"
export sscTmp_targetFile="$2"
{
    echo '#!/bin/bash'
    echo
    echo "## compiler: ${sscTmp_version}"
    echo "## host: $(uname -a)"
    echo "## date: $(date +%Y%m%dT%H%M%SZ)"
    echo
    echo "## include {"
    echo
} > "${sscTmp_targetFile}"

# 定义主函数
for ((h=1; h>0; h++)); do
# 建议使用原生命令，尽量避免使用临时函数
# 使用"$1"作为脚本的"$sscTmp_sourceFile"
# 使用"$2"作为脚本的"$sscTmp_targetFile"
    export sscTmp_IncludeFiles=""
    # 1. 寻找开始包含的行序号为$sscTmp_includeStartLine
    #echo "$2"
    #echo $(wc -l < "$2")
    for ((i=1; i<=$(wc -l < "$2"); i++)); do
        [ "$(sed -n "${i}p" "$2")" = "##include {" ] && # "$(sed -n "${i}p" "$2")"表示第$i行内容
            export sscTmp_includeStartLine=$((i + 1)) &&
            break
    done

    # 2. 寻找结束包含的行序号为$sscTmp_includeEndLine
    for ((i=sscTmp_includeStartLine; i<=$(wc -l < "$2"); i++)); do
        [ "$(sed -n "${i}p" "$2")" = "##}" ] &&
            export sscTmp_includeEndLine=$((i - 1)) &&
            break
    done

    # 3. 将所有包含文件添加到变量$sscTmp_IncludeFiles
    #echo $sscTmp_includeStartLine
    #echo $sscTmp_includeEndLine
    for ((i=sscTmp_includeStartLine; i<=sscTmp_includeEndLine; i++)); do
        export sscTmp_LineIContent="$(sed -n "${i}p" "$2")"
        [ -n "$sscTmp_LineIContent" ] &&
            export sscTmp_IncludeFiles="$sscTmp_IncludeFiles ${sscTmp_LineIContent#*source }"
    done
    echo "$sscTmp_IncludeFiles"

    # 4. 写入包含文件内容
    for i in $sscTmp_IncludeFiles; do
        cat "$i" >> "$sscTmp_targetFile"
        echo >> "$sscTmp_targetFile"
    done

    # 5. 格式化
    sed -i '/#/!b;s/^/\n/;ta;:a;s/\n$//;t;s/\n\(\("[^"]*"\)\|\('\''[^'\'']*'\''\)\)/\1\n/;ta;s/\n\([^#]\)/\1\n/;ta;s/\n.*//' "$2"

    # 6. 检验是否不再存在包含文件
    #echo "$sscTmp_IncludeFiles"
    [ -z "$sscTmp_IncludeFiles" ] && break
done