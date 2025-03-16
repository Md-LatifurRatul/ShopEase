import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_project/model/Products.dart';
import 'package:e_commerce_project/model/product_model.dart';
import 'package:e_commerce_project/screens/product_detai_screen.dart';
import 'package:e_commerce_project/services/api_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<ProductModel> futureProducts;
  List<Products> _products = [];
  List<Products> _filteredProducts = [];
  final TextEditingController _searchTEController = TextEditingController();
  final PageController _bannerController = PageController(
    viewportFraction: 0.9,
  );

  @override
  void initState() {
    super.initState();
    futureProducts = ApiServices().fetchProudcts();

    futureProducts.then((data) {
      setState(() {
        _products = data.products!;
        _filteredProducts = _products;
      });
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts =
          _products
              .where(
                (product) =>
                    product.title!.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    product.category!.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Commerce App'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          SizedBox(
            height: 180,

            child: PageView(
              controller: _bannerController,

              children: [
                _buildBanner("https://placehold.co/600x400/png", "Big Sale!"),
                _buildBanner(
                  "https://placehold.co/600x400/png",
                  "New Arrivals",
                ),
                _buildBanner(
                  "https://placehold.co/600x400/png",
                  "Exclusive Offers",
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),

            child: TextField(
              controller: _searchTEController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: "Search Products",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<ProductModel>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || _filteredProducts.isEmpty) {
                  return Center(child: Text('No Products found'));
                } else {
                  return GridView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: _filteredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      var product = _filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ProductDetaiScreen(products: product),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),

                                  child: CachedNetworkImage(
                                    imageUrl: product.thumbnail!,
                                    placeholder:
                                        (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget:
                                        (context, url, error) =>
                                            Icon(Icons.error),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "\$${product.price}",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(String imageUrl, String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(imageUrl, scale: 1),
          fit: BoxFit.cover,
        ),
      ),

      child: Align(
        alignment: Alignment.bottomLeft,

        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,

              fontWeight: FontWeight.bold,
              backgroundColor: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
