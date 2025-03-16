import 'package:e_commerce_project/model/products_item.dart';
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
    for (var item in widget.cartItems) {
      cartQuantity[item] = (cartQuantity[item] ?? 0) + 1;
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

                    child: Text(
                      "\$${getTotalPrice().toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
