import 'package:http/http.dart' as http;

Future getSyllableCount(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}

Future getRhyme(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}

Future getMetre(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.body;
}
