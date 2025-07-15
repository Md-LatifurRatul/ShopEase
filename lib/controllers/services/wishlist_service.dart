import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/model/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistService {
  static final _auth = FirebaseAuth.instance;

  static final _firestore = FirebaseFirestore.instance;

  static Future<void> addToWishList(ProductModel product) async {
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

  static Future<List<ProductModel>> getWishList() async {
    final user = _auth.currentUser;

    if (user == null) return [];

    final snapshot =
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection("wishlist")
            .get();

    return snapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data()))
        .toList();
  }

  static Stream<bool> isInWishListStream(String productId) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(false);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection("wishlist")
        .doc(productId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> wishListStream() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection("users")
        .doc(user.uid)
        .collection("wishlist")
        .snapshots();
  }
}
