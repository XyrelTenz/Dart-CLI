import "./api/fetch.dart";

void main() async {
  try {
    API fetch = await fetchData();
    print(fetch.id);
    print(fetch.title);
  } catch (e) {
    print("Error caught: $e");
  }
}
