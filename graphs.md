Basic Graph Theory
==================

A graph is composed of two elements:

1. Nodes (or vertices)
2. Edges

One node represents one element in the graph, while the edges represent the connections between nodes.

There are many types of graphs depending on their properties. You may already be familiar with Trees – these are just a type of graph.

Uses for Graphs
---------------

Graphs have a wide range of uses in computation. You can use graphs to:

* Find the shortest or longest path between two locations
* Check if two things are related to each other
* Build recommendation engines
* Analyze dependencies

Types of Graphs
---------------

This is by no means an exhaustive list, but here are some of the more common properties of graphs you will encounter.

### Directed vs. Undirected

In a _directed_ graphs, each edge has a direction, meaning there is only one direction you can travel from one node to another node along a given edge.

In an _undirected_ graph, edges have no direction.

Trees are a type of directed graph, with all nodes stemming from a single root node in one direction (generally thought of as "down").

### Cyclic vs. Acyclic

A _cyclic_ graph has at least one cycle, meaning there is a path along its edges that loops back to itself.

An _acyclic_ graph has no cycles.

### Weighted Graphs

Weighted graphs are a useful way to map relationships or "affinities" between nodes. Weights are given edges, representing the cost of going from one node to another along this edge.

For example, you may represent a map of cities as a weighted graph, where each node is a city and each edge has a weight, in miles, representing the distance between them.

