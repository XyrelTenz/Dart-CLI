// import "./api/fetch.dart";
// import "./dsa/sorted_array.dart";
import "./dsa/stack.dart";
// import "./dsa/queue.dart";
import "./dsa/vertex.dart";

// void main() async {
//   try {
//     API fetch = await fetchData();
//     print(fetch.id);
//     print(fetch.title);
//   } catch (e) {
//     print("Error caught: $e");
//   }
// }
void main() {
  // sortedArray();
  Stack<dynamic> stack = Stack<dynamic>()
    ..push(1)
    ..push(2)
    ..push(3)
    ..push(4)
    ..push(5)
    ..pop();

  print(stack);

  // List<int> numbers = <int>[4, 3, 2, 5, 1]..sort((a, b) => a.compareTo(b));
  // print("Sorted Array: $numbers");
  // Queue<dynamic> queue = Queue<dynamic>()
  //   ..addElements(1)
  //   ..addElements(2)
  //   ..addElements(3)
  //   ..peek
  //   ..removeLastIndex();
  // // Expected output: 2,3
  //
  // print(queue);
  //
  Vertex<dynamic> vertexes = Vertex<dynamic>(index: 1, data: 2);
  print(vertexes);
}
