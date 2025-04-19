import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/model/products_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistService {
  static final _auth = FirebaseAuth.instance;

  static final _firestore = FirebaseFirestore.instance;

  static Future<void> addToWishList(ProductsItem product) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .doc(product.id.toString())
        .set(product.toJson());
  }

  static Future<void> removeFromWishList(String productId) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection("wishlist")
        .doc(productId)
        .delete();
  }

  static Future<List<ProductsItem>> getWishList() async {
    final user = _auth.currentUser;

    if (user == null) return [];

    final snapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection("wishlist")
            .get();

    return snapshot.docs
        .map((doc) => ProductsItem.fromJson(doc.data()))
        .toList();
  }

  static Future<bool> isInWishList(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection("wishlist")
            .doc(productId)
            .get();
    return doc.exists;
  }
}
