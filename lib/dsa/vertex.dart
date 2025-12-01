class Vertex<T> {
  final int index;
  final T data;

  //
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
