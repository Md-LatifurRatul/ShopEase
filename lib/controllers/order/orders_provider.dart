import 'package:e_commerce_project/controllers/services/order_service.dart';
import 'package:e_commerce_project/model/order_model.dart';
import 'package:flutter/widgets.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _orders = await OrderService.fetchUserOrders();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
