Go
==

Go! It's a programming language. It's like C, but simpler, and with garbage collection. One of Go's design goals is to make the language compact enough that "it can fit in a programmer's head".

Do you like programming in a functional style? Too bad! Welcome to imperative hell. But at least it's _simple_.

Hello, world
------------

Every Go program is made up of packages. Programs start running in the `main` package.

```go
package main

import(
    "fmt"
)

func main() {
    fmt.Println("Hello, world")
}
```

A name (function, variable, or what have you) is exported from a package if it is capitalized. For example, we can use `Println` from the `fmt` package. This would not work if it were not capitalized. These are called _exported names_, and when you import a package, you can only use its exported names.

Functions
---------

Functions can take zero or more arguments and return zero or more results.

```go
func add(x int, y int) int {
    return x + y
}
```

If two or more parameters share a type, you can omit the type declaration from all but the last one.

So this:

```go
x int, y int
```

Can be simplified to:

```go
x, y int
```

Functions can return multiple results, too:

```go
func swap(x, y string) (string, string) {
    return y, x
}
```

Variables
---------

The `var` statement declares a variable or list of variables, and must include a type declaration.

```go
var isFruit bool
var apple, banana string
```

Variables declared without a explicit initial value are given their _zero value_ (`0` for numbers, `false` for booleans, and `""` for strings).

A `var` declaration can also have an initializer (which is just a fancy way of saying you're assigning a value):

```go
var isFruit bool = true
var apple, banana = "Apple", "Banana"
```

Note that you can omit the type declaration when you have an initializer.

Variables can be declared anywhere – either in a function or at the package level.

You can "factor" `var` declarations like this if you like:

```go
var (
    apple string  = "Apple"
    banana string = "Banana"
)
```

Short variable declarations
---------------------------

Inside a function, you can use the `:=` short assignment statement. This declares a `var` with an implicit type.

```go
isFruit := true
```

You _cannot_ use the short assignment statement outside of functions.

Basic Types
-----------

Go's basic types are:

```go
bool

string

int  int8  int16  int32  int64
uint uint8 uint16 uint32 uint64 uintptr

byte // alias for uint8

rune // alias for int32
     // represents a Unicode code point

float32 float64

complex64 complex128
```

The expression `T(v)` converts the value `v` to the type `T`.

```go
numbah := 7
floaty := float64(numbah)
```

Constants
---------

Constants are like variables, but they cannot be reassigned.

```go
const Pi = 3.14
```

Yep, you can factor constants too:

```go
const (
    Pi = 3.14
    Tau =  1.57
)
```

