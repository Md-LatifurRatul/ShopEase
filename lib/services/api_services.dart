import 'dart:convert';

import 'package:e_commerce_project/model/product_model.dart';
import 'package:e_commerce_project/services/utils/api_url.dart';
import 'package:http/http.dart';

class ApiServices {
  Future<ProductModel> fetchProudcts() async {
    final response = await get(Uri.parse(ApiUrl.apiUrl));

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }
}
