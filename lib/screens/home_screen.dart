import 'dart:async';

import 'package:e_commerce_project/controllers/services/auth_exception.dart';
import 'package:e_commerce_project/controllers/services/firebase_auth_service.dart';
import 'package:e_commerce_project/model/product_model.dart';
import 'package:e_commerce_project/model/products_item.dart';
import 'package:e_commerce_project/screens/authentication/login_screen.dart';
import 'package:e_commerce_project/screens/cart_screen.dart';
import 'package:e_commerce_project/screens/product_details_screen.dart';
import 'package:e_commerce_project/services/api_services.dart';
import 'package:e_commerce_project/utils/banner_image_url.dart';
import 'package:e_commerce_project/widgets/confirm_dialog.dart';
import 'package:e_commerce_project/widgets/product_card.dart';
import 'package:e_commerce_project/widgets/toast_meesage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<ProductModel> futureProducts;
  List<ProductsItem> _products = [];
  final List<ProductsItem> _cartItems = [];
  List<ProductsItem> _filteredProducts = [];
  final TextEditingController _searchTEController = TextEditingController();
  late PageController _bannerController;
  int _currentIndex = 0;
  Timer? _timer;
  final _firebaseAuthService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    futureProducts = ApiServices().fetchProudcts();
    _bannerController = PageController(viewportFraction: 0.9, initialPage: 0);

    _startAutoSlide();

    futureProducts.then((data) {
      setState(() {
        _products = data.products!;
        _filteredProducts = _products;
      });
    });
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentIndex < BannerImageUrl.bannerImage.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _bannerController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
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

  void addToCart(ProductsItem product) {
    setState(() {
      _cartItems.add(product);
    });

    ToastMeesage.showToastMessage(context, "${product.title} added to cart!");
  }

  void openCart() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartScreen(cartItems: _cartItems),
        ),
      );
    });
  }

  Future<void> _signOut() async {
    try {
      await _firebaseAuthService.signOut();
      if (mounted) {
        ToastMeesage.showToastMessage(context, "Sign out success");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } on AuthException catch (e) {
      print("Sign out error: ${e.message}");

      if (mounted) {
        ToastMeesage.showToastMessage(context, "Sign out failed: ${e.message}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Commerce App'),
        backgroundColor: Colors.deepPurple,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: openCart,

                icon: Icon(Icons.shopping_cart, color: Colors.white, size: 35),
              ),

              if (_cartItems.isNotEmpty)
                Positioned(
                  top: 4,
                  right: 4,

                  child: Container(
                    padding: EdgeInsets.all(3),

                    decoration: BoxDecoration(
                      color: Colors.red,

                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                    child: Text(
                      "${_cartItems.length}",

                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.yellow),
            onPressed: () {
              ConfirmDialog.showAlertDialgoue(
                context,
                title: "Sign Out",
                content: "Are you sure you want to log-out?",
                confirmString: "Log-out",
                onPressed: () {
                  _signOut();
                },
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          SizedBox(
            height: 180,

            child: PageView(
              controller: _bannerController,

              children: [
                _buildBanner(BannerImageUrl.bannerImage[0], "Big Sale!"),
                _buildBanner(BannerImageUrl.bannerImage[1], "New Arrivals"),
                _buildBanner(BannerImageUrl.bannerImage[2], "Exclusive Offers"),
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
                      crossAxisCount: 3,
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
                        child: ProductCard(
                          product: product,
                          onAddToCart: addToCart,
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

  @override
  void dispose() {
    _bannerController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
