import 'dart:convert';
import 'dart:developer';

import 'package:e_commerce_project/controllers/services/api_services.dart';
import 'package:e_commerce_project/model/product_model.dart';
import 'package:e_commerce_project/services/utils/api_url.dart';

class ProductRepository {
  Future<List<ProductModel>> fetchProduct() async {
    final response = await ApiServices().get(ApiUrl.productList);
    log("Product log: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch products");
    }
  }
}
