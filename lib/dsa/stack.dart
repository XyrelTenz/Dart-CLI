// Stack Array Algorithm
/*
* 1. Push Element
* 2. Pop Element
* 3. Peek Element
* 4. Display element
*/

// LIFO

class Stack<T> {
  final List<T> _storage = <T>[];

  // Push an Stack
  void push(T element) {
    _storage.add(element);
  }

  // Pop out the last Array
  T pop() {
    if (_storage.isEmpty) throw Exception("Stack is Empty");
    return _storage.removeLast();
  }

  // Peek the last Array
  T get peek {
    if (_storage.isEmpty) throw Exception("Stack is Empty");
    return _storage.last;
  }

  // Helper to check if Stack isEmpty or Not Empty
  bool get isEmpty => _storage.isEmpty;
  bool get isNotEmpty => _storage.isNotEmpty;

  @override
  String toString() => "Stack: $_storage";
}
