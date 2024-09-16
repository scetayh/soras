#!/bin/bash

##include {
source ../../lib/slibs/printmassage.h.sh
##}

## 版本 >>>
export ssc_version="$0-0.0.1"
echo "$ssc_version (Soras Shell Compiler)
Copyright (C) 2024 Tarikko-ScetayhChan
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
## <<<

## 检查参数 >>>
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

## 检查文件 >>>
export ssc_source="$1"
export ssc_target="$2"
[ ! -f "$ssc_source" ] && Slibs_PrintMessage_Fafal_ItemNotFound "$0" "$ssc_source" && exit 1
[ -f "$ssc_target" ] && Slibs_PrintMessage_Fafal_ItemExists "$0" "$ssc_target" && exit 1
[ ! "${ssc_source: -5}" = ".s.sh" ] && Slibs_PrintMessage_Fafal_InvalidExtensionName "$0" "$ssc_source" && exit 1
## <<<

## 处理编译信息 >>>
ssc_sourceLineNumber=$(wc -l < "$ssc_source")
export ssc_sourceLineNumber
ssc_compilationInfo="#!/bin/bash

## compiler: $ssc_version
## host: $(uname -a)
## date: $(date +%Y%m%dT%H%M%SZ)
"
export ssc_compilationInfo
echo "$ssc_compilationInfo" >> "$ssc_target"
## <<<

## 检查`##include {' >>>
for ((i=1; i<=ssc_sourceLineNumber; i++)); do
    [ "$(sed -n "${i}p" "$ssc_source")" = '##include {' ] && export ssc_includeHead=$((i + 1)) && break
done
## <<<

if [ -n "$ssc_includeHead" ]; then ## 如果存在`##include {'

    ## 检查`##}' >>>
    for ((i=ssc_includeHead; i<=ssc_sourceLineNumber; i++)); do
        [ "$(sed -n "${i}p" "$ssc_source")" = '##}' ] && export ssc_includeTail=$((i - 1)) && break
    done
    ## <<<

    if [ -n "$ssc_includeTail" ]; then ## 如果存在`##}'
        ## 将函数递归载入内存 >>>
        for ((i=ssc_includeHead; i<=ssc_includeTail; i++)); do
            ssc_currentContent="$(sed -n "${i}p" "$ssc_source")"
            export ssc_currentContent
            eval "$ssc_currentContent"
        done
        ## <<<
        ## 将内存内函数写入目标文件 >>>
        {
            echo '## include >>>'
            typeset -f
            echo '## <<<'
            echo
        } >> "$ssc_target"
        ## <<<
        ## 将内剩余内容写入目标文件 >>>
        sed -n "$((ssc_includeTail + 2)),$((ssc_sourceLineNumber + 1))p" "$ssc_source" >> "$ssc_target"
        ## <<<
    else ## 如果不存在`##}'
        Slibs_PrintMessage_Fafal "$0" "未闭合" ## to do
        rm -rf "$ssc_target"
        exit 1
    fi

else ## 如果不存在`##include {'

    rm -rf "$ssc_target"
    {
        echo "$ssc_compilationInfo"
        cat "$ssc_source"
    } >> "$ssc_target"

fi

## 修改权限 >>>
chmod +rx "$ssc_target"
chmod -w "$ssc_target"
## <<<