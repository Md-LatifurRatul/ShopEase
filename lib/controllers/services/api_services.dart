import 'dart:convert';

import 'package:e_commerce_project/model/product_model_dummy.dart';
import 'package:e_commerce_project/services/utils/api_url.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static final ApiServices _instance = ApiServices._internal();
  factory ApiServices() => _instance;

  ApiServices._internal();

  final _client = http.Client();

  Future<http.Response> get(String url) async {
    return await _client.get(Uri.parse(url));
  }

  Future<ProductModelDummy> fetchProudctsDummy() async {
    final response = await http.get(Uri.parse(ApiUrl.apiUrl));
    // Uri.parse("${ApiUrl.apiUrl}?skip=$skip&limit=$limit"),

    if (response.statusCode == 200) {
      return ProductModelDummy.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }
}
