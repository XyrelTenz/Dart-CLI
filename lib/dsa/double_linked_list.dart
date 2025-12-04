class Node<T> {
  Node<T>? next;
  Node<T>? prev;
  T value;

  Node({required this.value, this.next, this.prev});
}

void printLinked(Node<int>? head) {
  Node<int>? currentNode = head;
  Node<int>? lastnode;
  while (currentNode != null) {
    print("Current Node: ${currentNode.value}");

    lastnode = currentNode;
    // Move to next Node
    currentNode = currentNode.next;
  }

  // Remove Duplicate
  if (lastnode != null) {
    lastnode = lastnode.prev;
  }

  while (lastnode != null) {
    print("Previous Node: ${lastnode.value}");

    //Go back to prev Node
    lastnode = lastnode.prev;
  }
}
