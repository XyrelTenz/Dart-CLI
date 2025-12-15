class Stack<T> {
  final List<T> _storage = <T>[];

  void add(T elements) {
    return _storage.add(elements);
  }

  T pop() {
    if (_storage.isEmpty) throw Exception("Stack is Empty");

    return _storage.removeLast();
  }

  T get peek {
    if (_storage.isEmpty) throw Exception("Stack is Empty");
    print("Peek: $_storage");

    return _storage.last;
  }

  bool get isEmpty => _storage.isEmpty;
  bool get isNotEmpty => _storage.isNotEmpty;

  @override
  String toString() => "Stack: $_storage";
}
