import 'dart:collection';
import "dart:io";
import 'dart:math';

/// ==============================================================================
/// PART 1: THE NODE CLASS
/// ==============================================================================

/// Represents a single node in the Binary Tree.
class TreeNode<T extends Comparable> {
  T value;
  TreeNode<T>? left;
  TreeNode<T>? right;

  TreeNode(this.value);

  /// Helper to check if this is a leaf node (no children).
  bool get isLeaf => left == null && right == null;

  @override
  String toString() => value.toString();
}

/// ==============================================================================
/// PART 2: THE BINARY SEARCH TREE (BST)
/// ==============================================================================

class BinarySearchTree<T extends Comparable> {
  TreeNode<T>? root;

  /// --------------------------------------------------------------------------
  /// INSERTION (Recursive)
  /// Time Complexity: O(log n) average, O(n) worst case
  /// --------------------------------------------------------------------------
  void insert(T value) {
    root = _insertRecursive(root, value);
  }

  TreeNode<T> _insertRecursive(TreeNode<T>? node, T value) {
    // 1. Base Case: If we hit a null spot, create the node here.
    if (node == null) {
      return TreeNode(value);
    }

    // 2. Recursive Step: Decide to go Left or Right
    // compareTo returns negative if value < node.value
    if (value.compareTo(node.value) < 0) {
      node.left = _insertRecursive(node.left, value);
    } else if (value.compareTo(node.value) > 0) {
      node.right = _insertRecursive(node.right, value);
    } else {
      // Value already exists (we don't insert duplicates in this implementation)
      print('Duplicate value ignored: $value');
    }

    return node;
  }

  /// --------------------------------------------------------------------------
  /// SEARCH (Recursive)
  /// Time Complexity: O(log n)
  /// --------------------------------------------------------------------------
  bool contains(T value) {
    return _containsRecursive(root, value);
  }

  bool _containsRecursive(TreeNode<T>? node, T value) {
    if (node == null) return false;

    if (value == node.value) return true;

    if (value.compareTo(node.value) < 0) {
      return _containsRecursive(node.left, value);
    } else {
      return _containsRecursive(node.right, value);
    }
  }

  /// --------------------------------------------------------------------------
  /// DELETION (The Tricky Part)
  /// Time Complexity: O(log n)
  /// --------------------------------------------------------------------------
  void remove(T value) {
    root = _removeRecursive(root, value);
  }

  TreeNode<T>? _removeRecursive(TreeNode<T>? node, T value) {
    if (node == null) return null;

    if (value.compareTo(node.value) < 0) {
      // Target is in left subtree
      node.left = _removeRecursive(node.left, value);
    } else if (value.compareTo(node.value) > 0) {
      // Target is in right subtree
      node.right = _removeRecursive(node.right, value);
    } else {
      // Found the node! Now handle the 3 cases:

      // Case 1: Node is a leaf (no children)
      if (node.left == null && node.right == null) {
        return null;
      }

      // Case 2: Node has only one child
      if (node.left == null) return node.right;
      if (node.right == null) return node.left;

      // Case 3: Node has TWO children
      // Find the smallest value in the RIGHT subtree (Successor)
      T minValue = _findMin(node.right!);
      node.value = minValue; // Replace current value with successor
      // Delete the duplicate successor node from the right subtree
      node.right = _removeRecursive(node.right, minValue);
    }
    return node;
  }

  T _findMin(TreeNode<T> node) {
    while (node.left != null) {
      node = node.left!;
    }
    return node.value;
  }

  /// --------------------------------------------------------------------------
  /// TRAVERSALS
  /// --------------------------------------------------------------------------

  // 1. In-Order: Left -> Root -> Right (Sorted Output)
  void printInOrder() {
    print('In-Order Traversal (Sorted):');
    _inOrderRecursive(root);
    print(''); // New line
  }

  void _inOrderRecursive(TreeNode<T>? node) {
    if (node != null) {
      _inOrderRecursive(node.left);
      stdout.write(
        '${node.value} ',
      ); // dart:io not imported, using print for safety
      _inOrderRecursive(node.right);
    }
  }

  // 2. Pre-Order: Root -> Left -> Right (Useful for cloning trees)
  void printPreOrder() {
    print('Pre-Order Traversal:');
    _preOrderRecursive(root);
    print('');
  }

  void _preOrderRecursive(TreeNode<T>? node) {
    if (node != null) {
      stdout.write('${node.value} ');
      _preOrderRecursive(node.left);
      _preOrderRecursive(node.right);
    }
  }

  // 3. Post-Order: Left -> Right -> Root (Useful for deleting trees)
  void printPostOrder() {
    print('Post-Order Traversal:');
    _postOrderRecursive(root);
    print('');
  }

  void _postOrderRecursive(TreeNode<T>? node) {
    if (node != null) {
      _postOrderRecursive(node.left);
      _postOrderRecursive(node.right);
      stdout.write('${node.value} ');
    }
  }

  // 4. Breadth-First Search (Level Order)
  void printLevelOrder() {
    print('Level-Order (BFS) Traversal:');
    if (root == null) return;

    final queue = Queue<TreeNode<T>>();
    queue.add(root!);

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      stdout.write('${current.value} ');

      if (current.left != null) queue.add(current.left!);
      if (current.right != null) queue.add(current.right!);
    }
    print('');
  }

  /// --------------------------------------------------------------------------
  /// UTILITIES & METRICS
  /// --------------------------------------------------------------------------

  int getHeight() {
    return _getHeightRecursive(root);
  }

  int _getHeightRecursive(TreeNode<T>? node) {
    if (node == null) return -1; // -1 for edges count, 0 for node count
    return 1 +
        max(_getHeightRecursive(node.left), _getHeightRecursive(node.right));
  }

  /// --------------------------------------------------------------------------
  /// VISUALIZATION (ASCII ART)
  /// --------------------------------------------------------------------------
  void printTree() {
    print('\n--- Tree Visualizer ---');
    _printTreeRecursive(root, "", true);
    print('-----------------------\n');
  }

  void _printTreeRecursive(TreeNode<T>? node, String prefix, bool isTail) {
    if (node == null) return;

    stdout.write(
      prefix + (isTail ? "└── " : "├── ") + node.value.toString() + "\n",
    );

    List<TreeNode<T>?> children = [];
    if (node.left != null || node.right != null) {
      // Even if one is null, we push both to maintain structure in complex views
      // But for simple viewing, let's just push existing ones
      if (node.right != null) children.add(node.right);
      if (node.left != null) children.add(node.left);
    }

    for (int i = 0; i < children.length; i++) {
      _printTreeRecursive(
        children[i],
        prefix + (isTail ? "    " : "│   "),
        i == children.length - 1,
      );
    }
  }
}

// Helper for stdout.write since we didn't import dart:io to keep it web-compatible
// If running in terminal, import 'dart:io';

/// ==============================================================================
/// PART 3: MAIN EXECUTION
/// ==============================================================================

void main() {
  final bst = BinarySearchTree<int>();

  print('1. Inserting data into BST...');
  // Inserting in this specific order to create a nice structure
  // Root
  bst.insert(50);

  // Left Subtree
  bst.insert(30);
  bst.insert(20);
  bst.insert(40);

  // Right Subtree
  bst.insert(70);
  bst.insert(60);
  bst.insert(80);

  // Visualization
  bst.printTree();

  // Traversals
  bst.printInOrder(); // Should be 20 30 40 50 60 70 80
  bst.printPreOrder(); // Should be 50 30 20 40 70 60 80
  bst.printPostOrder(); // Should be 20 40 30 60 80 70 50
  bst.printLevelOrder(); // Should be 50 30 70 20 40 60 80

  // Search
  print('\n2. Testing Search:');
  print('Contains 40? ${bst.contains(40)}'); // true
  print('Contains 99? ${bst.contains(99)}'); // false

  // Metrics
  print('\n3. Tree Metrics:');
  print('Tree Height: ${bst.getHeight()}');

  // Deletion - Case 1: Leaf Node
  print('\n4. Removing 20 (Leaf Node)...');
  bst.remove(20);
  bst.printInOrder();

  // Deletion - Case 2: One Child
  // Let's add a node to make 60 have a child
  print('Adding 55 to create a single-child scenario for 60...');
  bst.insert(55);
  bst.printTree();

  print('Removing 60 (Has one child 55)...');
  bst.remove(60);
  bst.printTree();

  // Deletion - Case 3: Two Children
  print('Removing 50 (Root - Two Children)...');
  // Logic: 50 is replaced by 55 (min of right subtree if 60 is gone) or
  // depending on current structure.
  bst.remove(50);
  bst.printTree();

  print('Final Validation (In-Order):');
  bst.printInOrder();
}
