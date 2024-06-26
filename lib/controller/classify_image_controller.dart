import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//w
class ClassifyImageController extends ChangeNotifier {
  Future<Map<String, dynamic>> scanImage(String image) async {
    try {
      final String baseUrl = dotenv.env['SCANNER']!;
      final response = await http.post(
        Uri.parse("$baseUrl/predict"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, String>{
          "image": image,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': e.toString()};
    }
  }
}
