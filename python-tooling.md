---
title: Python Tooling
theme: laas
data: 2022-05-16
author: Guilhem Saurel
mainfont: Source Serif 4
monofont: Source Code Pro
---

## This presentation

### Available at

\centering

[`https://homepages.laas.fr/gsaurel/talks/
python-tooling.pdf`](https://homepages.laas.fr/gsaurel/talks/python-tooling.pdf)

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
python-tooling.md`](https://gitlab.laas.fr/gsaurel/talks/-/blob/main/python-tooling.md)

<!--
### Discussions

\centering

\url{https://im.laas.fr/\#/room/\#python-tooling:laas.fr}
-->

## Outline

\tableofcontents

# Motivation

## `import this`

The Zen of Python, by Tim Peters (extracts)

- Beautiful is better than ugly.
- Readability counts.
- There should be one-- and preferably only one --obvious way to do it.

## Write readable code

> Code is read much more often than it is written

\hfill --- Guido

. . .

- read → write
- teamwork
- future self


# Style

## PEP 8

### Style Guide for Python Code

https://peps.python.org/pep-0008/

- indentation: 4 spaces
- maximum line length: 79
- whitespaces
- comments
- naming

## pep8 → pycodestyle

https://github.com/PyCQA/pycodestyle

. . .

```
$ pycodestyle --first optparse.py
optparse.py:69:11: E401 multiple imports on one line
optparse.py:77:1: E302 expected 2 blank lines, found 1
optparse.py:88:5: E301 expected 1 blank line, found 0
optparse.py:347:31: E211 whitespace before '('
optparse.py:357:17: E201 whitespace after '{'
optparse.py:472:29: E221 multiple spaces before operator
```

## PEP 257 / pydocstyle

https://github.com/PyCQA/pydocstyle

Mostly helps as a reminder to write some doc

```
$ pydocstyle test.py
test.py:18 in private nested class `meta`:
        D101: Docstring missing
test.py:27 in public function `get_user`:
    D300: Use """triple double quotes""" (found '''-quotes)
test:75 in public function `init_database`:
    D201: No blank lines allowed before function docstring (found 1)
```

## flake8

https://github.com/PyCQA/flake8

pycodestyle  + pyflakes + mccabe

## yapf

https://github.com/google/yapf

clang-format / gofmt


```python
x = {  'a':37,'b':42,

'c':927}
```

. . .

```python
x = {'a': 37, 'b': 42, 'c': 927}
```

## black

https://github.com/psf/black

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

## isort

https://github.com/PyCQA/isort

sorts imports.

# Packaging

## Poetry

https://github.com/python-poetry/poetry

- `poetry init`
- `pyproject.toml`
- minimal python version
- dependencies / dev-dependencies
- virtualenv
- sdist / wheel builder

## Others

ref. "[Managing Python Packages](https://homepages.laas.fr/gsaurel/talks/managing-python-packages.pdf)"

# Tests

## unittest

https://docs.python.org/3/library/unittest.html

```python
import unittest

class TestStringMethods(unittest.TestCase):

    def test_upper(self):
        self.assertEqual('foo'.upper(), 'FOO')

    def test_isupper(self):
        self.assertTrue('FOO'.isupper())
        self.assertFalse('Foo'.isupper())


if __name__ == '__main__':
    unittest.main()
```

## unittest launch

```
$ python test_string.py
..
--------------------------------------------------
Ran 2 tests in 0.000s

OK

```

. . .

ou

```
$ python -m unittest
..
--------------------------------------------------
Ran 2 tests in 0.000s

OK
```

## doctest

https://docs.python.org/3/library/doctest.html

```python
def factorial(n):
    """Return the factorial of n, an exact integer >= 0.

    >>> [factorial(n) for n in range(6)]
    [1, 1, 2, 6, 24, 120]
    >>> factorial(30)
    265252859812191058636308480000000
    >>> factorial(-1)
    Traceback (most recent call last):
        ...
    ValueError: n must be >= 0
    """

```

## doctest launch

```python
if __name__ == "__main__":
    import doctest
    doctest.testmod()
```

## Others

- pytest
- tox

# Coverage

## Coverage.py

https://github.com/nedbat/coveragepy

```
$ coverage run -m unittest discover
$ coverage report -m
Name                  Stmts   Miss  Cover   Missing
---------------------------------------------------
my_program.py            20      4    80%   33-35, 39
my_other_module.py       56      6    89%   17-23
---------------------------------------------------
TOTAL                    76     10    87%
```
. . .

```
$ coverage html
```
[sample](https://nedbatchelder.com/files/sample_coverage_html/index.html)

## online

- https://coveralls.io/
- https://about.codecov.io/

## Gitlab

Settings → CI/CD → General pipelines → Test coverage parsing

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

https://github.com/asottile/pyupgrade

```diff
 class C(Base):
     def f(self):
-        super(C, self).f()
+        super().f()
```

## Pylint

pass…

# Meta

## Editor / IDE integration

Bring your own ;)

## pre-commit

## pre-commit CI

## Badges

- ![](media/codecov.png)
- ![](media/pre-commit-ci.png)
- ![](media/badge-black.png)
- ![](media/gitlab.png)

## Questions ?

Thanks for your time :)

## Proposition

- flake8
- black
- isort
- pyupgrade
- pre-commit
