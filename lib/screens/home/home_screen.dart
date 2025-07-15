import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/controllers/banner/banner_provider.dart';
import 'package:e_commerce_project/controllers/product/product_provider.dart';
import 'package:e_commerce_project/controllers/services/auth_exception.dart';
import 'package:e_commerce_project/controllers/services/firebase_auth_service.dart';
import 'package:e_commerce_project/controllers/services/wishlist_service.dart';
import 'package:e_commerce_project/model/product_model.dart';
import 'package:e_commerce_project/screens/authentication/login_screen.dart';
import 'package:e_commerce_project/screens/cart/cart_screen.dart';
import 'package:e_commerce_project/screens/prdouct/product_details_screen.dart';
import 'package:e_commerce_project/screens/wishlist/wishlist_screen.dart';
import 'package:e_commerce_project/widgets/confirm_dialog.dart';
import 'package:e_commerce_project/widgets/home_app_bar_drawer.dart';
import 'package:e_commerce_project/widgets/product_card.dart';
import 'package:e_commerce_project/widgets/toast_meesage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ProductModel> _cartItems = [];

  final TextEditingController _searchTEController = TextEditingController();
  late PageController _bannerController;
  int _currentIndex = 0;
  Timer? _timer;
  final _firebaseAuthService = FirebaseAuthService();
  double minPrice = 0;
  double maxPrice = 1000;
  double selectedRating = 0;

  @override
  void initState() {
    super.initState();
    // futureProducts = ApiServices().fetchProudctsDummy();
    _bannerController = PageController(viewportFraction: 0.9, initialPage: 0);

    Future.microtask(() {
      context.read<BannerProvider>().fetchBanner();
      context.read<ProductProvider>().fetchProducts();
    });

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      final bannerCount = context.read<BannerProvider>().banners.length;

      if (bannerCount == 0) return;

      setState(() {
        _currentIndex = (_currentIndex + 1) % bannerCount;
      });

      _bannerController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void addToCart(ProductModel product) {
    setState(() {
      _cartItems.add(product);
    });

    ToastMeesage.showToastMessage(context, "${product.name} added to cart!");
  }

  void openCart() async {
    final updatedCart = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: _cartItems),
      ),
    );
    if (updatedCart != null) {
      setState(() {
        _cartItems.clear();
        _cartItems.addAll(updatedCart);
      });
    }
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
      drawer: HomeAppBarDrawer(cartItem: _cartItems, signOut: () => _signOut()),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Shop-Ease', style: TextStyle(fontSize: 14)),
        backgroundColor: Colors.deepPurple,
        actions: [
          _buildAppBarWishList(context),

          _buildAppBarCart(),
          TextButton.icon(
            icon: Icon(Icons.filter_alt, color: Colors.white),
            onPressed: _showFilterModelSheet,
            label: Text("Filter", style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.yellow),
            onPressed: () {
              ConfirmDialog.showAlertDialogue(
                context,
                title: "Sign Out",
                content: "Are you sure you want to log-out?",
                confirmString: "Log-out",
                onPressed: () {
                  _signOut();
                },
              );
            },
            icon: Icon(Icons.logout, size: 20),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 5),

          Consumer<BannerProvider>(
            builder: (context, bannerProvider, child) {
              if (bannerProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (bannerProvider.error != null) {
                return Center(child: Text(bannerProvider.error!));
              }
              final banners = bannerProvider.banners;
              // log("Home Banner: ${banners.toList()}");

              if (banners.isEmpty) {
                return const Center(child: Text("No Banners"));
              }

              return SizedBox(
                height: 140,

                child: PageView.builder(
                  controller: _bannerController,
                  onPageChanged:
                      (index) => setState(() => _currentIndex = index),
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return _buildBanner(banner.imageUrl, banner.title);
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),

            child: TextField(
              controller: _searchTEController,
              onChanged:
                  (query) =>
                      context.read<ProductProvider>().filterProducts(query),
              decoration: InputDecoration(
                hintText: "Search Products",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final products = productProvider.filteredProducts;

                // final products = productProvider.products;

                // log("Home Products ${products.toList()}");

                if (productProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (productProvider.error != null) {
                  return Center(child: Text(productProvider.error!));
                }

                if (products.isEmpty) {
                  return const Center(child: Text('No Products found'));
                }
                return GridView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    ProductDetailsScreen(products: product),
                          ),
                        );
                      },
                      child: ProductCard(
                        product: product,
                        onAddToCart: addToCart,
                        addToCartIcon: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarWishList(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WishlistScreen()),
            );
            setState(() {});
          },
          icon: Icon(Icons.favorite_border, color: Colors.white, size: 25),
        ),

        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: WishlistService.wishListStream(),

          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container();
            }

            final wishListCount = snapshot.data!.docs.length;

            return Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  "$wishListCount",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppBarCart() {
    return Stack(
      children: [
        IconButton(
          onPressed: openCart,

          icon: Icon(Icons.shopping_cart, color: Colors.white, size: 25),
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

  void _showFilterModelSheet() {
    final productProvider = context.read<ProductProvider>();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Price Range: \$${minPrice.toInt()} - \$${maxPrice.toInt()}",
                  ),

                  RangeSlider(
                    min: 0.0,
                    max: 2000.0,
                    divisions: 20,

                    values: RangeValues(minPrice, maxPrice),
                    onChanged: (value) {
                      setState(() {
                        minPrice = value.start;
                        maxPrice = value.end;
                      });
                    },
                  ),
                  SizedBox(height: 12),

                  Text("Minimum Rating: ${selectedRating.toStringAsFixed(1)}"),

                  Slider(
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: selectedRating.toString(),
                    value: selectedRating,
                    onChanged: (val) {
                      setState(() {
                        selectedRating = val;
                      });
                    },
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            productProvider.applyFilters(
                              minPrice: minPrice,
                              maxPrice: maxPrice,
                              minRating: selectedRating,
                            );
                          },
                          child: const Text("Apply Filters"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              minPrice = 0;
                              maxPrice = 1000;
                              selectedRating = 0;
                            });
                            productProvider.resetFilters();
                          },
                          child: const Text("Reset"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _timer?.cancel();
    _searchTEController.dispose();
    super.dispose();
  }
}
