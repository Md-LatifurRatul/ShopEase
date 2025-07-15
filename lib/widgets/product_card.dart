import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_project/controllers/services/wishlist_service.dart';
import 'package:e_commerce_project/model/product_model.dart';
import 'package:e_commerce_project/widgets/build_stars_rating.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.addToCartIcon,
  });

  final ProductModel product;

  final Function(ProductModel)? onAddToCart;
  final bool addToCartIcon;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // bool isWishListed = false;

  // @override
  // void initState() {
  //   super.initState();
  //   // checkWishList();
  // }

  // void checkWishList() async {
  //   final exists = await WishlistService.isInWishList(
  //     widget.product.id.toString(),
  //   );

  //   setState(() {
  //     isWishListed = exists;
  //   });
  // }

  // void toggleWishList() async {
  //   if (isWishListed) {
  //     await WishlistService.removeFromWishList(widget.product.id.toString());
  //   } else {
  //     await WishlistService.addToWishList(widget.product);
  //   }

  //   setState(() {
  //     isWishListed = !isWishListed;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Wrap(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),

                child: CachedNetworkImage(
                  imageUrl: widget.product.imageUrl,
                  placeholder:
                      (context, url) =>
                          Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),

              StreamBuilder<bool>(
                stream: WishlistService.isInWishListStream(
                  widget.product.id.toString(),
                ),
                builder: (context, snapshot) {
                  final isWishListed = snapshot.data ?? false;
                  return Positioned(
                    top: 8,
                    right: 8,

                    child: GestureDetector(
                      onTap: () {
                        if (isWishListed) {
                          WishlistService.removeFromWishList(
                            widget.product.id.toString(),
                          );
                        } else {
                          WishlistService.addToWishList(widget.product);
                        }
                      },

                      child: Icon(
                        isWishListed ? Icons.favorite : Icons.favorite_border,
                        color: isWishListed ? Colors.red : Colors.grey,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Text(
                      "\$${widget.product.price}",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Row(
                      children: BuildStarsRating.buildStarRating(
                        widget.product.rating,
                        15,
                      ),
                    ),

                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          if (widget.onAddToCart != null) {
                            widget.onAddToCart!(widget.product);
                          }
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
