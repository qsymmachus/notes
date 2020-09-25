Rust
====

Rust is a statically typed, multi-paradigm programming language focusing on safety, speed, and concurrency. It guarantees memory safety without using garbage collection.

The initial version of these notes has been cribed from [Rust by Example](https://doc.rust-lang.org/stable/rust-by-example/index.html)

Hello, world
------------

Here's "hello world" in Rust, the binary executes whatever is in the `main` function:

```rust
fun main() {
  println!("Hello World!");
}
```

`rustc` will compile a binary that you can execute:

```
rustc hello.rs
./hello
Hello World!
```

Formatted print
---------------

Printing is handled by a series of marcros defined in `std::fmt`, including:

* `format!`: write formatted text to String
* `print!`: same as format! but the text is printed to the console (io::stdout).
* `println!`: same as print! but a newline is appended.
* `eprint!`: same as format! but the text is printed to the standard error (io::stderr).
* `eprintln!`: same as eprint!but a newline is appended.

Rust checks formatting correctness at compile time, which is handy.

```rust
fn main() {
  // In general, '{}' will be replace by stringified arguments.
  println!("{} days", 31);

  // You can use positional arguments, or even named arguments.
  println("{0}, this is {1}.", "Alice", "Bob");
  println("{you}, this is {me}.", you="Alice", me="Bob");
}
```

`std::fmt` contains __traits__ that govern the display of text. The important ones are:

* `fmt::Debug`: Uses the `{:?}` marker. Format text for debugging purposes.
* `fmt::Display`: Uses the `{}` marker. Format text in a more elegant, user friendly fashion.

In all the examples above, use used `fmt::Display` because the standard library implements this trait for all the basic types. To print _custom_ types, you must write your own implementation.

### Custom `fmt::Display` implementations

Say we have a custom type we want to display nicely. We need to write our own implementation of `fmt::Display`:

```rust
use std::fmt;

// Our custom type:
struct MinMax(i64, i64)

// Our implementation of the `fmt::Display` trait:
impl fmt::Display for MinMax {
  fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
    // Write the first element to the supplied output stream `f`:
    write!(f, "(min: {}, max: {})", self.0, self.1)
  }
}
```

Primitives
----------

### Scalar types

* signed integers: `i8`, `i16`, `i32`, `i64`, `i128`, `isize`
* unsigned integers: `u8`, `u16`, `u32`, `u64`, `u128`, `usize`
* floating point: `f32`, `f64`
* `char` unicode scalar values 
* `bool` either `true` or `false`
* the unit type `()`

### Compound types

* arrays like `[1, 2 , 3]`
* tuples like `(1, true)`

Variables
---------

Variables can be type annotated, or type can be inferred. Variables are immutable by default, but can be made mutable.

```rust
fn main() {
  let my_bool: bool = true;
  let another_bool = false;

  let immutable = 5; // Integers are i32 by default

  let mut mutable = 6;
  mutable = 21;
}
```

Tuples
------

A tuple is a collection of values of different types. Tuples are typed with a signature `(A, B, ...)` where `A` and `B` are the types of its members.

You can extract values from a tuple using indexing:

```rust
let my_tuple = (1, 2 ,3);
println!("first value: {}", my_tuple.0);
println!("second value: {}", my_tuple.1);
```

Tuples are often used as return values for functions, so they can return multiple values:

```rust
fn swap(pair: (i32, bool)) -> (bool, i32) {
  // You can destructure a tuple using `let`:
  let (integer, boolean) = pair;

  (boolean, integer)
}
```

Arrays and Slices
-----------------

An array is a collection of objects of the same type `T`, and their size is also defined at compile time as part of their type signature `[T; size]`.

Slices are similar to arrays, but their size is not known at compile time. A slice is a two-word object: the first word is a pointer to the data, and the second word is the length of the slice. Slices can be used to "borrow" a section of an array, and have the type signature `&[T]`.

```rust
fn main() {
  // Fixed size array
  let nums: [i32; 5] = [1, 2, 3, 4, 5];

  // With this neat trick you can initialize all elements with the same value:
  let lots_of_fives: [i32; 100] = [0; 500];

  // `len` returns the size of the array:
  println!("array size: {}", nums.len());

  // Arrays can be borrowed as slices:
  let nums_slice: [&i32] = &nums;

  // You can borrow a section of an array instead.
  // If you're borrowing [x .. y], `x` is the first index inclusive,
  // `y` is the last index exclusive. So this is gonna be [2, 3, 4]:
  let sliced_section = &nums[1 .. 4]
}
```

