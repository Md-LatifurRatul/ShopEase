import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_project/model/products_item.dart';

import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  final ProductsItem product;

  final Function(ProductsItem) onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),

              child: CachedNetworkImage(
                imageUrl: product.thumbnail!,
                placeholder:
                    (context, url) =>
                        Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "\$${product.price}",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          onAddToCart(product);
                        },
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
