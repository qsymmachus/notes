GraphQL
=======

* [Introduction to GraphQL](https://graphql.org/learn/)

Conceptually GraphQL is both

1. A __query language__ for an API,
2. A server-side __runtime__ for executing these queries using a defined schema.

GraphQL is agnostic about the datastore backing the queries, and provides a consistent interface for querying against an API. It's often presented as an alternative to RESTful HTTP APIs. It doesn't really compete with RPC protocols like gRPC or Thrift.

Queries and Mutations
---------------------

GraphQL queries allow clients to request specific fields on objects, excluding all other fields. This ability to _selectively retrieve_ data is convenient for callers and also provides an opportunity for server-side implementations to lazy-load this data.

This simple query:

```graphql
{
  hero {
    name
    friends {
      name
    }
  }
}
```

Returns this JSON, with the same shape:

```json
{
  "data": {
    "hero": {
      "name": "R2-D2",
      "friends": [
        {
          "name": "Luke Skywalker"
        },
        {
          "name": "Han Solo"
        },
        {
          "name": "Leia Organa"
        }
      ]
    }
  }
}
```

### Arguments

Some queries also accept arguments:

```graphql
{
  human(id: "1000") {
    name
    height
  }
}
```

Every field and nested object in a query can potentially have its own arguments, allowing you to capture complex requests in a single query:

```graphql
{
  human(id: "1000") {
    name
    height(unit: FOOT)
  }
}
```

### Aliases

if you want to query the same object field multiple times with different arguments in a single query, you'll need to disambiguate them. You can do this with field aliases:

```graphql
{
  empireHero: hero(episode: EMPIRE) {
    name
  }
  jediHero: hero(episode: JEDI) {
    name
  }
}
```

```json
{
  "data": {
    "empireHero": {
      "name": "Luke Skywalker"
    },
    "jediHero": {
      "name": "R2-D2"
    }
  }
}
```

### Fragments

If you find yourself repeating the same boilerplate multiple times in a single query, you can parameterize or template this boilerplate into reusable units called __fragments__.

```graphql
{
  leftComparison: hero(episode: EMPIRE) {
    ...comparisonFields
  }
  rightComparison: hero(episode: JEDI) {
    ...comparisonFields
  }
}

fragment comparisonFields on Character {
  name
  appearsIn
  friends {
    name
  }
}
```

### Operation types and names

In our previous examples we've used a shorthand syntax in our query, but more often than not queries include an __operation type__ and an __operation name__.

```graphql
query HeroNameAndFriends {
  hero {
    name
    friends {
      name
    }
  }
}
```

`query` is this operation type in this example. It describes, well, the type of operation. It can either by `query`, `mutation`, or `subscription`.

`HeroNameAndFriends` is the operation name. The name is specific to the API and defined in the GraphQL schema.

### Variables

All our previous examples have been _static_, and no templated values have been interpolated in the queries. This is accomplished using __variables__.

```graphql
query HeroNameAndFriends($episode: Episode) {
  hero(episode: $episode) {
    name
    friends {
      name
    }
  }
}
```

This query is then sent with an additional variables payload, which assigns values to the named variables:

```json
{
  "episode": "JEDI"
}
```

Variables are typed. They must be scalars, enums, or other object types as defined in the API schema (in this example, `Episode`).

Queries support default arguments:

```graphql
query HeroNameAndFriends($episode: Episode = JEDI) {
  hero(episode: $episode) {
    name
    friends {
      name
    }
  }
}
```

### Directives

__Directives__ allow you to include conditional logic in your queries:

* `@include(if: Boolean)` Only include this field in the result if the argument is true.
* `@skip(if: Boolean)` Skip this field if the argument is true.

Example query with directive:

```graphql
query Hero($episode: Episode, $withFriends: Boolean!) {
  hero(episode: $episode) {
    name
    friends @include(if: $withFriends) {
      name
    }
  }
}
```

### Mutations

Mutations are an operation type that make it explicit that your query will mutate application state.

Example mutation query, and variable payload:

```graphql
mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) {
  createReview(episode: $ep, review: $review) {
    stars
    commentary
  }
}
```

```json
{
  "ep": "JEDI",
  "review": {
    "stars": 5,
    "commentary": "This is a great movie!"
  }
}
```

The response; note that it returns the fields listed in the query, allowing you to update and retrieve th data in the same request:

```json
{
  "data": {
    "createReview": {
      "stars": 5,
      "commentary": "This is a great movie!"
    }
  }
}
```

__Important!__ While query fields are executed in parallel, because they can be safely, __mutation fields run in series__. This means if you send multiple mutations in one request, they will be executed on after the order, in order.

### Inline Fragments

GraphQL schemas may define interfaces and union types. Union types may potentially have different shapes, so queries may need to have to have different shapes based on the returned type. You can match queries on type using __inline fragments__, which are easiest to understand with an example:

```graphql
query HeroForEpisode($ep: Episode!) {
  hero(episode: $ep) {
    name
    ... on Droid {
      primaryFunction
    }
    ... on Human {
      height
    }
  }
}
```

In this example, the `hero` field returns a `Character`, which is union type of `Droid` and `Human`.

The inline fragments `... on Droid` and `... on Human` allow us to match on type, querying different fields in each case.

Schemas and Types
-----------------

Every GraphQL service defines a set of types – a __schema__ – that describe the entire API. Queries are validated and executed against that schema.

GraphQL schemas use their own DSL to describe the shape of the API. Here's an example:

```graphql
type Character {
  name: String!
  appearsIn: [Episode!]!
}
```

This defines the shape of a `Character` type. 

* `!` indicates that a field is _non-nullable_, i.e. it will always return a value.
* `[SomeType]` indicates that this is an array of `SomeType`.

### Arguments

Recall that some fields in GraphQL queries accept arguments. This possibility is made clear in the schema:

```graphql
type Starship {
  id: ID!
  name: String!
  length(unit: LengthUnit = METER): Float
}
```

### The type system

Scalar types:

* `Int`: signed 32-bit integers.
* `Float`: signed double-precision floating-point number.
* `String`: a UTF-8 character sequence.
* `Boolean`: `true` or `false`.
* `ID`: a unique identifier, serialized the same way as a string. Defining it as an `ID` makes it clear that it's not meant to be human readable.

Enums:

```graphql
enum CardinalDirection {
  NORTH
  SOUTH
  EAST
  WEST
}
```

### Query and mutation types

Most types in a schema will be normal object types, but there are two special types, `Query` and `Mutation`. These define the entry points of every GraphQL query. Every GraphQL API must have at least one `Query`, and may optionally include `Mutation`s. 

So if you see a query like this:

```graphql
query {
  hero {
    name
  }
  droid(id: "2000") {
    name
  }
}
```

There _must_ be a query type in the schema that accepts `hero` and `droid` fields, like this:

```graphql
type Query {
  hero(episode: Episode): Character
  droid(id: ID!): Droid
}
```

### Interfaces

Interfaces allow you to define an object shape that may be shared by different types:

```graphql
interface Character {
  id: ID!
  name: String!
  friends: [Character]
  appearsIn: [Episode]!
}

type Human implements Character {
  id: ID!
  name: String!
  friends: [Character]
  appearsIn: [Episode]!
  starships: [Starship]
  totalCredits: Int
}
```

### Union types

Union types are what you'd expect:

```
union SearchResult = Human | Droid | Starship
```

Since each subtype in the union may have a completely different shape, you'll need to use __inline fragments__ in a query to retrieve the fields you care about based on subtype matching (see the section on inline fragments above for more details):

```graphql
{
  search(text: "an") {
    __typename
    ... on Human {
      name
      height
    }
    ... on Droid {
      name
      primaryFunction
    }
    ... on Starship {
      name
      length
    }
  }
}
```

### Input types

Confusingly in my opinion, GraphQL distinguishes between _output_ types returned by queries and __input types__ that are passed as arguments, for example to a mutation query. They look the same as ordinary `types` but use the `input` keyword instead:

```graphql
input ReviewInput {
  stars: Int!
  commentary: String
}
```

Using this input type in a mutation:

```graphql
mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) {
  createReview(episode: $ep, review: $review) {
    stars
    commentary
  }
}
```

```json
{
  "ep": "JEDI",
  "review": {
    "stars": 5,
    "commentary": "This is a great movie!"
  }
}
```

Execution
---------

After being validated against the schema, a GraphQL query is then _executed_ server-side. The server returns a payload that mirrors the shape of the requested query, typically as JSON.

Let's walk through an example of how this is implemented, using this simple schema:

```graphql
type Query {
  human(id: ID!): Human
}
 
type Human {
  name: String
  appearsIn: [Episode]
  starships: [Starship]
}
 
enum Episode {
  NEWHOPE
  EMPIRE
  JEDI
}
 
type Starship {
  name: String
}
```

This schema accepts the following query:

```graphql
{
  human(id: 1002) {
    name
    appearsIn
    starships {
      name
    }
  }
}
```

### Resolvers

You can think of each field in a GraphQL query as a function or method of the previous, parent type, that returns the next type. This is exactly how GraphQL works under the hood. Each field is backed by a __resolver__ function implemented server-side. When a field is executed, the corresponding resolver is called.

If the returned value is a scalar type, no further calls are required. If it's an object, we continue to recursively call resolvers until we arrive at scalar values.

Here's an example resolver written in Javascript, implementing our `human` query:

```javascript
Query: {
  human(obj, args, context, info) {
    return context.db.loadHumanByID(args.id).then(
      userData => new Human(userData)
    )
  }
}
```

A resolver function receives four arguments:

* `obj` The previous object, which for a field on the root Query type is often not used.
* `args` The arguments provided to the field in the GraphQL query.
* `context` A value which is provided to every resolver and holds important contextual information like the currently logged in user, or access to a database.
* `info` A value which holds field-specific information relevant to the current query as well as the schema details.

After the `human` data is retrieved, we still need to get `starships` data. GraphQL will automatically call its resolver, but we need to implement it:

```javascript
Human: {
  starships(obj, args, context, info) {
    return obj.starshipIDs.map(
      id => context.db.loadStarshipByID(id).then(
        shipData => new Starship(shipData)
      )
    )
  }
}
```

Note how we're using data from the parent object, `obj.starshipIDs`, to parameterize the starships query.

Practices
---------

The following practices are usually followed when implementing a GraphQL API:

* GraphQL is typically served over a __single HTTP endpoint__ to receive all queries. This is in contrast to RESTful APIs that have a separate path for each endpoint.
* Responses are almost always JSON, ideally GZIP'd.
* GraphQL avoids API versioning. Because it only returns data that's explicitly requested, new capabilities can be added on top of an existing API without introducing breaking changes. But, if you _remove_ a field, that would be a breaking change.
* All GraphQL fields are nullable by default. If an error causes you to fail to return a particular field, that field is often just left `null`. This is a weird way to handle this if you ask me.

GraphQL Federation
------------------

Typically the schema for a single GraphQL API is implemented by a single backing server. 
However, it is possible to take a single API and have it implemented by multiple, discrete APIs that are merged. This is called __federation__.

The _de facto_ standard approach to graph federation is [Apollo Federation](https://www.apollographql.com/docs/federation/), which we'll learn about here.

In a federated architecture, separate GraphQL APIs called __subgraphs__ are composed into a single __supergraph__. From a client's perspective, nothing has changed – they can query the supergraph as if it were a single API. What's changed is how those queries are resolved – the supergraph's __router__ just needs to understand how the schema is composed, and where the data it needs is distributed across the subgraphs.

### Combining subgraph schemas

#### Subgraph schemas

Each subgraph will have its own schema. Subgraph schemas indicate _which_ types and fields they can resolve. These schemas are written much the same way other GraphQL schemas are defined, by people.

Subgraph schemas use __federated directives__ imported from `https://specs.apollo.dev/federation/v2.3` to define how the subgraph fits into the larger supergraph.

These example subgraph schemas all include some important directives like `@key`, read the comments below to see how they work:

```graphql
# 1. Users subgraph:

type Query {
  me: User
}

# `@key` designates that this object is an entity (meaning it can resolve its fields across multiple subgraphs). It specifies its `fields`, which are the set of fields that the subgraph can use to uniquely identify an instance of this entity.
type User @key(fields: "id") {
  id: ID!
  # `@shareable` indicates that this field can be resolved by multiple subgraphs.
  username: String! @shareable
}

# (Subgraph schemas include
# this to opt in to
# Federation 2 features.)
extend schema
  @link(url: "https://specs.apollo.dev/federation/v2.3",
        import: ["@key", "@shareable"])
```

```graphql
# 2. Products subgraph:

type Query {
  topProducts(first: Int = 5): [Product]
}

type Product @key(fields: "upc") {
  upc: String!
  name: String!
  price: Int
}

extend schema
  @link(url: "https://specs.apollo.dev/federation/v2.3",
        import: ["@key"])
```

```graphql
# 3. Reviews subgraph: 

type Review {
  body: String
  author: User @provides(fields: "username")
  product: Product
}

type User @key(fields: "id") {
  id: ID!
  username: String! @external
  reviews: [Review]
}

type Product @key(fields: "upc") {
  upc: String!
  reviews: [Review]
}

# (This subgraph uses additional
# federated directives)
extend schema
  @link(url: "https://specs.apollo.dev/federation/v2.3",
        import: ["@key", "@shareable", "@provides", "@external"])
```

As these examples illustrate, multiple subgraphs can contribute fields to a single type. For example, both the user and products subgraphs contribute fields to the `Review` type.

You can learned about all the federated directives in the [directive docs](https://www.apollographql.com/docs/federation/federated-types/federated-directives/).

#### The supergraph schema

The __supergraph schema__ is created by composing each subgraph schema into one, giant schema, plus federation-specific information that tells the router which subgraphs can resolve which fields. 

The supergraph schema is machine-generated using [composition](https://www.apollographql.com/docs/federation/federated-types/composition/) and is not particularly human-readable, so there's no point sharing an example here.

The supergraph schema is what is __used by the server__ (that is, the router) to understand and correctly plan distributed queries.

#### The API schema

Schema composition process also produces an __API schema__, which is what is __used by clients__ to query your federated API as if it were a single GraphQL API.

This is much cleaner and easier to understand than the supergraph schema:

```graphql
type Product {
  name: String!
  price: Int
  reviews: [Review]
  upc: String!
}

type Query {
  me: User
  topProducts(first: Int = 5): [Product]
}

type Review {
  author: User
  body: String
  product: Product
}

type User {
  id: ID!
  reviews: [Review]
  username: String!
}
```

### The router

In a federated architecture each subgraph is queried only by the __router__, never by clients directly. The router implements the supergraph's schema by planning queries that distribute the requests across all the subgraphs, and then returns that data to the client.

The router is one of the following:

* The [Apollo Router](https://www.apollographql.com/docs/router/) executable (written in Rust).
* An instance of Apollo Server (written in Javascript) using special extensions from the `@apollo/gateway` library.

### How federated types are resolved

An __entity__ is an object type that can resolve its fields across multiple subgraphs.

In this simple example, the `Product` entity is defined and resulved across two subgraphs:

```graphql
type Product @key(fields: "id") {
  id: ID!
  name: String!
  price: Int
}
```

```graphql
type Product @key(fields: "id") {
  id: ID!
  inStock: Boolean!
}
```

Note that __the entity must be defined in each subgraph where its data is lives__. Each definition contains one particular slice of the data that makes up the overall entity.

To define an entity type within a subgraph, you follow a few basic steps.

#### 1. Define a `@key`

Any object type is designated as an entity using the `@key` directive:

```graphql
type Product @key(fields: "id") {
  id: ID!
  name: String!
  price: Int
}
```

The `@key` directive defines the entity's __primary key__, which is one or more of (a set) of the object's fields. This key must uniquely identify the entity – it's how the router knows how to associate data from _different_ subgraphs to model the _same_ entity instance.

#### 2. Define a reference resolver

The `@key` directive signals to the router that an entity can be resolved across multiple subgraphs __if you provide its primary key__. For this to work, each subgraph that includes the entity must define a __reference resolver__ for it.

Exactly how a reference resolver depends on what library you're using to define your GraphQL resolvers. Here's an example using Apollo Server:

```javascript
// Products subgraph
const resolvers = {
  Product: {
    __resolveReference(productRepresentation) {
      return fetchProductByID(productRepresentation.id);
    }
  },
  // ...other resolvers...
}
```

The important things to note here are:

* You declare the reference resolver as a member of the entity's corresponding object (in this case, `Product`).
* A reference resolver's name is always `__resolverReference`.
* The resolver's first paratmer is a representation of the entity being resolved. This representation is provided by the router automatically.
* A reference resolver is responsible for returning all the fields that this subgraph defines.

Every subgraph that contributes one or more fields to an entity must define a reference resolver for that entity.

#### Referencing an entity without contributing fields

Sometimes a subgraph would like to make an entity resolvable within its own types, but not actually contribute any new fields to the entity.

To do this, you just need to add a __stub__ of the entity in your subgraph:

```graphql
type Review {
  product: Product! # Reference to the product entity
  score: Int!
}

type Product @key(fields: "id", resolvable: false) {
  id: ID!
}
```

Not that the stub only needs to contain the `@key` fields of `Product`. In addition, the `resolvable: false` parameter indicates that this subgraph can't resolve the type itself, so there's no need to define a reference resolver in this subgraph.
