Rust
====

Rust is a statically typed, multi-paradigm programming language focusing on safety, speed, and concurrency. It guarantees memory safety without using garbage collection.

The initial version of these notes has been cribed from [Rust by Example](https://doc.rust-lang.org/stable/rust-by-example/index.html).

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

Structs
-------

### Unit structs

These structs have no fields at all, and are useful for generics, or as `enum` types.

```rust
struct MyType;
```

### Tuple structs

A tuple struct is just a named tuple.

```rust
struct MinMax(i32, i32);
```

### Ordinary structs

Similar to C structs or Go structs, these structure data with named fields.

```rust
struct Point {
  x: f32,
  y: f32,
}

// Nested struct:
struct Rectangle {
  top_left: Point,
  bottom_right: Point,
}

fn main() {
  // Instantiate a struct:
  let point = Point { x: 10.3, y: 0.4 };

  // You can make new point using 'struct update' syntax to copy all but the overidden fields:
  let new_point = Point { x: 2.7, ..point };

  // You can destructure a struct with `let`:
  let Point { x: gimme_this, y: gimme_that } = new_point;
  println!("x: {} y: {}", gimme_this, gimme_that);
}
```

Enums
-----

These are great for defining sum types, and you can pattern match on them!

```rust
enum Animal {
  // 'Unit' struct types
  Cat,
  Dog,
  // Enum types can be structured too:
  CustomAnimal(String),
  Human(name: String),
}

// Enums are great for pattern matching!
fn speak(animal: Animal) {
  match animal {
    Animal::Cat => println!("meow"),
    Animal::Dog => println!("woof!"),
    Animal::Custom(sound) => println!(sound),
    Animal::Human { name } => println!("Hello, my name is {}", name)
  }
}
```

If an enum's name is too long or needs to be disambiguated, you can rename it with a __type alias__:

```rust
enum VeryVerboseEnumOfThingsToDoWithNumbers {
  Add,
  Subtract,
}

// Creates a type alias
type Operations = VeryVerboseEnumOfThingsToDoWithNumbers;

fn main() {
  let x = Operations::Add;
}
```

### Defining sum types and methods

Rust enums are great for defining sum types. Here's an example definition of a linked list:

```rust
use crate::List::*;

enum List {
  // 'Box' wraps a pointer to the next item in the list.
  Cons(u32, Box<List>),
  Nil,
}

// You can attach methods to an enum with 'impl'
impl List {
  fn new() -> List {
    Nil
  }

  fn prepend(self, elem: u32) -> List {
    Cons(elem, Box::new(self))
  }

  // A recursive `len` function.
  fn len(&self) -> u32 {
    match *self {
      // You can't take ownership of the tail because 'self' is borrowed. Instead you take a reference to the tail:
      Cons(_, ref tail) => 1 + tail.len(),
      Nil => 0
    }
  }
}

fn main() {
  let mut list = List::new();
  println!("list length: {}", list.len());
}
```

Type casting & conversion
-------------------------

### Casting primitive types

Explicit type conversion (casting) can be performed using the `as` keyword.

```rust
let decimal = 3.1459
let integer = decimal as u8
```

### Conversion with `From` and `Into`

For non-primitive custom types (like structs and enums), Rust allows type conversion using the `From` and `Into` traits.

The `From` trait allows a type to define how to create itself from another type.

Many of these are defined in the standard library already:

```rust
let my_str = "hello";
let my_string = String::from(my_str);
```

For custom types, you can define your own implementation of `From`:

```rust
use std::convert::From;

#[derive(Debug)]
struct Number{
  value: i32,
}

// Note that `From` takes a type parameter:
impl From<i32> for Number {
  fn from(item: i32) -> self {
    Number { value: item }
  }
}
```

The reciprocal form of `From` is `Into`. You get this for free when you define an implementation of `From`:

```rust
fn main() {
  let int = 5;
  let num: Number = int.into();
  
  println!("My number is {:?}", num);
}
```

### String conversion

Converting a type into a string can be down by implementing the `ToString` trait for the type. But it's easier to just implement `fmt::Display`, since that generates `ToString` for you automagically.

```rust
use std::fmt;

struct Circle {
  radius: i32
}

impl fmt::Display for Circle {
  fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
    write!(f, "Circle of radius {}", self.radius)
  }
}

fn main() {
  let circle = Circle { radius: 6 };
  println!("{}", circle.to_string());
}
```

Control Flow
------------

### Conditionals

In Rust `if / else` are expressions, not statements, which is pretty cool. This means each branch must return the same type.

```rust
fn describe(n: i32) {
  if n < 0 {
    println!("{} is less than zero", n);
  } else if n > 0 {
    println!("{} is greater than zero", n);
  } else {
    println!("{} is zero", n);
  }
}
```

### Simple loops

The `loop` keyword starts an infinite loop, which you can break with `break`. You can skip an iteration with `continue`.

If you put an expression after `break` it will return that value.

```rust
fn main() {
  let mut count = 100;

  loop {
    if count == 0 {
      break;
    }

    println!("{} bottles of beer on the wall", count)

    count -= 1;
  }
}
```

The `while` keyword word works exactly as you'd expect.

### `for` and `range`

You can iterate over an `Iterator` using the `for in` loop. 

An easy way to create an iterator is with the range notation `a..b`:

```rust
fn main() {
  // Range notation is _exclusive_ of the final value, so this stops at 101.
  for n in 1..102 {
    if n == 1 {
      println!("{} dalmatian", n)
    } else {
     println!("{} dalmatians", n)
    }
  }
}
```

Collections can be converted into iterators using one of three methods:

* `iter()` borrows each element of the collection, leaving the original collection untouched.
* `into_iter()` consumes the collection so it is no longer available for use outside the loop.
* `iter_mut()` borrows each element but allows you to mutate it so you can modify the collection in place.

Pattern matching
----------------

Rust provides robust pattern matching. `match` is an expression.

Matching on __value__:

```rust
fn describe(n: i32) {
  match n {
    1 => println!("This is one"),
    // Matching against several values:
    2 | 3 | 5 | 7 | 11 => println!("This number is prime"),
    // Matching against in inclusive range:
    11..=19 => println!("It's a teen"),
    // Handles all other cases:
    _ => println!("It's nothing special"),
  }
}
```

Matching on __type__, and __destructuring__:

```rust
fn speak(animal: Animal) {
  match animal {
    Animal::Cat => println!("meow"),
    Animal::Dog => println!("woof!"),
    Animal::Custom(sound) => println!(sound),
    Animal::Human { name } => println!("Hello, my name is {}", name)
  }
}
```

Pattern matching is __exhaustive__, so you need handling for all possible types or values.

### Guards

Match __guards__ can be added to filter based on conditionals:

```rust
fn describe(num: i32) {
  match num {
    n if n == 0 => println!("It's zero"),
    n if isEven(n) => println!("It's even"),
    _ => println!("It's odd"),
  }
}

fn isEven(num: i32) -> bool {
  n % 2 == 0
}
```

Functions
---------

Functions are declared using the `fn` keyword. Its arguments and return values are type annotated as part of the function signature.

The final expression of the function will be used as the return value. Alternatively, you can explicitly `return`.

```rust
fn double(n: i32) -> i32 {
  // Implicit returns are cool
  2 * n
}
```

### Methods

Methods are functions attached to objects. Methods have access to the data of the object and its other methods using the `self` keyword.

Methods are defined under an `impl` block:

```rust
struct Rectangle {
  width: i32,
  height: i32,
}

impl Rectangle {
  fn area(&self) -> i32 {
    self.width * self.height
  }
}
```

### Closures

Closures, also called lambdas, are anonymous functions that capture the enclosing environment.


```rust
fn main() {
  let closure = |i: 32| -> i32 { i + 1 };

  println!("closure returns: {}", closure(6)) // 7
}
```

Closures can capture variables:

* By __reference__: `&T`, annotated with the trait `Fn`
* By __mutable reference__: `&mut T`, annotated with the trait `FnMut`
* By __value__: `T`, annotated with the trait `FnOnce`

Higher order functions
----------------------

Rust functions are first-class and can be both the arguments and the return values of other functions.

A function that takes another function as an argument:

```rust
// Rolling our own, type-parameterized implementation of `map`
fn map<A, B>(list: Vec<A>, f: fn(&A) -> B) -> Vec<B> {
  let mut new_list: Vec<B> = Vec::new();

  for elem in list.iter() {
    new_list.push(f(elem));
  }

  return new_list;
}

fn main() {
  let list = vec![1, 2, 3, 5];

  let new_list = map(list, |n: &i32| -> i32 {
    n * 2
  });

  println!("{:?}", new_list);
}
```

A function that returns another function:

```rust
// Note the use of the `Fn` trait to indicate the returned closure captures by reference:
fn add_n(n: i32) -> impl Fn(i32) -> i32 {
  // Technically, we're returning a closure here.
  // Variable `n` needs to be `move`d into the closure's scope:
  return move |m| -> i32 { n + m };
}

fn main() {
  let add_10 = add_n(10); // 10 is captured by the closure
  println!("{}", add_10(5)) // 15
}
```

### Built-in higher order functions

Rust lends itself well to a functional style and has a lot of built-in higher order functions you're familisar with, like `map`, `reduce`, and so on.

[Iterator](https://doc.rust-lang.org/core/iter/trait.Iterator.html) and [Option](https://doc.rust-lang.org/core/option/enum.Option.html) both implement many HOFs.

Modules
-------

A module is a collection of logically related code, with managed visibility (public/private) of functionality. Package, module, library, whatever you want to call it!

By default items in a module are private, but they can be made public with the `pub` keyword.

```rust
mod my_mod {
  fn private_function() {
    println!("called `my_mod::private_function()`");
  }

   pub fn public_function() {
    println!("called `my_mod::public_function()`");
  }

  // Modules can be nested:
  pub mod nested {
    pub fn nested_public_function() {
      println!("called `my_mod::nested::nested_public_function()`")
    }
  }
}
```

Structs declared within modules have private fields unless they are explicity made public:

```rust
mod my_structs {
  pub struct Stuff<T> {
    pub contents: T,
    private_contents: T, // This field is private
  }
}
```

The `use` declaration can import a full path to a new name for easier access. You can also alias imports:

```rust
use crate::deeply::nested::{
  my_first_function,
  my_second_function,
  AndATraitType
};

// Import aliasing
use some::crate::really_long_ass_name as shorter_name;

fn main() {
  my_first_function();
}
```

### Splitting modules into separate files

Modules can be mapped to a file/directory hierarchy. Assume you have the following file structure:

```
.
|-- my
|   |-- mod.rs
|   `-- indirect.rs
`-- split.rs
```

In `split.rs`:

```rust
//This declaration looks for a file named `my.rs`, or `my/mod.rs` and inserts its contents inside a module named
// `my` in this scope:
mod my;

fn main() {
  // The `function()` definite in `my.rs` is treated like part of a `my` module:
  my::function();

  // Since this file imports `my`, and `my/mod.rs` imports `indirect.rs`, it's treated as a nested module:
  my::indirect::function();
}
```

In `my/mod.rs`:

```rust
// This is imported from `indirect.rs` in the same directory:
pub mod indirect;

pub fn function() {
  println!("Howdy!");
}
```

Crates
-------

A __crate__ is a compilation unit in Rust.

Whenever you compile a Rust file with `rustc some_file.rs`, `some_file.rs` is treated as a __crate file__.

A create can be compiled into a binary or into a library. By default, `rustc` will compile binaries, but you can create libraries using the `--crate-type=lib` flag.

Say you write the following crate file, `my_crate.rs`:

```rust
pub fn public_function() {
    println!("Hello!");
}

fn private_function() {
    println!("You're not supposed to be here.");
}
```

Compile it into a library:

```
$ rustc --crate-type=lib my_crate.rs
```

To link another crate to this new library, use the `extern crate` declaration. By default it looks for libraries in the same directory.

```rust
extern crate my_crate;

fn main() {
  my_rate::public_function();
}
```

Cargo
-----

[Cargo](https://doc.rust-lang.org/cargo/) is Rust's official package manager. Cargo can be used for:

* Dependency management
* Generating new project boilerplate
* Running unit tests and benchmarks

To create a new Rust project:

```
$ cargo new foo
```

This generates a package directory with the following structure:

```
foo
├── Cargo.toml
└── src
    └── main.rs
```

* `main.rs` is the root source file of your project.
* `Cargo.toml` is the config file for Cargo. It looks like this:


```toml
[package]
name = "foo"
version = "0.1.0"
authors = ["john"]

[dependencies]
```

### Dependency management

You can add project dependencies in one of three ways:

```toml
[dependencies]
clap = "2.27.1" # from crates.io
rand = { git = "https://github.com/rust-lang-nursery/rand" } # from online repo
bar = { path = "../bar" } # from a path in the local filesystem
```

### Builds

`cargo build` will build the project.

`cargo run` builds and runs the project in one command.

### Testing

By convention tests go in their own `tests` directory:

```
foo
├── Cargo.toml
├── src
│   └── main.rs
└── tests
    ├── my_test.rs
    └── my_other_test.rs
```

`cargo test` will run all your tests.

Generics
--------

### Type parameters

Type parameters allow you to parameterize functions and type definitions by type. They're surrounded by angle brackets and written in upper camel case, `<LikeThis>`.

```rust
// A tuple struct with type parameter `T`:
struct MyBox<T>(T);

// A function with a type parameter:
fn return_it<T>(it: T) -> T {
  it
}

fn main() {
  let my_box: MyBox<char> = MyBox('a'); // Explicit type parameter
  let another_box = MyBox(1); // Implicit type parameter

  println!("{}", return_it::<char>('a')); // Note the ::<T> syntax when explicit
  println!("{}", return_it(1)); // Ordinary syntax when implicit
}
```

### Bounds

Type parameters can use traits as __bounds__ that stipulate what functionlity a type must implement.

For example, we can bound this type `T` so it must implement `Display`:

```rust
// The compiler will complain if we use a type parameter that can't `Display`:
fn printer<T: Display>(t: T) {
  println!("{}", t);
}
```

You can specify multiple bounds by separating them with a `+`:

```rust
fn compare_prints<T: Debug + Display>(t: &T) {
  println!("Debug: `{:?}`", t);
  println!("Display: `{}`", t);
}
```

### Where clauses

A bound can also be expressed using a `where` clause, which may be clearer to read. It's often used when bounding `impl` blocks:

```rust
impl <A, D> MyTrait<A, D> for YourType where
  A: TraitB + TraitC,
  D: TraitE + TraitF {
    // Methods for `YourType`, bounded by the `where` clause above.
  }
```

Traits
------

A trait is a collection of methods that defines an interface for an unknown type, `Self`. 

Traits can be implemented by any other data type.

```rust
struct Sheep { name: &'static str }

// Defining an `Animal` trait (interface):
trait Animal {
  // Static method signature; `Self` refers to the implementor type.
  fn new(name: &'static str) -> Self;

  // Instance method signatures; these will return a string.
  fn name(&self) -> &'static str;
  fn noise(&self) -> &'static str;

  // Traits can provide default method definitions.
  fn talk(&self) {
      println!("{} says {}", self.name(), self.noise());
  }
}

// Sheep's implementation of the `Animal` interface:
impl Animal for Sheep {
  // `Self` is the implementor type: `Sheep`.
  fn new(name: &'static str) -> Sheep {
      Sheep { name: name }
  }

  fn name(&self) -> &'static str {
      self.name
  }

  fn noise(&self) -> &'static str {
    "baaaaaa!"
  }
  
  // Default trait methods can be overridden.
  fn talk(&self) {
    println!("{} pauses briefly... {}", self.name, self.noise());
  }
}
```

### Derive

The compiler can generate basic implementations of some traits for you using the `#[derive]` attribute. The following traits are derivable:

* Comparison traits: `Eq`, `PartialEq`, `Ord`, `PartialOrd`.
* `Clone`, to create `T` from `&T` via a copy.
* `Copy`, to give a type 'copy semantics' instead of 'move semantics'.
* `Hash`, to compute a hash from `&T`.
* `Default`, to create an empty instance of a data type.
* `Debug`, to format a value using the `{:?}` formatter.

```rust
// `Centimeters`, a tuple struct that can be compared using derived traits:
#[derive(PartialEq, PartialOrd)]
struct Centimeters(i32);

fn main() {
  let long = Centimeters(100);
  let short = Centimeters(5);

  if long > short {
    println!("Yep, it is longer!");
  }
}
```

### Returning traits with a `Box`

The Rust compiler needs to know how much space every function's return type requires. This means your functions can't return a trait, because the compiler can't guess the size of concrete types that implement that trait.

To work around this limitation, you can return `Box` that contains a trait. A `Box` is a reference to memory in the heap, and has a fixed size, so the compiler accepts it as a return type.

```rust
// Returns some struct that implements Animal, but we don't know which one at compile time.
fn random_animal(random_number: f64) -> Box<dyn Animal> {
  if random_number < 0.5 {
      Box::new(Sheep {})
  } else {
      Box::new(Cow {})
  }
}
```

### Supertraits

Rust doesn't have a concept of inheritance, but you can define a trait as a superset of another trait:

```rust
trait Person {
  fn name(&self) -> String;
}

// Person is a supertrait of Student.
// Implementing Student requires you to also impl Person.
trait Student: Person {
  fn university(&self) -> String;
}
```

### Some common traits to know

* `Display` and `Debug` were covered in our section on formatting. They can be derived.
* [`Iterator`](https://doc.rust-lang.org/core/iter/trait.Iterator.html), which only requires you to implement the method `next`.
* [`Clone`](https://doc.rust-lang.org/std/clone/trait.Clone.html) allows you to copy a resource to a new variable, without destroying the copied variable. It can be derived.

Macros
------

Rust allows you to metaprogram using macros. Macros look like functions, but always end with a `!`, and instead of generating a function call, they expand into source code that is plopped into your program inline.

Macros are created using the `macro_rules!` macro:

```rust
macro_rules! say_hello {
  // `()` means the macro takes no argument:
  () => {
    println!("Hello!");
  };
}

fn main() {
  say_hello!()
}
```

Error Handling
--------------

Rust has a few different ways to handle errors:

* `panic!`, useful for unrecoverable errors.
* `Option` type for handling optional values.
* `Result` type for handling tasks that may fail.

### Panic!

`panic!` prints an error message and exits the entire program. It goes without saying you shouldn't do this unless there is really no way to recover.

```rust
fn main() {
  panic!("AAAAAAAHHHHHH!!!!!");
}
```

### `Option` type

The `Option` type is an enum, very similier to Scala's `Option` type.

`Option<T>` has two possible values, `Some(T)` or `None`. You can pattern match over this:

```rust
fn give_gift(gift: Option<&str>) {
  match gift {
    Some("snake") => println!("AAAAAHHHH!!!!"),
    Some(other) => println!("What a nice {}!", other),
    None => println!("No gift for me?"),
  }
}
```

In Rust it's common to "unwrap" an option using the `?` operator. If the Option is `Some(T)`, `?` will return that value `T`, otherwise it terminates whatever function is running and returns `None`.

```rust
fn next_birthday(current_age: Option<u8>) -> Option<String> {
  // If `current_age` is `None`, this short circuits and returns `None`.
  // If `current_age` is `Some`, the inner `u8` gets assigned to `next_age`
  let next_age: u8 = current_age?;
  Some(format!("Next year I will be {}", next_age))
}
```

But why the hell would you do that when you can __map__ over options?

```rust
let some_number = Some(123);

let some_length = some_number
  .map(|num| num.to_string())
  .map(|s| s.len());
```

You can __flat map__ too if you're mapping over a function that returns `Option<Option<T>>`. For whatever reason though it's not called flat map in Rust, it's `and_then`.

### `Result` type

Results are just like options except they describe a possible _error_ instead of possible _absence_.

A `Result<T, E>` is either an `Ok(T)` or an `Err(E)`

You can pattern match on the type:

```rust
fn print(result: Result<i32, ParseIntError>) {
  match result {
      Ok(n)  => println!("n is {}", n),
      Err(e) => println!("Error: {}", e),
  }
}
```

You can also use the `?` operator, which unwraps `T` if the result is `Ok(T)`, or short circuits and immediately returns the error.

Like options, you can `map` and `and_then` over a result:

```rust
fn multiply(first_number_str: &str, second_number_str: &str) -> Result<i32, ParseIntError> {
  first_number_str.parse::<i32>().and_then(|first_number| {
      second_number_str.parse::<i32>().map(|second_number| first_number * second_number)
  })
}
```

It's common to __alias__ results with specific type signatures if you're using a particular result type repeatedly:

```rust
// Define a generic alias for a `Result` with the error type `ParseIntError`.
type ParseResult<T> = Result<T, ParseIntError>;
```

#### Returning a `Result` from `main()`

The `main` function may optionally return a `Result`, if specified:

```rust
use std::num::ParseIntError;

fn main() -> Result<(), ParseIntError> {
  let number_str = "10";
  let number = match number_str.parse::<i32>() {
      Ok(number)  => number,
      Err(e) => return Err(e),
  };

  println!("{}", number);
  Ok(())
}
```
