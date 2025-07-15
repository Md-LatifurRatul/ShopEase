import 'package:e_commerce_project/model/product_model.dart';
import 'package:e_commerce_project/repository/product_repository.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _repository = ProductRepository();
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;

  List<ProductModel> get products => _products;
  List<ProductModel> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await _repository.fetchProduct();
      _filteredProducts = List.from(_products);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void filterProducts(String query) {
    if (query.trim().isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts =
          _products.where((product) {
            final name = product.name.toLowerCase();
            final desc = product.description.toLowerCase();
            return name.contains(query.toLowerCase()) ||
                desc.contains(query.toLowerCase());
          }).toList();
    }
    notifyListeners();
  }

  void applyFilters({
    required double minPrice,
    required double maxPrice,
    required double minRating,
  }) {
    _filteredProducts =
        _products.where((product) {
          final matchPrice =
              product.price >= minPrice && product.price <= maxPrice;
          final matchRating = product.rating >= minRating;
          return matchPrice && matchRating;
        }).toList();
    notifyListeners();
  }

  void resetFilters() {
    _filteredProducts = List.from(_products);
    notifyListeners();
  }
}
