# SorasShell

```
make
ssc
```

```
ssc <source file> <target file>
```

在`<source file>`中用`#.include {`和`.#}`加注`source`命令，并使用`ssc`命令编译。

SSC将会把所有`source`后的函数写入`<target file>`。

`<source file>`必须为`.s.sh`后缀名。