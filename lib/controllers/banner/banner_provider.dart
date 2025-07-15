import 'package:e_commerce_project/model/banner_model.dart';
import 'package:e_commerce_project/repository/banner_repository.dart';
import 'package:flutter/widgets.dart';

class BannerProvider with ChangeNotifier {
  final BannerRepository _repository = BannerRepository();

  List<BannerModel> _banners = [];
  bool _isLoading = false;
  String? _error;
  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBanner() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _banners = await _repository.fetchModel();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
