class Queue<T> {
  final List<T> _storage = <T>[];

  void addElements(T element) {
    _storage.add(element);
  }

  // Peek
  T get peek {
    if (_storage.isEmpty) throw Exception("Storage is Empty");
    return _storage.last;
  }

  T removeLastIndex() {
    if (_storage.isEmpty) return throw Exception("Storage is Empty");
    return _storage.removeAt(0);
  }

  bool get isEmpty => _storage.isEmpty;
  bool get isNotEmpty => _storage.isNotEmpty;

  @override
  String toString() => "Storage: $_storage";
}
