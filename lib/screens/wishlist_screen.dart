import 'package:e_commerce_project/model/products_item.dart';
import 'package:e_commerce_project/widgets/product_card.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key, required this.wishListItem});

  final List<ProductsItem> wishListItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Wishlist"),
        backgroundColor: Colors.deepPurple,
      ),

      body:
          wishListItem.isEmpty
              ? Center(child: Text("Your wishlist is empty"))
              : GridView.builder(
                padding: EdgeInsets.all(8),
                itemCount: wishListItem.length,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final product = wishListItem[index];
                  return ProductCard(product: product, onAddToCart: null);
                },
              ),
    );
  }
}
