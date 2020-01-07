REACT
=====

Also see:

  * `javascript.txt`
  * `react-router.txt`
  * `redux.txt`

React is a library for building user interfaces in Javascript. It is _not_ a complete framework
for building web applications, it only handles the UI component. In conjunction with other libraries
like React Router and Redux, you can build complete web applications with React.

JSX
---

Here's some JSX:

```
const h1 = <h1>Hello world</h1>
```

JSX is a "syntax extension" (you can think of it as a DSL) for Javascript. It allows you to write
Javascript that looks nearly identical to HTML. JSX must be compiled into valid Javascript.

JSX is _nearly_ identical to HTML, and can have element attributes:

```
let link = <a href="https://olmsted.io>My Site</a>
```

JSX can be nested, and multi-lined. When writing multi-line JSX, it must be enclosed in parens:

```
let myDiv = (
  <div>
    <h1>
      Hello world
    </h1>
  </div>  
)
```

NB: a JSX expression must have only _one_ outer element.

```
let thisIsInvalid = (
  <p>Hi</p>
  <p>Hello</p>
)

let thisIsValid = (
  <div>
    <p>Hi</p>
    <p>Hello</p>
  </div>
)
```

JSX IS REALLY JUST A FUNCTION
-----------------------------

JSX is syntactic sugar for the function `React.createElement`:

```
<p color="blue" shadowSize={2}>
  Click Me
</p>


// compiles into

React.createElement(
  "p",
  {color: 'blue', shadowSize: 2},
  'Click Me'
)
```

JSX GOTCHAS
-----------

JSX is nearly identical to HTML, but with a few important differences. 

1. The `class` attribute can't be used in JSX because it's a reserved word in Javascript.
Instead, JSX uses `className`.

2. Self-closing tags like `<br />` and `<img />` _must_ have a final angle bracket (so no `<img>`).


REACT DOM
---------

ReactDOM allows you to actually render JSX within the DOM:

```
import React from 'react';
import ReactDOM from 'react-dom';

const hello = <h1>Hello world</h1>
const targetElement = document.getElementById('app')

ReactDOM.render(hello, targetElement)
```

One important thing to note is that `ReactDOM.render()` only updates DOM elements that have changed.
If you call it twice with the same JSX element, it does nothing. This provides an obvious performance
benefit and relies on React's use of the  _virtual DOM_.

In React, for every DOM object, there's a corresponding object in the virtual DOM. The virtual DOM is a
lightweight copy of the real DOM. Manipulating the virtual DOM is very cheap, while manipulating the real
DOM is very expensive.

When you render a JSX element, the entire virtual DOM is updated. As we said before, this is a cheap 
operation. The virtual DOM is diff'd with the real DOM, and if there is no difference, the real DOM
is left unchanged.

If there is a difference, the real DOM is updated, _but only the elements that have changed._

JAVASCRIPT IN JSX
-----------------

JSX is just Javascript at the end of the day, so you can interpolate Javascript expressions inside your JSX.
This is what makes JSX a useful templating language. To interpolate code in your JSX, wrap it in curly braces:

```
let h1 = <h1>{'John' + 'Olmsted'}</h1>

let name = 'John Olmsted'
let p = <p>{name}</p>
```

NB: you cannot inject `if` statements into JSX, because it is not an expression. Alternatively, you can
use a ternary conditional, which is an expression. See "Conditionals in JSX" below.

COLLECTIONS IN JSX
------------------

`map` is a great way to translate collections into JSX:

```
const foods = ['apple', 'orange', 'banana']

const foodList = (
  <ul>
    {foods.map(food => <li>{food}</li>}
  </ul>
)
```

When you make a list in JSX, sometimes you will need to include `key`s. A `key` is a special attribute that
React relies on to enforce ordering in lists. Not all lists need keys. Generally, you need keys when:

  1. The list items have some state that must persist from one render to another, like whether a todo item was "done".
  2. The list's order might be shuffled. For example, a list of search results.

It's easy to add `key`s using `map`:

```
const foodList = foods.map((food, i) => <li key={'food_' + i}>{food}</li>)
```

EVENT LISTENERS IN JSX
----------------------

Like HTML elements, JSX elements can have event listeners, like the `onClick` attribute.

```
let goose = 'https://upload.wikimedia.org/wikipedia/commons/e/e4/Canada_goose_flight_cropped_and_NR.jpg'

function honk(e) {
  e.target.setAttribute('src', 'https://example.com/honking_goose.jpg')
  console.log('HONK!')
}

let gooseImg = (
  <img
    src={gooseImg}
    onClick={honk} />
)
```

CONDITIONALS IN JSX
-------------------

We've noted before that you can't inject conditionals into JSX. There are a few ways to work around this.

1. One way is to place the condional _outside_ the JSX, and choose between two different JSX templates based
on some conditonal.

2. Use the ternary operator instead! The ternary operator is an expression, so it evaluates just fine in JSX.

```
let coin = <img src={coinToss() === 'heads' ? 'heads.jpg' : 'tails.jpg'} />
```

3. Use &&, which is also an expression, to determine whether JSX elements render at all:

```
const food = (
  <ul>
    { !baby && <li>Pizza</li> }
    { age > 15 && <li>Brussels Sprouts</li> }
    { age > 20 && <li>Oysters</li> }
    { age > 25 && <li>Grappa</li> }
  </ul>
)
```

REACT COMPONENTS
----------------

Components are the bread and butter of React applications. Components typically encapsulate:

  1. Some HTML to be rendered (in the form of JSX),
  2. Some behavior tied to that HTML (in the form of Javascript functions).

Here's very simple component:

```
import React from 'react'
import ReactDOM from 'react-dom'

class MyComponent extends React.Component {
  get name() {
    return "John"
  }

  render() {
    return <h1>Hello {this.name}!</h1>
  }
}

```

`render` is the only function that _must_ be declared in a component.

Once a component is defined, you can create a Component instance...in JSX!

```
// <MyComponentClass /> is JSX, but instead of rendering HTML, it renders your
// React Component!

ReactDOM.render(
  <MyComponentClass />,
  document.getElementById('app')
);
```

Components make it easy to combine behaviors, like event listeners, with the HTML elements they're
tied to:

```
import React from 'react'
import ReactDOM from 'react-dom'

class Button extends React.Component {
  scream() {
    alert('AAAAAAAAHHH!!!!!')
  }

  render() {
    return <button onClick={this.scream}>AAAAAH!</button>
  }
}
```

NESTING COMPONENTS
------------------

By itself, a component is not very useful. To build a full-fledged UI, you need to start
nesting components.

Say you have this component in one file:

```
import React from 'react'

export class Title extends React.Component {
  render() {
    return <h1>Welcome!</h1>
  }
}

You can import it and use it in this file:

```
import React from 'react'

import { Title } from `./NavBar.js'

class Homepage extends React.Component {
  render() {
    return (
      <div>
        <Title /> // Check it out, we're nesting a component instance here.
        <p>Hello and welcome to my website.</p>
      </div>
    )
  }
}
```

PROPS
-----

Every component has 'props'. A component's props is just an object that holds data relevant to that
component. props is a property inherited from `React.Component`, so within a component you can access
it with `this.props`.

When rendering a component, you can pass information into in the form of attributes:

```
<MyComponent name="John" age={30} pets={["fish", "snail"]} />
```

Attributes passed into components in this way are included in the `props` object! This props data can 
then be used in the component:

```
import React from 'react'

class MyComponent extends React.Component {
  get pets() {
    return this.props.pets.map(pet => <li>{pet}</li>)
  }

  render() {
    return (
      <div>
        <p>Name: {this.props.name}</p>
        <p>Age: {this.props.age}</p>
        <p>Pets:</p>
        <ul>
          {this.pets}
        </ul>
      </div>
    )
  }
}
```

The most common use of props is to pass information to a nested component from another, parent component.

Note that you can pass any Javascript expression as props, including booleans (for logic in your render
function), arrays, and even functions. When passing in props other than strings to a component, note that
they must be wrapped in curly brackets:

```
<Button onClick={() => alert('HEY!!')} />
```

NB: By convention, event handlers that are passed in as props are named `on<event>`, like `onClick` or
`onHover`. The event handler function is named `handle<event`>, like `handleClick`.


PROPS.CHILDREN
--------------

`prop`s has an element called `children`. `props.children` contains all child elements within a component's
opening and closing tags:

```
<MyComponent>
  // child elements may go here!
</MyComponent>
```
This allows you to do things like this:

```
import React from 'react';

export class List extends React.Component {
  render() {
    return (
      <div>
        <h1>{this.props.title}</h1>
        <ul>{this.props.children}</ul>
      </div>
    );
  }
}


// These '<li>' elements will be picked up in props.children!
<List>
  <li>Hello</li>
  <li>Hi</li>
</List>
```

DEFAULT PROPS
-------------

If a component uses props, there's no guarantee attributes will be passed in for those props at
render time. You can provide default props by creating a `defaultProps` property in your
component:

```
import React from 'react';

class Button extends React.Component {
  render() {
    return (
      <button>
        {this.props.text}
      </button>
    );
  }
}

Button.defaultProps = {text: 'I am a button'}
```

STATE
-----

A React component can access data in two ways: props and state.

Unlike props, a component's state is _not_ passed in from the outside. A component decides its own state.

To give a component state, we must assign a `state` property in the constructor:

```
import React from 'react'

class Example extends React.Component {
  // Note that since we're overriding the React.Component constructor, we must also manually
  // assign the 'props' dependency:
  constructor(props) {
    super(props)
    this.state = { name: 'John' }
  }

  render() {
    return <div></div>
  }
}
```

`this.setState(state)` is used to update a component's state, where the argument `state` is an object with the
updated state. Note that is updates based on a diff between the current state and the new state (it "merges").
Omitted properties are unchanged, and updated properties are updated.

Here's an example how you can make use of `setState`:

```
import React from 'react'

const green = '#39D1B4'
const yellow = '#FFD712'

class Toggle extends React.Component {
  constructor(props) {
    super(props)
    this.state = { color: green }
    // NB: you must bind changeColor to this. For an event listener
    // to use `this` in its function body, it must be bound to `this`.
    this.changeColor = this.changeColor.bind(this)
  }
  
  changeColor() {
    const newColor = this.state.color === green ? yellow : green
    this.setState({ color: newColor })
  }
  
  render() {
    return (
      <div style={{background: this.state.color}}>
        <h1>
          Change my color
        </h1>
        <button onClick={this.changeColor}>
          Change color
        </button>
      </div>
    );
  }
}
```

Any time you call `setState`, React automatically calls `render` again, rendering the component with the updated state!

PROPS VS. STATE
---------------

When should you use `state`, and when should you use `props`?

Generally speaking, you should favor props over state. Props lend themselves well to a declarative style, and limit the amount
of side-effecting logic that components have. Props are also only set at render time – you should never update props _within_ a
component. If you find yourself needing to update some attribute of a Component, that's a sign you should be using `state`.

A common design pattern in React is to have a "stateless" child component nested within a "stateful" parent component. The parent
passes its updated `state` down to the child component in the form of prop attributes. A good rule of thumb to follow is:

  1. A React component should use `props` to store data that can only be changed by _another_ component.

  2. A React component should use `state` to store data that the component itself can change.

STATE BETWEEN COMPONENTS
------------------------

Another common design pattern is have a stateless child component update a parent's state via an event handler function passed
down from the parent:

```
import React from 'react'

class Parent extends React.Component {
  constructor(props) {
    super(props)
    this.state = { title: 'NEAT' }
    this.changeTitle = this.changeTitle.bind(this)
  }
  
  changeTitle(title) {
    this.setState({ title: newTitle })
  }
  
  render() {
    return <Child title={this.state.title} handleChange={this.changeTitle}/>
  }
}
```

```
import React from 'react'

class Child extends React.Component {
  constructor(props {
    super(props)
    this.handleKeyPress = this.handleKeyPress.bind(this)
  }

  onChange(e) {
    this.props.handleChange(e.target.value)
  }

  render() {
    return (
      <div>
        <h1>{this.props.title}</h1>
        <form>
         Title: <input type="text" name="title" onChange={this.onChange}>
        </form>
      </div>
    )
  }
}
```

STATELESS FUNCTIONAL COMPONENTS
-------------------------------

React Components should be small, and it's a good design pattern to separate presentation from the logic behind that presentation.
A common pattern is to create "presentation" components, which only define a `render` function, within "container" components, which
define some logic for updating the presentation component's state.

If you have a simple presentation component that only defines a `render` function, you can further simplify it by converting it to a
function. This is known as a 'stateless functional component`:

```
// A component class written in the usual way:
export class class MyComponentClass extends React.Component {
  render() {
    return <h1>Hello {this.props.name}</h1>;
  }
}

// The same component class, written as a stateless functional component:
export const MyComponentClass = (props) => {
  return <h1>Hello {props.name}</h1>;
}
```

Stateless functional components can be rendered the same way as normal components.

PROP TYPES
----------

Prop types allow you to enforce basic type checks for your component's props.

```
import React from 'react';

export class MessageDisplayer extends React.Component {
  render() {
    return <h1>{this.props.message}</h1>;
  }
}

// This propTypes object should have
// one property for each expected prop:
MessageDisplayer.propTypes = {
  message: React.PropTypes.string.isRequired // 'isRequired' may be omitted if a prop is optional.
};
```

The possible types you can check for include:

```
React.PropTypes.string
React.PropTypes.object
React.PropTypes.bool
React.PropTypes.number
React.PropTypes.func
React.PropTypes.array
React.PropTypes.shape({
  name: React.PropTypes.string,
  age: React.PropTypes.number
})
```

LIFECYCLE METHODS
-----------------

Lifecycle methods are methods that get called at a certain point in time in a component's lifecycle. For example, you might
want to call a method right before a component renders, or right after it renders.

1. Mounting lifecycle methods – these are called when the component is rendered for the first time. They are called in the 
   following order:

   `componentWillMount` – called before component is rendered for the first time.
   `render`
   `componentDidMount` – called after component is rendered for the first time. Often used as a connecting point for some API.

2. Updating lifecyle methods – these are called everytime the component renders _after_ the first render. They are called
   in the following order:

   `componentWillReceiveProps(nextProps)` – only called if component receives props.
   `shouldComponentUpdate(nextProps, nextState)` – determines whether the component should update or not. Should be a predicate.
   `componentWillUpdate(nextProps, nextState)` – called before component is rendered.
   `render`
   `componentDidUpdate(prevProps, prevState)` – called after component is rendered.

3. Unmounting lifecycle methods – these are called when a component is removed from DOM, or if the DOM is closed. There is only one: 

   `componentWillUnmount`

