import 'package:e_commerce_project/model/product_model.dart';
import 'package:e_commerce_project/widgets/build_stars_rating.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.products});

  final ProductModel products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(products.name)),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              products.imageUrl,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    products.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        "Price: \$${products.price}",
                        style: TextStyle(fontSize: 18, color: Colors.green),
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: BuildStarsRating.buildStarRating(
                          products.rating,
                          20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Ratings: ${products.rating.toStringAsFixed(1)}/5",

                        style: TextStyle(color: Colors.redAccent, fontSize: 16),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 10),

                  // Text(
                  //   products.reviews != null && products.reviews!.isNotEmpty
                  //       ? "Product Reviews: ${products.reviews?.length ?? 0}"
                  //       : "No reviews",
                  //   style: TextStyle(color: Colors.grey, fontSize: 14),
                  // ),
                  SizedBox(height: 10),
                  Text(products.description, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
