MODERN JAVASCRIPT
=================

Up to date as of the summer of 2017 – who knows when the language will get a totally new spec!


JAVASCRIPT THE LANGUAGE
-----------------------

Based on of this tutorial: https://developer.mozilla.org/en-US/docs/Web/JavaScript/A_re-introduction_to_JavaScript

Javascript has had three major revisions:
* ECMAScript 3 (ES3) in 1999
* ES4 shat the bed and was never released
* ES5 in 2009
* ES6 in 2015

The language has changed quite a bit as of ES6!

STRINGS
-------

All strings are sequences of unicode characters.

Strings are like objects and have their own properties and methods:

```
'hello'.length // 5

'hello'.replace('h', 'j') // 'jello'

'hello'.toUpperCase() // 'HELLO'
```

VARIABLES
---------

In ES6 variables are declared using `let`, `const`, or `var`.

1. `let` allows you to declare block-level variables. It is in scope within the block it is declared.
Note that once a variable is declared using `let`, it _cannot_ be redeclared within that scope!
However, it _can_ be updated.

```javascript
let me = "John"

// This is fine:
me = "John Olmsted"

// This is bad:
let me = "Toby"
SyntaxError: Identifier 'me' has already been declared 
```

2. `const` also allows you to declare a block-level variable. However, it is completely immutable.
Like a variable declared by `let`, it cannot be redeclared, but it also _cannot_ be updated.

```javascript
const zero = 0

// This is bad:
zero = 1
TypeError: Assignment to constant variable.

// This is also bad:
const zero = 0
SyntaxError: Identifier 'zero' has already been declared 
``` 

3. `var` is the the traditional way to declare a variable. `var`s have _function_ level scope, not block
scope. They can also be freely redeclared and updated.

OPERATORS
---------

The usual arithmetic operators:

```javascript
2 + 2 // 4
2 - 2 // 0
2 * 2 // 4
2 / 2 // 1
2 % 2 // 0
```

Incrementers and decrementers:

```javascript
1++ // 1
1-- // 0
```

String concatenation:

```javascript
'hello' + 'world' // 'hello world'
```

Comparators:

```javascript
1 > 2 // false
1 < 2 // true
1 <= 2 // true
1 >= 2 // false

2 == 2 // true
2 == '2' // true! == coerces types.
2 === '2' // false, === does not coerce types.
```

CONTROL FLOW
------------

```javascript
let name = 'John'

if (name == 'John') {
  return name + ' Olmsted'
} else if (name == 'Barack') {
  return name + ' Obama'
else {
  return name
}

for (var i = 0; i < 5; i++) {
  // really you should just use 'map' though.
}

for (let value of array) {
  // do something with value, but really you should just use 'map'.
}

for (let property in object) {
  // do something with object property.
}
```

OBJECTS
-------

Javascript objects can be thought of as simple collections of key-value pairs.
Everything except the core data types are objects (yes, even functions are objects).

```javascript
var obj = new Object();

// or alternatively the object literal syntax:

var obj = {};

// Object literal syntax allows you to initialize the object in its entirety:
var me = {
  name: 'John',
  age: 30,
  address: {
    state: "CA",
    zip: 94703
  }
}

me.name // 'John'
me.address.zip // 94703
```

CLASSES
-------

Classes provide syntactic suger over Javascript's existing prototype-based inheritance. 

A Javascript class is just a function that returns an object based on a defined prototype.

```javascript
class Rectangle {
  constructor(height, width) {
    this.height = height
    this.width = width
  }

  area() {
    return this.height * this.width
  }
}

const mySquare = new Rectangle(10, 10)

mySquare.area // 100
```

FUNCTIONS
---------

```javascript
// Defining a basic function:
function add(x, y) {
  return x + y
}

// Splat arguments ("rest paramater operator"):
function average(...nums) {
  return nums.reduce((a, b) => a + b) / nums.length
}

average(1, 2, 3, 4) // 2.5

// Anonymous functions:
var add = function(x, y) {
  return x, y
}

// "Fat arrow" notation is more succinct, and allows implicit `return`s:
var add = (x, y) => x + y
```


2. JAVASCRIPT TOOLING
----------------------

This is largely based of this tutorial: https://github.com/verekia/js-stack-from-scratch

See `dev/js-scratchpad` for code based off this tutorial.


NPM AND YARN
------------

NPM is the default package manager for Node.

Yarn is a superset of NPM and is currently preferred as a package manager.

```javascript
yarn add <some package>

yarn remove <some package>

yarn add --dev <some dev package>
```

PACKAGE.JSON
------------

Both NPM and Yarn use a `package.json` configuration file. Yarn also generates a lock file, `yarn.lock`.

You can define common project tasks in `package.json` like this:

```javascript
"scripts": {
  "start": "babel-node src",
  "test": "estlint src && other-stuff"
}
```

BABEL
-----

Babel is a compiler that transforms ES6 code into ES5 code. It is a necessary evil because
not all browsers and JS environments have full support for ES6 yet.

To install it: 

```javascript
yarn add --dev babel
```

```javascript
babel <some file> # compiles file from ES6 to ES5.

babel-node <some file> # runtime environment for ES6 files.
```

`.babelrc` is a config file for Babel.

ES6 CLASSES
-----------

ES6 introduced real classes to javascript:

```javascript
class Dog {
  constructor(name) {
    this.name = name
  }

  bark() {
    return `woof woof, I am ${this.name}`
  }
}

module.exports = Dog  // This exposes the class to the outside world.
```

To use this class in another JS file (assuming it's in the same directory):

```javascript
const Dog = require('./dog')  // This is why you needed 'module.exports' in dog.js

const toby = new Dog('Toby')

console.log(toby.bark())
```

ES6 MODULES SYNTAX
------------------

ES6 introduces a newer sytax for exporting and importing modules.

In `dog.js`, update the 'module.exports' to this:

```javascript
export default Dog
```

Then in the JS file that needs Dogs:

```javascript
import Dog from './dog'
```

ESLINT
------

ESLint is a code linter for ES6. `.eslintrc.json` is the configuration file for your linting rules.

To install it:

```javascript
yarn add --dev eslint
```

WEBPACK
-------

Webpack is a 'module bundler' – it takes a group of JS files, concatenates and compresses them, and assembles them
into one JS file usually called a 'bundle'.

REACT
-----

React is a library for building user interfaces. It uses the JSX syntax to represent HTML elements and components.
It makes it easy to combine the behavior (i.e. javascript associated with) HTML elements with the actual HTML itself.

REDUX
-----

Redux is a library to handle the lifecycle of your application. It creates a _store_, which is the single source of
truth for the state of your application at a given time.

REACT-REDUX
-----------

React-Redux connects a redux store with React components. with `react-redux`, when the Redux store changes, React
components get automatically updated. They can also fire Redux actions.

_Components_ are dumb React components, in the sense that they don't know anything about the Redux state.

_Containers_ are smart components that know about the Redux state and communicate that to nested dumb components.


