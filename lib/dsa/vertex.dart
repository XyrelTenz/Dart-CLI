class Vertex<T> {
  final int index;
  final T data;

  Vertex({required this.index, required this.data});

  @override
  String toString() => data.toString();
}

class Edge<T> {
  final Vertex<T> source;
  final Vertex<T> destination;
  final double weight;

  Edge(this.source, this.destination, [this.weight = 1.0]);
}

class Graph<T> {
  // We store a list of all vertices
  final List<Vertex<T>> _vertices = [];

  // We store connections using a Map (Adjacency List)
  // Key: The Source Vertex
  // Value: A list of Edges coming out of that vertex
  final Map<Vertex<T>, List<Edge<T>>> _adjList = {};

  // 1. Create and Add a Vertex
  Vertex<T> createVertex(T data) {
    // We automatically assign an index based on the list size
    final vertex = Vertex(index: _vertices.length, data: data);

    _vertices.add(vertex);
    _adjList[vertex] = []; // Initialize an empty list of edges for this vertex

    return vertex;
  }

  // Add an Edge (Connection)
  void addEdge(
    Vertex<T> source,
    Vertex<T> destination, {
    double weight = 1.0,
    bool directed = true,
  }) {
    // Create the edge
    final edge = Edge(source, destination, weight);

    // Add it to the source's list of connections
    _adjList[source]?.add(edge);

    // If it's an undirected graph (two-way street), add the reverse edge
    if (!directed) {
      final reverseEdge = Edge(destination, source, weight);
      _adjList[destination]?.add(reverseEdge);
    }
  }

  // Display the Graph
  void printGraph() {
    for (var vertex in _vertices) {
      final edges = _adjList[vertex];
      if (edges == null || edges.isEmpty) {
        print("$vertex --> []");
      } else {
        // Create a readable string of connections
        final connections = edges
            .map((e) => "${e.destination}(wt:${e.weight})")
            .join(", ");
        print("$vertex --> [$connections]");
      }
    }
  }
}
