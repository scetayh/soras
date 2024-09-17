#!/bin/bash

export ssc_name=ssc;
export ssc_version=0.0.1-b7;

##include {
source /usr/local/lib/slibsh/printmessage.h.sh;
source ../lib/functions.h.sh;
##}

Ssc_PrintBrand;
Ssc_CheckParameters "$@";
ssc_source="$1";
ssc_target="$2";
Ssc_CheckFiles;
ssc_sourceLineNumber=$(wc -l < "$ssc_source")

## 10 检查`##include {' >>>
for ((i=1; i<=ssc_sourceLineNumber; i++)); do \
    [ "$(sed -n "${i}p" "$ssc_source")" = '##include {' ] && \
        ## 若存在则$ssc_includeHead不为空
        export ssc_includeHead=$((i + 1)) && \
            break;
done;
## <<<

## 11A 编译：$ssc_includeHead为空时 >>>
[ -z "$ssc_includeHead" ] && \
    cat "$ssc_source" >> "$ssc_target" && \
        Ssc_WriteCompilationInformation && \
            exit 0;
## <<<

## 11B 编译：$ssc_includeHead不为空时 >>>
## 11B1 检查`##}' >>>
for ((i=ssc_includeHead; i<=ssc_sourceLineNumber; i++)); do \
    [ "$(sed -n "${i}p" "$ssc_source")" = '##}' ] && \
        export ssc_includeTail=$((i - 1)) && \
            break;
done;
## <<<
## 11B2A 编译：$ssc_includeTail为空时 >>>
[ -z "$ssc_includeTail" ] && \
    Slibsh_PrintMessage_Fafal "$0" "\`##}' expected." && \
        exit 1;
## <<<
## 11B2B 编译：$ssc_includeTail不为空时 >>>
## 11B2B2 将前一部分内容写入目标文件 >>>
sed -n "1,$((ssc_includeHead - 2))p" "$ssc_source" >> "$ssc_target"
## <<<
## 11B2B3 将函数递归载入内存 >>>
for ((i=ssc_includeHead; i<=ssc_includeTail; i++)); do
    ssc_currentContent="$(sed -n "${i}p" "$ssc_source")"
    export ssc_currentContent
    eval "$ssc_currentContent"
done
## <<<
## 11B2B4 将内存内函数写入目标文件 >>>
{
    echo '## include >>>'
    typeset -f
    echo '## <<<'
    echo
} >> "$ssc_target"
## <<<
## 11B2B5 将后一部分内容写入目标文件 >>>
sed -n "$((ssc_includeTail + 2)),$((ssc_sourceLineNumber + 1))p" "$ssc_source" >> "$ssc_target"
## <<<
## 11B2B6 清除注释 >>>
sed -i '/#/!b;s/^/\n/;ta;:a;s/\n$//;t;s/\n\(\("[^"]*"\)\|\('\''[^'\'']*'\''\)\)/\1\n/;ta;s/\n\([^#]\)/\1\n/;ta;s/\n.*//' "$ssc_target"
## <<<
Ssc_WriteCompilationInformation
## <<<
## <<<

## 12 修改权限 >>>
chmod 555 -R "$ssc_target"
## <<<