PYTHON
======

An interpreted, high-level, dynamic programming language.

Scalar Types
------------

`1`    int

`3.5`  float

`"hi"` str

Assignment
----------

Single assignment:

```
pi = 3.1459
```

_Multiple_ assignment!: 

```
a, b = 0, 1

print(a)
>>> 0

print(b)
>>> 1
```

Numerics 
--------

```
1 + 2
>>> 3

5 * 3
>>> 15

5 / 2
>>> 2.5

5 // 2 
>>> 2
```


Strings
-------

Important to note that Python strings are immutable.

Can be single or double-quoted:

```
'Hello there'
"Hello there"
```

String concatenation and multiplication:

```
'Hi' + ' there!'
>>> 'Hi there!'

'quack' * 5
>>> 'quackquackquackquackquack'
```

Multiline strings:

```
big_string = """\
Neat I can have
multiline strings
"""
```

String indexing and slicing:

```
word = 'Ducks'

word[0]
>>> 'D'

word[0:4]
>>> 'Duck'
```

To get the length of a string:

```
len(word)
>>> 5
```

Booleans
--------

About what you'd expect:

```
True
False
```

But not that `&&` and `||` are not a thing, instead:

```
True and x > 1
x == 1 or True
```


Lists
-----

The most commonly used collection type in Python.

By convention (there's no type checking after all), lists are of one homogenous type. If you want a collection of mixed types, you would use a tuple.

```
squares = [1, 2, 4, 9, 16, 25]

squares[0]
>>> 1

squares[3:5]
>>> [9, 16]
```

Appending:

```
squares.append(36)
>>> [1, 2, 4, 9, 16, 25, 36] 
```

To get the length of a list:

```
len(squares)
>>> 7
```

Other common list functions. Keep in mind that most of these _mutate_ the list:

```
list = [1, 2, 3]

list = list.remove(1)
>>> [2, 3]

list.count(2)
>>> 1

list.reverse()
>>> [3, 2, 1]

list.sort()
>>> [1, 2, 3]
```

Control Flow
------------

Basic control flow with `if`, `elif`, and `else`:

```
if x > 0:
    print('x is positive')
elif x < 0:
    print('x is negative')
else:
    print('x is probably zero')
```

For statements 
--------------

For are the standard way to iterate over collections and strings.

```
squares = [1, 2, 4, 9, 16]

for n in squares:
    print(n)
```

Works for strings as well:

```
word = "Ducks"

for w in word:
  print(n)
```

`range` is a convenient way to iterate over numbers:

```
for n in range(10):
  print(n)
```

Functions
---------

Defining a function:

```
def fib(n):
    """Prints the n-th number in the Fibonacci sequence."""
    if n <= 1:
        return 1
    else:
        return fib(n - 2) + fib(n - 1)
```

The first line in a function may be an optional "docstring".

Default arguments work as you'd expect:

```
def favorite_color(color='red'):
    print('My favorite color is', color)
```

Python has keyword arguments, which is great:

```
def divide(dividend, divisor):
    return dividend / divisor

divide(divisor=3, dividend=6)
>>> 2.0
```

Splat arguments are also a thing:

```
def splat(args*):
    return args

splat(1, 2, 3)
>>> (1, 2, 3)
```

Splat arguments are converted into a tuple.

Lambda expressions
------------------

A 'lambda' is just an anonymous function. They must be a single expression.

```
doubler = lambda x: x * 2

doubler(4)
>>> 8
```

Functions are first class in Python:

```
def map(list, func):
    mapped = []
    for x in list:
        mapped.append(func(x))
    return mapped

map([1, 2, 3], lambda n: n * 2)
>>> [2, 4. 6]
```

For comprehensions
------------------

These are useful for building lists and are very commonly used in Python.

```
squares = [x**2 for x in range(10)]

squares
>>> [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
```

The general syntax for a `for` comprehension is as follows:

```
[<expression> for <x> in <list>]
```

You can chain together `for` clauses, and even add an `if`:

```
[(x, y) for x in [1,2,3] for y in [3,1,4] if x != y]
>>> [(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]
```

Tuples
------

Another common collection ("sequence") type.

```
birds = ('sparrow', 'crow', 'robin')
```

Tuples are very similar to lists, except:

  * They are immutable
  * Often contain mixed types (lists are usually of only one type)

You can also instantiate tuples like this:

```
birds = 'sparrow', 'crow', 'robin'
```

You can do the _reverse_ too. This is called "sequence unpacking":

```
s, c, r = birds

s
>>> 'sparrow'
```

Sets
----

Python also has a built-in set type, which is neat.

```
colors = {'blue', 'red', 'green'}

'red' in colors
>>> True

'banana' in colors
>>> False
```

Common set operations:

```
# Intersect:
a & b

# Difference:
a - b

# Union:
a | b
```

Dictionaries
------------

Dictionaries are Python's standard key-value data structure.

```
ages = {'anna': 29, 'john': 31}

ages['anna']
>>> 29

list(ages.keys())
>>> ['anna', 'john']

list(ages.values())
>>> [29, 31]

sounds = dict([('dog', 'woof'), ('cat', 'meow')])
>>> {'dog': 'woof', 'cat': 'meow'}
```

"dict comprehensions" are also a thing, cf. "for comprehensions" section:

```
doubles = {x: x * 2 for x in range(5)} 
>>> {0: 0, 1: 2, 2: 4, 3: 6, 4: 8}
```

You can use keyword arguments to simplify creation of a dict with string keys:

```
ages = dict(anna=29, john=31)
>>> {'anna': 29, 'john': 31}
```

Looping Techniques
------------------

Some common looping techniques over data structures:

```
knights = {'gallahad': 'the pure', 'robin': 'the brave'}

for k, v in knights.items():
    print(k, v)
```

Looping with an index using `enumerate`:

```
for i, v in enumerate(['tic', 'tac', 'toe']):
    print(i, v)
```

