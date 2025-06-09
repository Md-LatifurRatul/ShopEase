import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final List<Map<String, dynamic>> products;
  final double amount;
  final String address;
  final String phone;
  final String paymentMethod;
  final DateTime? timestamp;
  OrderModel({
    required this.products,
    required this.amount,
    required this.address,
    required this.phone,
    required this.paymentMethod,
    required this.timestamp,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      products: List<Map<String, dynamic>>.from(json['products']),
      amount: (json['amount'] as num).toDouble(),
      address: json['address'],
      phone: json['phone'],
      paymentMethod: json['payment_method'],
      timestamp:
          json['timestamp'] != null
              ? (json['timestamp'] as Timestamp).toDate()
              : null,
    );
  }
}
