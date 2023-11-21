---
title: Tooling
subtitle: for Python & C++
theme: laas
date: 2022-06-01
author: Guilhem Saurel
mainfont: Source Serif 4
monofont: Source Code Pro
---

## This presentation

### Available at

\centering

[`https://homepages.laas.fr/gsaurel/talks/
tooling.pdf`](https://homepages.laas.fr/gsaurel/talks/tooling.pdf)

### Under License

\centering

![CC](media/cc.png){width=1cm}
![BY](media/by.png){width=1cm}
![SA](media/sa.png){width=1cm}

<https://creativecommons.org/licenses/by-sa/4.0/>

## This presentation (continued)

### Source

\centering

[`https://gitlab.laas.fr/gsaurel/talks :
tooling.md`](https://gitlab.laas.fr/gsaurel/talks/-/blob/main/tooling.md)

### Discussions

\centering

\url{https://im.laas.fr/\#/room/\#python-tooling:laas.fr}

## Outline

\tableofcontents

# Motivation

## Write readable code

> Code is read much more often than it is written

\hfill --- Guido Van Rossum

. . .

- read → write
- teamwork
- future self

# Style

## PEP 8

### Style Guide for Python Code

[https://peps.python.org/pep-0008/](https://peps.python.org/pep-0008/)

- indentation: 4 spaces
- maximum line length: 79
- whitespaces
- comments
- naming

## pep8 → pycodestyle

[https://github.com/PyCQA/pycodestyle](https://github.com/PyCQA/pycodestyle)

. . .

```
$ pycodestyle --first optparse.py
optparse.py:69:11: E401 multiple imports on one line
optparse.py:347:31: E211 whitespace before '('
optparse.py:357:17: E201 whitespace after '{'
optparse.py:472:29: E221 multiple spaces before operator
```

## flake8

[https://github.com/PyCQA/flake8](https://github.com/PyCQA/flake8)

pycodestyle + pyflakes + mccabe

## clang-format

[https://clang.llvm.org/docs/ClangFormat.html](https://clang.llvm.org/docs/ClangFormat.html)

```bash
$ clang-format -i QGVCore/QGVScene.cpp
```
```diff
@@ -173,14 +173,11 @@
   // Update items layout
-  foreach( QGVNode* node, _nodes ) {
-    node->updateLayout();
-  }
+  foreach (QGVNode *node, _nodes) node->updateLayout();
```

## yapf

[https://github.com/google/yapf](https://github.com/google/yapf)

based on clang-format / gofmt, but for python


```python
x = {  'a':37,'b':42,

'c':927}
```

. . .

```python
x = {'a': 37, 'b': 42, 'c': 927}
```

## black

[https://github.com/psf/black](https://github.com/psf/black)

![black](media/black.png)



## black main caveat

```python
super_long_line.with_small_argument = [0]  # some comment
```

. . .


```python
super_long_line.with_small_argument = [
    0
]  # some comment
```

. . .

```python
# some comment
super_long_line.with_small_argument = [0]
```

# Static analysis

## Mypy: motivation

```python
def add(a: int, b: int) -> int:
    """Performs addition on integers.

    >>> add(3, 4)
    7
    """
    return a + b


if __name__ == "__main__":
    import sys

    print(add(sys.argv[1], sys.argv[2]))
```

## Mypy

```
$ python add.py 3 4
34
```

. . .


```
$ mypy add.py
add.py:13: error: Argument 1 to "add" has incompatible
                  type "str"; expected "int"
add.py:13: error: Argument 2 to "add" has incompatible
                  type "str"; expected "int"
Found 2 errors in 1 file (checked 1 source file)
```

## pyupgrade

[https://github.com/asottile/pyupgrade](https://github.com/asottile/pyupgrade)

```diff
 class C(Base):
     def f(self):
-        super(C, self).f()
+        super().f()
```

. . .

For C++: `clang-tidy`

# Meta

## Editor / IDE integration

Bring your own ;)

## pre-commit

[https://github.com/pre-commit/pre-commit](https://github.com/pre-commit/pre-commit)

```bash
$ cat .pre-commit-config.yaml
```

```yaml
repos:
-   repo: https://github.com/psf/black
    rev: 22.3.0
    hooks:
    -   id: black
-   repo: https://github.com/pre-commit/mirrors-clang-format
    rev: v14.0.3
    hooks:
    -   id: clang-format
        args: [-i, --style=Google]
```

## pre-commit usage

```
pre-commit run -a
```

. . .

```
pre-commit install
```

## pre-commit CI

[https://pre-commit.ci/](https://pre-commit.ci/)

## That's all folks !

Thanks for your time :)
