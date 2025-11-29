void sortedArray() {
  List<int> numbers = [5, 2, 7, 4, 1]..sort((a, b) => b.compareTo(a));
  print(numbers);
}
