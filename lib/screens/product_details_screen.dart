import 'package:e_commerce_project/model/products_item.dart';
import 'package:flutter/material.dart';

class ProductDetaiScreen extends StatelessWidget {
  const ProductDetaiScreen({super.key, required this.products});

  final ProductsItem products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(products.title!)),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              products.thumbnail!,
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
                    products.title!,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Price: \$${products.price}",
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  SizedBox(height: 10),
                  Text(products.description!, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
