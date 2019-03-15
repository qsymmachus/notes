REDUX
=====

Redux is a library that allows you to manage the overall state of your Javascript
application.

The whole state of the application is stored in an object tree called the `store`. 

The `store` is updated by emitting `action`s, an object describing what happened.

To specify how `action`s transform the `store`, your write functions called `reducer`s.

Resources:

  * See `react.txt` and `react-router.txt` for a fuller picture of your hypothetical application
  * http://redux.js.org/

INSTALLATION
------------

Install `redux`. If you're using React with your application, also install `react-redux`.

CORE CONCEPTS
-------------

1. Imagine your application's state as a simple Javascript object. This is the `store`.  The `store` of a 
simple todo app might look like this:

```
{
  todos: [{
    text: 'Eat food',
    completed: true
  }, 
  {
    text: 'Exercise',
    completed: false
  }],
  visibilityFilter: 'SHOW_COMPLETED'
}
```

2. To change something in our store, we need to dispatch an `action`. An `action` is also a plain Javascript
object:

```
{ type: 'ADD_TODO', text: 'Go to swimming pool' }
{ type: 'TOGGLE_TODO', index: 1 }
{ type: 'SET_VISIBILITY_FILTER', filter: 'SHOW_ALL' }
```

3. Finally, to tie the store and actions together, we write functions called `reducers`:

```
function todos(state = [], action) {
  switch (action.type) {
    case 'ADD_TODO':
      return state.concat([{ text: action.text, completed: false }])
    case 'TOGGLE_TODO':
      return state.map(
        (todo, index) =>
          action.index === index
            ? { text: todo.text, completed: !todo.completed }
            : todo
      )
    default:
      return state
  }
}
```

We tie our app together with one "root" reducer:

```
function todoApp(state = {}, action) {
  return {
    todos: todos(state.todos, action),
    visibilityFilter: visibilityFilter(state.visibilityFilter, action)
  }
}
```

ACTIONS & ACTION CREATORS
-------------------------

Actions are payloads of information that send data from your application to your store.

Actions are sent to the store using `store.dispatch()`.

Here's an example action to add a new todo to our application:

```
const ADD_TODO = 'ADD_TODO'

{
  type: ADD_TODO,
  text: 'Build my first Redux app'
}
```

Actions must have a `type` property to identify it, and each type is typically defined in string
constants.

Other than `type`, the structure of the action object is entirely up to you and the needs of your
application.

"Action Creators" are functions that create actions:

```
function addTodo(text) {
  return {
    type: ADD_TODO,
    text
  }
}
```

Once you have action creators, updating the store just requires you to dispatch them:

```
dispatch(addTodo(text))
```

REDUCERS
--------

While actions are the "events" of our application, reducers determine what actually happens to the application's
state when an action is dispatched.

A reducer is a pure function that takes the previous state and an action, and returns the next state:

```
(previousState, action) => newState
```

Reducers _must be pure functions_. They must never do anything side-effecting. This makes it much easier to reason
about how data flows in our application.

When writing our reducers, we must define the initial state of our app in our 'root' reducer:

```
import { VisibilityFilters } from './actions'

const initialState = {
  visibilityFilter: VisibilityFilters.SHOW_ALL,
  todos: []
}

function todoApp(state = initialState, action) {
  switch (action.type) {
    case SET_VISIBILITY_FILTER:
      return { ..state, visibilityFilter: action.filter }
    default:
      return state
  }
}
```

Note that we never mutate `state`. On line 151 above, we use "object spread syntax" to create a copy of the `state` object
(first argument) with the specified properties changed (following arguments):

```
return { ..state, visibilityFilter: action.filter }
```

REDUCER COMPOSITION
-------------------

It's possible to have one giant root reducer like `todoApp` above that has handling for every possible action. It's more sensible
however to decompose your reducers so each handles one discrete task (or very closely related tasks).

Redux provides helper methods to remove some of the boilerplate around reducer composition. `combineReducers` is helpful:

```
import { combineReducers } from 'redux'

const todoApp = combineReducers({
  visibilityFilter,
  todos
})

export default todoApp
``` 

This is functionally equivalent to:

```
export default function todoApp(state = {}, action) {
  return {
    visibilityFilter: visibilityFilter(state.visibilityFilter, action),
    todos: todos(state.todos, action)
  }
}
```

STORE
-----

As noted before, the store is the single unified state of your application. It has the following API:

  1. Allows access to state via `getState()`
  2. Allows state to be updated via `dispatch(action)`
  3. Registers listeners via `subscribe(listener)`
  4. Handles unregistering of listeners via the function returned by `unsubscribe(listener)`

You create your store by passing your root reducer to `createStore`:

```
import { createStore } from 'redux'
import todoApp from './reducers'
let store = createStore(todoApp)
```

DATA FLOW
---------

Redux architecture enforces _unidirectional_ data flow. This means that changes in state always follow the same
lifecycle pattern. The data lifecycle in any Redux app frollows these four steps:

  1. You call `store.dispatch(action)`.

  2. The store passed the action to the reducer function you passed when you constructed the store.
       * Assuming you used `combineReducers` to compose multiple reducers, the action is passed to _each_ reducer.
       * The aggregate changes made by each reducer (some will in fact do nothing) are combined to create the new store.

  3. The store saves the updated state.

USAGE WITH REACT
----------------

See `react.txt` for more information on React. This guide assumes you are already familiar with React.

Redux and React are unrelated libraries, but they pair well together because React allows to describe UI as functions
of state, and Redux provides a sensible way to manage application state.

You should install React bindings for Redux by installing `react-redux`.

React bindings for Redux embrace the idea of separating _presentational_ and _container_ components (see `react.txt`
for more detail on this distinction. In a nutshell,

  1. Presentational deal with how things _look_
       * Not aware of Redux
       * Read data from props
       * Change data with callbacks from props

  2. Container Components deal with how things _work_
       * Aware of Redux
       * Read data by subscribing to Redux state
       * Change data by dispatching Redux actions
  
Presentational Components are written by hand, but Container components can be generated using the `connect()` function provided
by React Redux.

CONTAINER COMPONENTS
--------------------

A container component is just a React component that uses store.subscribe() to read a part of the Redux state tree 
and supply props to a presentational component it renders.

You could write your container components by hand, by as noted before you should use `connect()` both for ease of use and
because it makes performance optimizations.

To use `connect`, you need to define two functions:

  1. `mapStateToProps`, which takes the Redux `state` as an argument and return a `props` object to pass to the presentation layer

  2. `mapDispatchToProps`, which takes the `dispatch` function as an argument a `props` object with callbacks to pass to the presentation layer.

Here's an example Container component, which manages our visibility filter for our todo list:

```
import { connect } from 'react-redux'
import { toggleTodo } from '../actions'
import TodoList from '../components/TodoList'

// Helper method for filtering todos:
const getVisibleTodos = (todos, filter) => {
  switch (filter) {
    case 'SHOW_ALL':
      return todos
    case 'SHOW_COMPLETED':
      return todos.filter(t => t.completed)
    case 'SHOW_ACTIVE':
      return todos.filter(t => !t.completed)
  }
}

// 1. Map state to props:
const mapStateToProps = state => {
  return {
    todos: getVisibleTodos(state.todos, state.visibilityFilter)
  }
}

// 2. Map dispatch to props:
const mapDispatchToProps = dispatch => {
  return {
    onTodoClick: id => {
      dispatch(toggleTodo(id))
    }
  }
}

// Building our Container component:
const VisibleTodoList = connect(
  mapStateToProps,
  mapDispatchToProps
)(TodoList)

export default VisibleTodoList
```

WIRING EVERYTHING UP
--------------------

All Container components need access to the Redux store so they can subscribe to it. Fortunately
there is a React Redux component that makes this easy, `<Provider>`. Wrap your application in a 
`<Provider>` and it will pass the store down to all child elements:

```
import React from 'react'
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'
import { createStore } from 'redux'
import todoApp from './reducers'
import App from './components/App'

let store = createStore(todoApp)

ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
)
```

ASYNC ACTIONS
-------------

So far all our actions have all been synchronous – what about asynchronous actions, like a network call?

For async actions, you need to define actions for each step in the lifecycle of the action. In the example
of a network call, we probably want actions for when the request is first sent, when it fails, and when
it succeeds.

ASYNC ACTION CREATORS
---------------------

Next, we define action creators that make network requests. To accomplish this asynchronously, instead of 
writing action creators that return actions, we write action creators that _return functions that return
actions_!

This relies on using the React Thunk middleware (covered in detail below).

```
import fetch from 'isomorphic-fetch'

// Synchronous "request posts"
export const REQUEST_POSTS = 'REQUEST_POSTS'
function requestPosts(subreddit) {
  return {
    type: REQUEST_POSTS,
    subreddit
  }
}

// Synchronous "receive posts"
export const RECEIVE_POSTS = 'RECEIVE_POSTS'
function receivePosts(subreddit, json) {
  return {
    type: RECEIVE_POSTS,
    subreddit,
    posts: json.data.children.map(child => child.data),
    receivedAt: Date.now()
  }
}

// Asynchronous "fetch posts"!
export function fetchPosts(subreddit) {
  return function (dispatch) {
    // Signal that we're sending a request:
    dispatch(requestPosts(subreddit)

    // We're using the 'fetch' library to send requests:
    return fetch(`https://www.reddit.com/r/${subreddit}.json`)
      .then(
        response => response.json()
        error => console.log('Aw snap!)'
      )
      .then(json =>
        // Signal that we received the results!
        dispatch(receivePosts(subreddit, json)
      )
  }
}
```

This relies on using the React Thunk middleware (install `redux-thunk`):

```
import thunkMiddleware from 'redux-thunk'
import { createStore, applyMiddleware } from 'redux'
import { selectSubreddit, fetchPosts } from './actions'
import rootReducer from './reducers'

const store = createStore(
  rootReducer,
  applyMiddleware(
    thunkMiddleware, // lets us dispatch() functions
  )
)
```

