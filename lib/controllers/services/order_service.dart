import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/model/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> saveOrder({
    required List<Map<String, dynamic>> products,
    required double amount,
    required String address,
    required String phone,
    required String paymentMethod,
  }) async {
    await _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .collection("orders")
        .add({
          'products': products,
          'amount': amount,
          'address': address,
          'phone': phone,
          'payment_method': paymentMethod,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  static Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .collection('orders')
              .orderBy('timestamp', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching user orders: $e');
      return [];
    }
  }
}
