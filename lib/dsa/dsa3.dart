import 'dart:math';

/// ==============================================================================
/// PART 1: UTILITIES & HELPERS
/// ==============================================================================

/// A helper to check if a list is actually sorted (for validation).
bool isSorted<T extends Comparable>(List<T> list) {
  for (int i = 0; i < list.length - 1; i++) {
    if (list[i].compareTo(list[i + 1]) > 0) {
      return false;
    }
  }
  return true;
}

/// A standard swap function used by many sorting algorithms.
void swap<T>(List<T> list, int i, int j) {
  final temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}

/// Generates a list of random integers.
List<int> generateRandomList(int size, {int max = 10000}) {
  final rng = Random();
  return List.generate(size, (_) => rng.nextInt(max));
}

/// ==============================================================================
/// PART 2: QUADRATIC SORTS - O(n^2)
/// These are simple to write but slow on large datasets.
/// ==============================================================================

class QuadraticSorts {
  /// 1. BUBBLE SORT
  /// Concept: Repeatedly steps through the list, swaps adjacent elements
  /// if they are in the wrong order. Large values "bubble" to the top.
  static void bubbleSort<T extends Comparable>(List<T> list) {
    int n = list.length;
    bool swapped;

    for (int i = 0; i < n - 1; i++) {
      swapped = false;
      // Last i elements are already in place, so we iterate to n-i-1
      for (int j = 0; j < n - i - 1; j++) {
        if (list[j].compareTo(list[j + 1]) > 0) {
          swap(list, j, j + 1);
          swapped = true;
        }
      }
      // Optimization: If no two elements were swapped inner loop, list is sorted.
      if (!swapped) break;
    }
  }

  /// 2. SELECTION SORT
  /// Concept: Divides the list into two parts: sorted and unsorted.
  /// Repeatedly selects the smallest element from the unsorted sublist
  /// and moves it to the sorted sublist.
  static void selectionSort<T extends Comparable>(List<T> list) {
    int n = list.length;

    for (int i = 0; i < n - 1; i++) {
      int minIndex = i;

      for (int j = i + 1; j < n; j++) {
        if (list[j].compareTo(list[minIndex]) < 0) {
          minIndex = j;
        }
      }

      if (minIndex != i) {
        swap(list, i, minIndex);
      }
    }
  }

  /// 3. INSERTION SORT
  /// Concept: Builds the final sorted array one item at a time.
  /// Much like sorting playing cards in your hand.
  /// Very fast for small or nearly sorted lists.
  static void insertionSort<T extends Comparable>(List<T> list) {
    int n = list.length;

    for (int i = 1; i < n; i++) {
      T key = list[i];
      int j = i - 1;

      // Move elements of list[0..i-1] that are greater than key
      // to one position ahead of their current position
      while (j >= 0 && list[j].compareTo(key) > 0) {
        list[j + 1] = list[j];
        j = j - 1;
      }
      list[j + 1] = key;
    }
  }
}

/// ==============================================================================
/// PART 3: LOGARITHMIC SORTS - O(n log n)
/// These use "Divide and Conquer" and are much faster for large data.
/// ==============================================================================

class FastSorts {
  /// 4. MERGE SORT
  /// Concept: Recursively splits the list in half, sorts the halves,
  /// and then merges them back together.
  static void mergeSort<T extends Comparable>(List<T> list) {
    if (list.length <= 1) return;

    // Divide
    int mid = list.length ~/ 2;
    List<T> left = list.sublist(0, mid);
    List<T> right = list.sublist(mid);

    // Conquer (Recursive calls)
    mergeSort(left);
    mergeSort(right);

    // Merge
    _merge(list, left, right);
  }

  static void _merge<T extends Comparable>(
    List<T> result,
    List<T> left,
    List<T> right,
  ) {
    int i = 0; // Index for left
    int j = 0; // Index for right
    int k = 0; // Index for result

    while (i < left.length && j < right.length) {
      if (left[i].compareTo(right[j]) <= 0) {
        result[k] = left[i];
        i++;
      } else {
        result[k] = right[j];
        j++;
      }
      k++;
    }

    // Copy remaining elements of left, if any
    while (i < left.length) {
      result[k] = left[i];
      i++;
      k++;
    }

    // Copy remaining elements of right, if any
    while (j < right.length) {
      result[k] = right[j];
      j++;
      k++;
    }
  }

  /// 5. QUICK SORT
  /// Concept: Picks a "pivot" element and partitions the array so
  /// smaller elements are left, larger are right.
  static void quickSort<T extends Comparable>(List<T> list) {
    _quickSortRecursive(list, 0, list.length - 1);
  }

  static void _quickSortRecursive<T extends Comparable>(
    List<T> list,
    int low,
    int high,
  ) {
    if (low < high) {
      // pi is partitioning index, list[pi] is now at right place
      int pi = _partition(list, low, high);

      _quickSortRecursive(list, low, pi - 1); // Before pi
      _quickSortRecursive(list, pi + 1, high); // After pi
    }
  }

  static int _partition<T extends Comparable>(List<T> list, int low, int high) {
    // We take the last element as pivot
    T pivot = list[high];
    int i = (low - 1); // Index of smaller element

    for (int j = low; j < high; j++) {
      // If current element is smaller than or equal to pivot
      if (list[j].compareTo(pivot) <= 0) {
        i++;
        swap(list, i, j);
      }
    }
    swap(list, i + 1, high);
    return i + 1;
  }
}

/// ==============================================================================
/// PART 4: BENCHMARKING ENGINE
/// ==============================================================================

typedef SorterFunction = void Function(List<int> list);

class Benchmark {
  final String name;
  final SorterFunction sorter;

  Benchmark(this.name, this.sorter);

  void run(List<int> originalData) {
    // 1. Create a clean copy so we don't sort an already sorted list
    List<int> data = List.from(originalData);

    // 2. Measure execution time
    final stopwatch = Stopwatch()..start();
    sorter(data);
    stopwatch.stop();

    // 3. Validate
    if (!isSorted(data)) {
      print('❌ $name FAILED verification!');
      return;
    }

    // 4. Print result
    print('✅ $name: ${stopwatch.elapsedMilliseconds} ms');
  }
}

/// ==============================================================================
/// PART 5: MAIN EXECUTION
/// ==============================================================================

void main() {
  print('=============================================');
  print('     DART ALGORITHMS: SORTING BATTLE         ');
  print('=============================================');

  // CONFIGURATION
  const int DATA_SIZE = 10000; // 10,000 items
  print('Generating $DATA_SIZE random numbers...');

  final List<int> masterDataset = generateRandomList(DATA_SIZE);
  print('Dataset ready. Starting race...\n');

  // Define our contestants
  final algorithms = [
    // The Slow Group (O(n^2))
    Benchmark('Bubble Sort', QuadraticSorts.bubbleSort),
    Benchmark('Selection Sort', QuadraticSorts.selectionSort),
    Benchmark('Insertion Sort', QuadraticSorts.insertionSort),

    // The Fast Group (O(n log n))
    Benchmark('Merge Sort', FastSorts.mergeSort),
    Benchmark('Quick Sort', FastSorts.quickSort),

    // The Reference (Dart's built-in optimized sort)
    Benchmark('Dart Built-in Sort', (list) => list.sort()),
  ];

  print('--- RESULTS (Lower is better) ---');

  for (var algo in algorithms) {
    // Hint: Quadratic sorts might take a few seconds on 10k items.
    // If you increase DATA_SIZE to 50k, they might freeze your terminal!
    algo.run(masterDataset);
  }

  print('\n=============================================');
  print('               ANALYSIS                      ');
  print('=============================================');
  print('1. Bubble/Selection/Insertion are roughly O(n^2).');
  print('   They are significantly slower on large lists.');
  print('2. Merge/Quick Sort are O(n log n).');
  print('   They are thousands of times faster as data grows.');
  print('3. Dart\'s built-in sort is highly optimized C++ underneath.');
  print('=============================================');

  // Bonus: Show small dataset behavior
  print('\n[Visual Check on Small Data]');
  final smallData = generateRandomList(10, max: 100);
  print('Original: $smallData');
  FastSorts.quickSort(smallData);
  print('Sorted:   $smallData');
}
