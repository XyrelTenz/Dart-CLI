// Single Linked List
class Node<T> {
  T value;
  Node<T>? next;

  Node({required this.value, this.next});
}

void printLinkedList(Node<int>? head) {
  Node<int>? currentNode = head;

  while (currentNode != null) {
    print(currentNode.value);

    currentNode = currentNode.next;
  }
}
