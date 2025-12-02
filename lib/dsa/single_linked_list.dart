class Node<T> {
  T value;
  Node<T>? next;

  Node({this.next, required this.value});
}

void printLinkedList(Node<int>? head) {
  var currentNode = head;

  while (currentNode != null) {
    print(currentNode.value);

    currentNode = currentNode.next;
  }
}
