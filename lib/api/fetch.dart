import 'dart:convert';
import "package:http/http.dart" as http;

class API {
  final int id;
  final String title;
  final String body;

  const API({required this.id, required this.title, required this.body});

  factory API.fromJSON(Map<String, dynamic> json) {
    return API(id: json["id"], title: json["title"], body: json["body"]);
  }
}

Future<API> fetchData() async {
  final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");

  final response = await http.get(uri);

  // if (response.statusCode == 404) {
  //   throw Exception("Data not Found");
  // }

  if (response.statusCode == 200) {
    return API.fromJSON(jsonDecode(response.body));
  } else {
    throw Exception("Failed to fetch Data");
  }
}
