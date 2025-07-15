import 'dart:convert';

import 'package:e_commerce_project/controllers/services/api_services.dart';
import 'package:e_commerce_project/model/banner_model.dart';
import 'package:e_commerce_project/services/utils/api_url.dart';

class BannerRepository {
  Future<List<BannerModel>> fetchModel() async {
    final response = await ApiServices().get(ApiUrl.bannerList);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => BannerModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch banners");
    }
  }
}
