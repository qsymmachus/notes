Go
==

Go! It's a programming language. It's like C, but simpler, and with garbage collection. One of Go's design goals is to make the language compact enough that "it can fit in a programmer's head".

Do you like programming in a functional style? Too bad! Welcome to the imperative funhouse. But at least it's _simple_.

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

For Loops
---------

Go has only one looping construct, the `for` loop.

```go
func main() {
    sum := 1
    for i := 0; i < 10; i++ {
        sum += i
    }

    return sum
}
```

The `init` and `post` statements are optional, so you can loop with just the `conditional`:

```go
func main() {
    sum := 0
    for sum < 1000 {
        sum += 1
    }

    return sum
}
```

Note that when you just include the conditional in this way, `for` works the same way as a `while` loop.

If and else
-----------

Go's `if` statements are about what you'd expect, but there's no need for parentheses around the conditional.

```go
func happy(isHappy bool) {
    if isHappy {
        fmt.Println("I'm happy too!")
    } else {
        fmt.Println("Oh I'm sorry! Cheer up.")
    }
}
```

You can also nest `else if` statements, though if you have more than two conditions, you might consider using `switch` instead.

```go
if y < 10 {
    fmt.Println("y < 10")
} else if y > 10 {
    fmt.Println("y > 10")
} else {
    fmt.Println("y = 10")
}
```

Switch
------

Go's switch statements match on equality, and can match on any value. A case can test multiple values.

Note that, unlike C, switch cases do not "fall through." What would be a `break` in C is supplied automatically between the cases. You can add explicit `fallthrough` statements if you need the C case-combining behavior, but these situations are better handled by listing multiple values on a single `case` branch.

```go
func main() {
    today:= time.Now().Weekday()

    switch time.Friday {
        case today:
            fmt.Println("Today.")
        case today + 1, today + 2:
            fmt.Println("Soon.")
        default:
            fmt.Println("Not soon enough...")
    }
}
```

Switch without an initial condition value is the same as `switch true`. This allows you to match on the first `true` condition, so it's an easy way to write long conditional chains.

```go
func main() {
    hour := time.Now().Hour()

    switch {
        case hour < 12:
            fmt.Println("Good morning!")
        case hour < 17:
            fmt.Println("Good afternoon.")
        default:
            fmt.Println("Good evening.")
    }
}
```

Pointers
--------

A pointer holds the memory address of a value. The type `*T` is a pointer to a `T` value. Its zero value is `nil`.

```go
var pointer *int
```

The `&` operator generates a pointer to its operand.

```go
i := 7
pointer = &i
```

The `*` operator denotes the pointer's underlying value. This is known as "dereferencing".

```go
// prints 7, since the pointer references the value of i.
fmt.Println(*pointer)

// Sets i to a new value, through the pointer.
*pointer = 21
```

Structs
-------

A struct represents structured data.

```go
type Person struct {
    Name string
    Age int
}

func main() {
    me := Person{"John", 32}
    fmt.Println(me.Name)
}
```

You can create struct values with named fields ("struct literals")

```go
// Since we didn't specify `age`, it defaults to the type's zero value (for an `int`, it's 0).
ageless := Person{name: "Ageless"}
```

Arrays & Slices
---------------

The type `[n]T` is an array of `n` values of type `T`. Yep, the size of the array is statically typed.

```go
primes := [5]int{2, 3, 5, 7, 11}
```

An array has a fixed size, a slice is dynamically sized. As a result slices are far more common in Go than arrays.

The type `[]T` is a slice with elements of type `T`.

A slice is formed by specifying and upper and lower index, which selects a range that includes the first element, but excludes the last one.

```go
primes := [5]int{2, 3, 5, 7, 11}

// This slices [2, 3, 5]
sliced := primes[0:4]
```

You may also omit the high or low index. By default, the low index will be 0, and the high index will be the length of the array:

```go
// These slice expressions are all equivalent.
a[0:10]
a[:10]
a[0:]
a[:]
```

You can think of a slice as a _reference_ to an array. It just points to a section of that array. __Note__ that changing the elements of a slice will change those elements in the referenced array, too!

You can skip the manual slicing with a _slice literal_, which simultaneously creates a slice and the underlying array it references:

```go
primes := []int{2, 3, 5, 7, 11, 13}
```

A slice has a _length_ (`len(primes)`), which is the number of elements in the slice, and a _capacity_ (`cap(primes)`), which is the number of elements in the underlying array, counting from the first element in the slice.

You can append to a slice with the `append` function. Append takes a slice of type `T`, and the remaining arguments are `T` values to add to the slice.

```go
var primes []int

primes = append(primes, 2, 3, 5)
```

Appending two slices can be done with the `...` operator, which "unpacks" the second slice:

```go
a := []int{1, 2, 3}
b := []int{4, 5, 6}

appended := append(a, b...)
// [1 2 3 4 5 6]
```

If the backing array is too small, a bigger array will be allocated automatically for the slice. Note that `append` does not mutate the slice, but returns a new slice with the appended elements.

Range
-----

`range` is a very useful construct for iterating over a slice or map. When ranging over a slice, two values are returned for each iteration – first, the index, and second, the element at that index.

```go
primes := []int{2, 3, 5, 7, 11, 13}

for i, n := range primes {
    fmt.Printf("index: %d element: %d", i, n)
}
```

If you don't care about one of those two values (usually the index), you can omit it with `_`:

```go
for _, n := range primes {
    fmt.Printf("%d", n)
}
```

Maps
----

A map maps keys to values. The zero value of a map is `nil`, sadly.

The `make` function returns a map of the given type:

```go
m := make(map[string]string)

m["John"] = "Olmsted"
fmt.Println(m["John"]) // this prints "Olmsted"
```

Alternatively you can skip make and use a _map literal_, but you must provide some initial keys:

```go
m := map[string]string{
    "John": "Olmsted",
    "Anna": "Gallagher"
}
```

To insert or update an element:

```go
m["key"] = "value"
```

To retrieve an element:

```go
elem = m["key"]
```

To delete an element:

```go
delete(m, "key")
```

Test that a key is present with a two-value assignment. `ok` will be `true` if the key exists:

```go
elem, ok := m["Sally"]

if ok {
    fmt.Println(elem)
}
```

First class functions
---------------------

Functions are first class in Go, hooray! They can be passed as arguments and returned by other functions.

Here's an example function `Map`, that takes a function as an argument and maps it over array elements:

```go
package main

import (
	"fmt"
)

func Map(nums []int, fn func(int) int) []int {
	mapped := []int{}

	for _, n := range nums {
		mapped = append(mapped, fn(n))
	}

	return mapped
}

func main() {
	nums := []int{1, 2, 3, 4, 5}

	doubled := Map(nums, func(n int) int {
		return n * 2
	})

	fmt.Println(doubled)
}
```

Methods
-------

Go does not have classes. However, you can define methods on types.

A method is a function with a _receiver_ argument. This allows you to define methods on the specified type.

```go
type Person struct {
	Name string
}

// Here, 'p' is the receiver argument. It comes after the 'func' keyword and before the function name.
func (p Person) Hello() {
	fmt.Printf("Hello, my name is %s!", p.Name)
}

func main() {
	me := Person{"John"}
	me.Hello()
}
```

You can declare methods on `type` aliases as well, not just `struct`s. The only important restriction is that you can only declare methods on types that are defined in the same package. You cannot declare methods for imported types, including Go's core types like `int`.

Pointer and Value Receivers
---------------------------

So far our receiver arguments have been _value receivers_. This means that the methods cannot _mutate_ the state of the instance they are called on.

```go
type Vertex struct {
	X, Y float64
}

// This won't actually change the state of `v` at all, because we're using a value receiver.
func (v Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}
```

If we want a method to change state, we must use a _pointer receiver_, which is prefixed with the `*` operator:

```go
type Vertex struct {
	X, Y float64
}

// *Vertex is a pointer receiver, so called `v.Scale()` will actually change the state of `v`.
func (v *Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}
```

In Go, pointer receivers are generally preferred for the following reasons:

1. It allows a method to actually modify the value's state.
2. It avoids creating a copy of the value if we _do_ change state.

In general, all methods on a given type should have either value or pointer receivers, but not a mixture of both.

Interfaces
----------

An _interface type_ is a collection of method signatures.

Interfaces are implemented _implicitly_. A type implements an interface by simple implementing its methods. In other words, interfaces are _duck-typed_.

```go
package main

import "fmt"

type Barker interface {
	Bark()
}

type Dog struct {
	Name string
}

// This method means that `Dog` implements `Barker`, but we don't need to explicitly indicate this. It's duck-typed.
func (d Dog) Bark() {
	fmt.Printf("Woof! My name is %s.", d.Name)
}

func main() {
	var rosie Barker = Dog{"Rosie"}
	rosie.Bark()
}
```

Implicit interfaces decouple the definition of an interface from its implementation, which is pretty nice.

You can think of interface values as a tuple of `(Type, Implementation)`. So continuing with the example above, `rosie` is a variable of type `(Barker, Dog)`. When you call methods on `rosie`, it uses the concrete value.

What if the concrete value is `nil`? For example, we could declare an interface variable without actually assigning a value:

```go
var borker Barker
```

In this case the underlying type is `(Barker, nil)`. If you call an interface method on it, you'll get a run-time error.

The interface type that specifies _zero_ methods is known as an _empty interface_:

```go
interface{}
```

Empty interfaces are often used to represent values of unknown type. For example, `fmt.Printf` takes any number of arguments of type `interface{}`. That's a little odd, if you ask me, but it works.

Type Assertions
---------------

A _type assertion_ allows you to access an interface value's underlying concrete value:

```go
var rosie Barker = Dog{"Rosie"}
d := rosie.(Dog)
```

This forces the `rosie` interface value to give up the `Dog` concrete value it stores, and assigns it to `d`.

What if `rosie` doesn't actually store a `Dog`? In that case, you get a panic! You can safely test for this by assigning the type assertion to two values: the underlying value and a boolean value that reports whether the assertion succeeded:

```go
var rosie Barker = Dog{"Rosie"}
d, ok := rosie.(Dog)
```

In this case, if `rosie` does not contain a `Dog`, then `ok` will be false and `d` will be a zero value of type `Dog`. No panic is needed this time!

Type Switching
--------------

You can use the `switch` statement to pattern-match based on type:

```go
switch v := rosie.(type) {
    case Dog:
        fmt.Printf("%T is a dog!", v)
    case Cat:
        fmt.Printf("%T is a cat!", v)
    default:
        fmt.Printf("I don't know what %T is!", v)
}
```

Common interfaces
-----------------

There are a number of interfaces that are show up frequently in Go.

### Stringer

The first, `Stringer`, is what the `fmt` package uses to print types. If you want to print one of your types a particular way, you just need to implement `Stringer`:

```go
type Stringer interface {
    String() string
}
```

### Error

Another common interface is `error`. Functions often return an `error` value, which is either `nil` if no error occured, or a value that implements `error`.

```go
type error interface {
    Error() string
}
```

Here's an example of a custom error, `ErrNegativeSqrt`, that implements the `error` interface. We throw this error if the function `Sqrt` is given a negative number.

```go
package main

import (
	"fmt"
	"math"
)

func Sqrt(x float64) (float64, error) {
	if (x < 0) {
		return 0, ErrNegativeSqrt(x)
	}

	return math.Sqrt(x), nil
}

type ErrNegativeSqrt float64

func (e ErrNegativeSqrt) Error() string {
	return fmt.Sprintf("cannot Sqrt a negative number: %d", e)
}

func main() {
	fmt.Println(Sqrt(2))
	fmt.Println(Sqrt(-2))
}
```

### Reader

The `io` package specifies the `io.Reader` interface, which is very common. It represents the read end of a stream of data.

The `Reader` interface has a `Read` method:

```go
func (T) Read(b []byte) (n int, err error)
```

The method populates the given byte slice with data and returns the number of bytes populated and an error value.

Here's a dumb example that just streams an infinite series of the character `'A'` (or to put it another way, fills the provided byte slice with `'A'`s):

```go
type MyReader struct{}

func (r MyReader) Read(b []byte) (n int, err error) {
	for i, _ := range b {
		b[i] = 'A'
	}

	return len(b), nil
}
```

Concurrency
-----------

### Goroutines

Go provides concurrency in the form of _goroutines_. A goroutine is a lightweight thread managed by the Go runtime.

This starts a goroutine running `f(x, y)`:

```go
go f(x, y)
```

Goroutines share the same memory space as the rest of your program. How do you safely manage state when using goroutines?

### Channels

Channels are a type conduit you can use to send and receive values to and from goroutines. In this way, concurrent processes can _share messages about state_, rather than share state itself.

```go
ch := make(chan int)
ch <- v // send value `v` to channel `ch`
v := <-ch // receive from `ch`, and assign to `v`.
```

By default, sends and receives block until the other side is ready. This obviates the need for an explicit lock.

Here's a concrete example that sums the numbers in slice, distributing the work between two goroutines.

```go
package main

import "fmt"

func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum // send sum to c
}

func main() {
	s := []int{7, 2, 8, -9, 4, 0}

	c := make(chan int)
	go sum(s[:len(s)/2], c)
	go sum(s[len(s)/2:], c)
	x, y := <-c, <-c // receive from c

	fmt.Println(x, y, x+y)
}
```

Channels can optionally be _buffered_. Sends to a buffered channel block when the buffer is full, receives block when the buffer is empty.

```go
// Creates a channel with a buffer size of 100
ch := make(chan int, 100)
```

### Closing channels

Senders may optionally close a channel. This indicates when no more values will be sent. Receivers can test whether a channel has closed by assigning a second parameter to what is received by a channel:

```go
v, ok := <-ch
```

In this case, `ok` will be `false` if the channel is closed. Note that only _senders_ can close a channel, not recievers. Sending on a closed channel will cause a panic.

Here's a concrete example that calculates a fibonacci sequence and sends the result to a channel. We close the channel when the sequence is complete:

```go
package main

import (
	"fmt"
)

func fibonacci(n int, c chan int) {
	x, y := 0, 1
	for i := 0; i < n; i++ {
		c <- x
		x, y = y, x+y
	}
	close(c)
}

func main() {
	c := make(chan int, 10)
	go fibonacci(cap(c), c) // `cap` returns the buffer size of the channel, so here, we are calculating the first 10 fibonacci values.
	for i := range c {
		fmt.Println(i)
	}
}
```

### Select

The `select` statement allows a gouroutine to handle multiple communication operations. The `select` blocks until one of its cases can run (i.e. it receives a value, or is ready to send a value), then it executes that case. It executes in random order if multiple cases are ready.

```go
package main

import "fmt"

func fibonacci(c, quit chan int) {
	x, y := 0, 1
	for {
		select {
		case c <- x: // send `x` to the `c` channel. We can do this immediately!
			x, y = y, x+y
		case <-quit: // as soon as a value is sent to the `quit` channel, the function executes this `case`, terminating the goroutine.
			fmt.Println("quit")
			return
		}
	}
}

func main() {
	c := make(chan int)
	quit := make(chan int)
	go func() {
		for i := 0; i < 10; i++ {
			fmt.Println(<-c)
		}
		quit <- 0 // Kill the goroutine!
	}()
	fibonacci(c, quit)
}
```

The `default` case in a `select` block is run if no other case is ready:

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	tick := time.Tick(100 * time.Millisecond) // Channel that "ticks" every 100 ms
	boom := time.After(500 * time.Millisecond) // Channel that ticks once after 500 ms
	for {
		select {
		case <-tick:
			fmt.Println("tick.")
		case <-boom:
			fmt.Println("BOOM!")
			return
		default: // If neither of the `tick` nor `boom` receive a message, we fall back to the default case.
			fmt.Println("    .")
			time.Sleep(50 * time.Millisecond)
		}
	}
}
```

Go Project Conventions
----------------------

Unlike formatting or language conventions, Go doesn't have strong opinions about project structure. There are a few rules that _must_ be followed:

* Package names must match the name of the directory in which they are found. So if you named a package `example`, the file would have to be found in a folder named `/example`.
* The only exception to this run is the `main` package, which doesn't have to be in a `/main` directory. The `main` package is typically the entry-point to the application.

Aside from that, you can structure your project directories however you want. If it's a really simple project, you could also just have everything in the same flat directory. Having said that, here's a set of conventions that are commonly used:

* `/cmd`: main applications for the project. Your `main` package would go here. The directory name for each application should match the name of the executable you want to have (e.g., `/cmd/myapp`). It’s common to have a small main function that imports and invokes the code from the `/pkg` directory and nothing else.
* `/pkg`: the bulk of your code goes here. It should be organized in directories that match the `package` name for each file.
* `/vendor`: application dependencies if you use `godep` to manage them. Not sure how common this actually is, though.
* Tests are in files named `*_test.go`, where `*` is the name of the file under test. Run `go test` to run these tests.

Debugging with `go-delve`
-------------------------

[Delve](https://github.com/go-delve/delve) is a very useful debugger for Go. After you install it, you can attach it to a running process with this command:

```
dlv attach <pid> <path to binary>
```

You'll need to know both the PID for the program you're debugging and the path to its executable binary.

Once you're in debug mode, you can run `help` to see a list of commands, but here's a quick cheatsheet.

Create a breakpoint in a file at line `123`:

```
break path/to/file:123
```

Then run `continue` or `c` to pick up the breakpoint when your program executes.

Once you're at a break point, you can list all local variables with `locals`. Dig into the contents of a variable with `print <variable>`.

`continue` when you're done with a breakpoint, or just `exit`.
