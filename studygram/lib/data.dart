import 'package:http/http.dart' as http;
import 'dart:convert';
import 'structure.dart';

class Data {
  static Future<List<dynamic>> fetchTrilogies() async {
    final response = await http
        .get(Uri.parse("https://trilogy-server.azurewebsites.net/trilogies"));

    if (response.statusCode == 200) {
      final List<dynamic> userList = json.decode(response.body);
      return userList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception("Could not get data.");
    }
  }
}
