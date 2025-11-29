import 'dart:collection';

/// ==============================================================================
/// PART 1: HELPER DATA STRUCTURES (Stack & Queue)
/// ==============================================================================

// A generic LIFO (Last-In-First-Out) Stack implementation.
/// Usage: Used for Depth-First Search (DFS).
class Stack<T> {
  final List<T> _storage = [];

  void push(T element) {
    _storage.add(element);
  }

  T pop() {
    if (_storage.isEmpty) throw Exception('Stack is empty');
    return _storage.removeLast();
  }

  T get peek {
    if (_storage.isEmpty) throw Exception('Stack is empty');
    return _storage.last;
  }

  bool get isEmpty => _storage.isEmpty;
  bool get isNotEmpty => _storage.isNotEmpty;

  @override
  String toString() => 'Stack: $_storage';
}

/// A generic FIFO (First-In-First-Out) Queue implementation.
/// Usage: Used for Breadth-First Search (BFS).
class Queue<T> {
  final List<T> _storage = [];

  void enqueue(T element) {
    _storage.add(element);
  }

  T dequeue() {
    if (_storage.isEmpty) throw Exception('Queue is empty');
    return _storage.removeAt(
      0,
    ); // Note: O(n) operation in simple List, usually O(1) in specific Queue implementations
  }

  bool get isEmpty => _storage.isEmpty;
  bool get isNotEmpty => _storage.isNotEmpty;

  @override
  String toString() => 'Queue: $_storage';
}

/// ==============================================================================
/// PART 2: GRAPH COMPONENTS (Vertex & Edge)
/// ==============================================================================

/// Represents a node in the graph.
class Vertex<T> {
  final int index;
  final T data;

  Vertex({required this.index, required this.data});

  @override
  String toString() => data.toString();
}

/// Represents a connection between two vertices, with an optional weight.
class Edge<T> {
  final Vertex<T> source;
  final Vertex<T> destination;
  final double weight;

  Edge(this.source, this.destination, [this.weight = 1.0]);
}

/// ==============================================================================
/// PART 3: THE GRAPH CLASS
/// ==============================================================================

/// An Adjacency List implementation of a Graph.
/// Supports both directed and undirected graphs.
class Graph<T> {
  // Using a Map to store edges for each vertex.
  // Key: The source Vertex.
  // Value: A list of Edges connected to that vertex.
  final Map<Vertex<T>, List<Edge<T>>> _adjacencies = {};

  // Helper to keep track of created vertices to avoid duplicates
  final List<Vertex<T>> _vertices = [];

  /// Creates a new vertex and adds it to the graph.
  Vertex<T> createVertex(T data) {
    final vertex = Vertex(index: _vertices.length, data: data);
    _vertices.add(vertex);
    _adjacencies[vertex] = [];
    return vertex;
  }

  /// Adds a directed edge: source -> destination
  void addDirectedEdge(
    Vertex<T> source,
    Vertex<T> destination, [
    double weight = 1.0,
  ]) {
    final edge = Edge(source, destination, weight);
    _adjacencies[source]?.add(edge);
  }

  /// Adds an undirected edge: source <-> destination
  void addUndirectedEdge(
    Vertex<T> source,
    Vertex<T> destination, [
    double weight = 1.0,
  ]) {
    addDirectedEdge(source, destination, weight);
    addDirectedEdge(destination, source, weight);
  }

  /// ============================================================================
  /// ALGORITHM 1: Breadth-First Search (BFS)
  /// Time Complexity: O(V + E)
  /// Explores neighbors layer by layer. Good for finding shortest path in unweighted graphs.
  /// ============================================================================
  void bfs(Vertex<T> startVertex) {
    print('\n--- Running BFS starting from ${startVertex.data} ---');

    final queue = Queue<Vertex<T>>();
    final visited = <Vertex<T>>{}; // Set for fast lookup

    queue.enqueue(startVertex);
    visited.add(startVertex);

    while (queue.isNotEmpty) {
      final current = queue.dequeue();
      print('Visited: ${current.data}');

      final neighbors = _adjacencies[current] ?? [];

      for (final edge in neighbors) {
        if (!visited.contains(edge.destination)) {
          visited.add(edge.destination);
          queue.enqueue(edge.destination);
        }
      }
    }
  }

  /// ============================================================================
  /// ALGORITHM 2: Depth-First Search (DFS)
  /// Time Complexity: O(V + E)
  /// Explores as deep as possible along each branch before backtracking.
  /// ============================================================================
  void dfs(Vertex<T> startVertex) {
    print('\n--- Running DFS starting from ${startVertex.data} ---');

    final stack = Stack<Vertex<T>>();
    final visited = <Vertex<T>>{};

    stack.push(startVertex);
    visited.add(startVertex);

    while (stack.isNotEmpty) {
      final current = stack.pop();
      print('Visited: ${current.data}');

      // Get neighbors
      final neighbors = _adjacencies[current] ?? [];

      // We reverse the list before pushing to stack so they are popped in natural order
      // (This is optional, but makes the output order more intuitive)
      for (final edge in neighbors.reversed) {
        if (!visited.contains(edge.destination)) {
          visited.add(edge.destination);
          stack.push(edge.destination);
        }
      }
    }
  }

  /// ============================================================================
  /// ALGORITHM 3: Dijkstra's Shortest Path
  /// Time Complexity: O(E * log V) using Priority Queue (Simplified here)
  /// Finds the shortest path from start to all other nodes based on weights.
  /// ============================================================================
  void dijkstra(Vertex<T> start) {
    print('\n--- Running Dijkstra starting from ${start.data} ---');

    // 1. Initialize distances: 0 for start, infinity for others
    final distances = <Vertex<T>, double>{};
    final previous = <Vertex<T>, Vertex<T>?>{};

    // Initialize all vertices
    for (final vertex in _vertices) {
      distances[vertex] = double.infinity;
      previous[vertex] = null;
    }
    distances[start] = 0;

    // 2. Priority Queue logic (Using a simple List and sorting for demonstration)
    // In production, use a proper PriorityQueue for better performance.
    var queue = List<Vertex<T>>.from(_vertices);

    while (queue.isNotEmpty) {
      // Find vertex with smallest distance in queue
      queue.sort((a, b) => distances[a]!.compareTo(distances[b]!));
      final current = queue.removeAt(0);

      // If simplest distance is infinity, remaining vertices are unreachable
      if (distances[current] == double.infinity) break;

      final neighbors = _adjacencies[current] ?? [];

      for (final edge in neighbors) {
        final neighbor = edge.destination;
        final newDist = distances[current]! + edge.weight;

        if (newDist < distances[neighbor]!) {
          distances[neighbor] = newDist;
          previous[neighbor] = current;
        }
      }
    }

    // Print Results
    print('Shortest distances from ${start.data}:');
    distances.forEach((vertex, distance) {
      if (distance != double.infinity) {
        print('To ${vertex.data}: $distance');
      } else {
        print('To ${vertex.data}: Unreachable');
      }
    });

    // Helper to print specific path
    _printPath(start, _vertices.last, previous);
  }

  void _printPath(
    Vertex<T> start,
    Vertex<T> end,
    Map<Vertex<T>, Vertex<T>?> previous,
  ) {
    print('\nPath Recovery (${start.data} -> ${end.data}):');
    final path = <Vertex<T>>[];
    var current = end;

    if (previous[current] == null && current != start) {
      print("No path exists.");
      return;
    }

    while (current != start) {
      path.add(current);
      final prev = previous[current];
      if (prev == null) break;
      current = prev;
    }
    path.add(start);

    print(path.reversed.map((v) => v.data).join(" -> "));
  }
}

/// ==============================================================================
/// PART 4: MAIN EXECUTION
/// ==============================================================================

void main() {
  print('=============================================');
  print('     DART DATA STRUCTURES: GRAPH DEMO        ');
  print('=============================================');

  final graph = Graph<String>();

  // 1. Create Vertices (Imagine these are Cities)
  print('Creating vertices...');
  final manila = graph.createVertex('Manila');
  final cebu = graph.createVertex('Cebu');
  final davao = graph.createVertex('Davao');
  final baguio = graph.createVertex('Baguio');
  final palawan = graph.createVertex('Palawan');
  final boracay = graph.createVertex('Boracay');

  // 2. Create Edges (Imagine these are flight costs/distance)
  print('Connecting cities...');

  // Manila Hub
  graph.addUndirectedEdge(manila, baguio, 250); // 250km / $250
  graph.addUndirectedEdge(manila, cebu, 570);
  graph.addUndirectedEdge(manila, palawan, 600);

  // Cebu Connections
  graph.addUndirectedEdge(cebu, davao, 400);
  graph.addUndirectedEdge(cebu, boracay, 300);

  // Davao Connections
  graph.addUndirectedEdge(davao, palawan, 900); // Long flight

  // Boracay Connections
  graph.addUndirectedEdge(boracay, palawan, 350);

  // 3. Run Breadth-First Search
  // Should show exploration layer by layer
  graph.bfs(manila);

  // 4. Run Depth-First Search
  // Should go deep into one path (e.g., Manila -> Cebu -> Davao...) before backing up
  graph.dfs(manila);

  // 5. Run Dijkstra (Shortest Path)
  // Let's find the cheapest way to travel
  graph.dijkstra(manila);

  // 6. Test Unreachable Node
  print('\n--- Testing Disconnected Node ---');
  final tokyo = graph.createVertex('Tokyo'); // Not connected to anything
  graph.dijkstra(manila); // Tokyo should be unreachable

  print('\n=============================================');
  print('               DEMO COMPLETE                 ');
  print('=============================================');
}
