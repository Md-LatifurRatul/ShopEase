import 'package:e_commerce_project/model/products_item.dart';
import 'package:e_commerce_project/screens/checkout_screen.dart';
import 'package:e_commerce_project/widgets/confirm_dialog.dart';
import 'package:e_commerce_project/widgets/toast_meesage.dart';

import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.cartItems});

  final List<ProductsItem> cartItems;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // void _removeItem(int index) {
  //   setState(() {
  //     widget.cartItems.removeAt(index);
  //   });
  // }

  Map<ProductsItem, int> cartQuantity = {};

  @override
  void initState() {
    super.initState();
    _initializerCart();
  }

  void _initializerCart() {
    for (var item in widget.cartItems) {
      if (cartQuantity.containsKey(item)) {
        cartQuantity[item] = (cartQuantity[item] ?? 0) + 1;
      } else {
        cartQuantity[item] = 1;
      }
    }
  }

  void _incrementItem(ProductsItem item) {
    setState(() {
      cartQuantity[item] = cartQuantity[item]! + 1;
    });
  }

  void _decrementItem(ProductsItem item) {
    setState(() {
      if (cartQuantity.containsKey(item)) {
        if (cartQuantity[item]! > 1) {
          cartQuantity[item] = cartQuantity[item]! - 1;
        } else {
          cartQuantity.remove(item);
          widget.cartItems.remove(item);
        }
      }
    });
  }

  double getTotalPrice() {
    double total = 0.0;
    cartQuantity.forEach((item, quantity) {
      total += (item.price! * quantity);
    });
    return total;
  }

  Future<void> _checkout() async {
    if (widget.cartItems.isEmpty) {
      ToastMeesage.showToastMessage(context, 'Cart is empty!');
      return;
    }

    bool? orderPlaced = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cartItems: cartQuantity),
      ),
    );

    if (orderPlaced == true) {
      setState(() {
        widget.cartItems.clear();
        cartQuantity.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),

      body:
          widget.cartItems.isEmpty
              ? Center(child: Text('Your cart is empty'))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.cartItems[index];
                        return ListTile(
                          leading: Image.network(
                            widget.cartItems[index].thumbnail ?? "",
                          ),
                          title: Text(widget.cartItems[index].title ?? ""),
                          subtitle: Text(
                            "\$${widget.cartItems[index].price?.toStringAsFixed(2) ?? "0..00"}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _decrementItem(item),
                                icon: Icon(Icons.remove_circle),
                              ),

                              Text(cartQuantity[item]!.toString()),

                              IconButton(
                                onPressed: () => _incrementItem(item),
                                icon: Icon(Icons.add_circle),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      children: [
                        Text(
                          "\$${getTotalPrice().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              ConfirmDialog.showAlertDialgoue(
                                context,
                                title: "Continue Checkout",
                                content: "Do you want to checkout?",
                                onPressed: () async {
                                  await _checkout();
                                },
                              );
                            },
                            child: Text(
                              'checkout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
