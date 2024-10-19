# soras - Soras编程语言源码树

Soras是基于GNU Bash Shell的编程语言。

## Bash `declare`、`declare -g`与`export`

- **Bash实例中**的`declare`为**本Bash实例**声明或赋值变量。
- **函数中**的`declare`为**本函数**声明或赋值变量。
- **Bash实例中**的`declare -g`为**本Bash实例**声明或赋值变量。
- **函数中**的`declare -g`为**本函数**和**本函数所在的Bash实例**声明或赋值变量。
- `export`为**本Bash实例**及**其所有函数**和**其所有子实例**声明或赋值变量。

## Soras保留Bash Shell函数（resfunc）

Resfunc仅用于构造Soras关键字。

Resfunc以下划线为开头，**不处理任何异常**。

```
function _getVarSum () {
    ...
}
```

## 承载Soras变量的Bash Shell变量（shvar）

Shvar将Soras层的变量指向Bash Shell层。

| Soras变量 | 存储其值的shvar | 存储其类型的shvar |
|:---:|:---:|:---:|
| int myVar=3 | ${myVar__s} | ${myVar__t} |
|  | 3 | int |

```
int myVar=3;
```

```
myVar__s=3;
myVar__t=int;
```

## 承载Soras函数的Bash Shell函数（shfunc）

Shfunc将Soras层的函数指向Bash Shell层。

| Soras函数 | 对应shfunc |
|:---:|:---:|
| int myFunction(int arg1, int arg2) { [ ... ] ret myRet; } | function myFunction__f () { ... } |

```
int myFunction(in1 arg1, int arg2) {
    [ ... ]
    ret myRet;
}
```

```
function myFunction__f () {
    ...
}