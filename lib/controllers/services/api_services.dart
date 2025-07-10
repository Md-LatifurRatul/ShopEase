import 'dart:convert';

import 'package:e_commerce_project/model/product_model_dummy.dart';
import 'package:e_commerce_project/services/utils/api_url.dart';
import 'package:http/http.dart';

class ApiServices {
  Future<ProductModelDummy> fetchProudctsDummy() async {
    final response = await get(Uri.parse(ApiUrl.apiUrl));
    // Uri.parse("${ApiUrl.apiUrl}?skip=$skip&limit=$limit"),

    if (response.statusCode == 200) {
      return ProductModelDummy.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }
}
