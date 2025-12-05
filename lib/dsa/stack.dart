// Stack Array Algorithm
/*
* 1. Push Element
* 2. Pop Element
* 3. Peek Element
* 4. Display element
*/

// LIFO = Last In Last Out

class Stack<T> {
  final List<T> _storage = <T>[];

  // Push an Stack
  void push(T element) {
    _storage.add(element);
  }

  // Pop out the last Array
  T pop() {
    if (_storage.isEmpty) throw Exception("Stack is Empty");
    T item = _storage.last;
    _storage.removeLast();
    return item;
  }

  // Peek the last Array
  T get peek {
    if (_storage.isEmpty) throw Exception("Stack is Empty");
    return _storage.last;
  }

  // Find Array
  T findItem(T item) {
    if (_storage.isEmpty) throw Exception("Stack is Empty");
    if (_storage.contains(item)) {
      print("Array Found $item");
      return item;
    } else {
      throw Exception("Stack Array is not Found");
    }
  }

  // Helper to check if Stack isEmpty or Not Empty
  bool get isEmpty => _storage.isEmpty;
  bool get isNotEmpty => _storage.isNotEmpty;

  @override
  String toString() => "Stack: $_storage";
}
