#!/bin/bash

##include {
source ../../lib/slibs/printmassage.h.sh
##}

## 3 定义函数 >>>
function Ssc_WriteCompilationInformation() {
    echo "$ssc_compilationInfo" >> "$ssc_target"
}
## <<<

## 4 打印版本 >>>
export ssc_version="$0-0.0.1"
echo "$ssc_version (Soras Shell Compiler)
Copyright (C) 2024 Tarikko-ScetayhChan
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
## <<<

## 5 检查参数 >>>
if [ $# -ne 2 ]; then
    if [ $# -eq 0 ]; then
        Slibs_PrintMessage_Fafal_SourceExpected "$0"
    elif [ $# -eq 1 ]; then
        Slibs_PrintMessage_Fafal_TargetExpected "$0"
    elif [ $# -gt 2 ]; then
        Slibs_PrintMessage_Fafal_TooManyArguments "$0"
    fi
    exit 1
fi
## <<<

## 6 检查文件 >>>
export ssc_source="$1"
export ssc_target="$2"
[ ! -f "$ssc_source" ] && Slibs_PrintMessage_Fafal_ItemNotFound "$0" "$ssc_source" && exit 1
[ -f "$ssc_target" ] && Slibs_PrintMessage_Fafal_ItemExists "$0" "$ssc_target" && exit 1
[ ! "${ssc_source: -5}" = ".s.sh" ] && Slibs_PrintMessage_Fafal_InvalidExtensionName "$0" "$ssc_source" && exit 1
## <<<

## 7 设置编译信息 >>>
ssc_compilationInfo="#!/bin/bash

## compiler: $ssc_version
## host: $(uname -a)
## date: $(date +%Y%m%dT%H%M%SZ)
"
export ssc_compilationInfo
## <<<

## 8 设置源文件行数 >>>
ssc_sourceLineNumber=$(wc -l < "$ssc_source")
export ssc_sourceLineNumber
## <<<

## 9 检查`##include {' >>>
for ((i=1; i<=ssc_sourceLineNumber; i++)); do
    [ "$(sed -n "${i}p" "$ssc_source")" = '##include {' ] &&
        export ssc_includeHead=$((i + 1)) && ## 若存在则$ssc_includeHead不为空
            break
done
## <<<

## 10A 编译：$ssc_includeHead为空时 >>>
[ -z "$ssc_includeHead" ] &&
    Ssc_WriteCompilationInformation &&
        cat "$ssc_source" >> "$ssc_target" &&
            exit 0
## <<<

## 10B 编译：$ssc_includeHead不为空时 >>>
## 10B1 检查`##}' >>>
for ((i=ssc_includeHead; i<=ssc_sourceLineNumber; i++)); do
    [ "$(sed -n "${i}p" "$ssc_source")" = '##}' ] && export ssc_includeTail=$((i - 1)) && break
done
## <<<
## 10B2A 编译：$ssc_includeTail为空时 >>>
[ -z "$ssc_includeTail" ] &&
    Slibs_PrintMessage_Fafal "$0" "\`##}' expected." &&
        exit 1
## <<<
## 10B2B 编译：$ssc_includeTail不为空时 >>>
## 10B2B1 将前一部分内容写入目标文件 >>>
sed -n "1,$((ssc_includeHead - 2))p" "$ssc_source" >> "$ssc_target"
## <<<
## 10B2B2 将函数递归载入内存 >>>
for ((i=ssc_includeHead; i<=ssc_includeTail; i++)); do
    ssc_currentContent="$(sed -n "${i}p" "$ssc_source")"
    export ssc_currentContent
    eval "$ssc_currentContent"
done
## <<<
## 10B2B3 将内存内函数写入目标文件 >>>
{
    echo '## include >>>'
    typeset -f
    echo '## <<<'
    echo
} >> "$ssc_target"
## <<<
## 10B2B4 将后一部分内容写入目标文件 >>>
sed -n "$((ssc_includeTail + 2)),$((ssc_sourceLineNumber + 1))p" "$ssc_source" >> "$ssc_target"
## <<<
## <<<
## <<<

## 11 修改权限 >>>
chmod +rx "$ssc_target"
chmod -w "$ssc_target"
## <<<