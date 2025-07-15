import 'package:e_commerce_project/controllers/services/firebase_auth_service.dart';
import 'package:e_commerce_project/model/product_model.dart';
import 'package:e_commerce_project/screens/cart/cart_screen.dart';
import 'package:e_commerce_project/screens/order/orders_screen.dart';
import 'package:e_commerce_project/screens/profile/profile_screen.dart';
import 'package:e_commerce_project/screens/wishlist/wishlist_screen.dart';
import 'package:e_commerce_project/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';

class HomeAppBarDrawer extends StatelessWidget {
  const HomeAppBarDrawer({
    super.key,
    required this.cartItem,
    required this.signOut,
  });
  final List<ProductModel> cartItem;
  final VoidCallback signOut;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuthService();
    final currentUser = user.currentUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
            ),
            accountName: Text(currentUser?.displayName ?? "User name"),
            accountEmail: Text(currentUser?.email ?? ""),
            decoration: BoxDecoration(color: Colors.deepPurple),
          ),

          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("My Cart"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartScreen(cartItems: cartItem),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("My Wishlist"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WishlistScreen()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("My Orders"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrdersScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              ConfirmDialog.showAlertDialogue(
                context,
                title: "Sign Out",
                content: "Are you sure you want to log-out?",
                confirmString: "Log-out",
                onPressed: () {
                  signOut();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
