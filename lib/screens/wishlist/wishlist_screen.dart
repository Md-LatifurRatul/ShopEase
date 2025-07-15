import 'package:e_commerce_project/controllers/services/wishlist_service.dart';
import 'package:e_commerce_project/model/product_model.dart';
import 'package:e_commerce_project/widgets/product_card.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Wishlist"),
        backgroundColor: Colors.deepPurple,
      ),

      body: StreamBuilder(
        stream: WishlistService.wishListStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong: ${snapshot.error}"),
            );
          }

          final docs = snapshot.data!.docs;
          if (!snapshot.hasData || docs.isEmpty) {
            return const Center(child: Text("Your wishlist is empty"));
          }

          final products =
              snapshot.data!.docs
                  .map((doc) => ProductModel.fromJson(doc.data()))
                  .toList();

          return GridView.builder(
            padding: EdgeInsets.all(8),
            itemCount: products.length,

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return ProductCard(
                key: ValueKey(products[index].id),
                product: products[index],
                addToCartIcon: false,
                onAddToCart: null,
              );
            },
          );
        },
      ),
    );
  }
}
