import 'package:e_commerce_project/controllers/services/order_service.dart';
import 'package:e_commerce_project/model/product_model.dart';
import 'package:e_commerce_project/screens/payment/ssl_commerz_payment.dart';
import 'package:e_commerce_project/screens/payment/stripe_payment_gatway.dart';
import 'package:e_commerce_project/widgets/confirm_dialog.dart';
import 'package:e_commerce_project/widgets/toast_meesage.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.cartItems});

  final Map<ProductModel, int> cartItems;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = "Cash on Delivery";

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();
  List<Map<String, dynamic>> products = [];

  double getTotalPrice() {
    double total = 0.0;

    widget.cartItems.forEach((item, quantity) {
      total += (item.price * quantity);
    });

    return total;
  }

  void paymentProducts() {
    products =
        widget.cartItems.entries.map((entry) {
          final product = entry.key;
          final quantity = entry.value;
          return {
            'name': product.name,
            'price': product.price,
            'quantity': quantity,
          };
        }).toList();
  }

  void _confirmOrder() {
    if (_addressController.text.isEmpty || _phoneController.text.isEmpty) {
      ToastMeesage.showToastMessage(
        context,
        "Please enter address and phone number",
      );
      return;
    }
    if (_selectedPaymentMethod == "Stripe") {
      ConfirmDialog.showAlertDialogue(
        context,
        title: 'Proceed To Payment',
        content: "Do you want confirm Order?",
        confirmString: "Yes, Confirm",
        onPressed: () async {
          // ToastMeesage.showToastMessage(context, "Order placed succesfully");
          Navigator.pop(context);
          // Todo: Payment Gateway Integration
          final paymentResult = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => StripePaymentGateway(
                    products:
                        widget.cartItems.entries.map((entry) {
                          final product = entry.key;
                          final quantity = entry.value;
                          return {
                            'name': product.name,
                            'price': product.price,
                            'quantity': quantity,
                          };
                        }).toList(),
                    amount: getTotalPrice(),
                    address: _addressController.text,
                    phone: _phoneController.text,
                  ),
            ),
          );
          if (paymentResult == true) {
            widget.cartItems.clear();
            ToastMeesage.showToastMessage(
              context,
              "Order placed successfully.",
            );
            Navigator.pop(context, true);
          } else {
            ToastMeesage.showToastMessage(context, "Payment was cancelled.");
          }
        },
      );
    }
    // } else if (_selectedPaymentMethod == "Bkash") {
    //   ToastMeesage.showToastMessage(context, "bKash payment coming soon!");
    else if (_selectedPaymentMethod == "Cash on Delivery") {
      ConfirmDialog.showAlertDialogue(
        context,
        title: 'Confirm Order',
        content: "Place order with Cash on Delivery?",
        confirmString: "Yes, Confirm",
        onPressed: () async {
          ToastMeesage.showToastMessage(context, "Order placed successfully");

          await OrderService.saveOrder(
            products: products,
            amount: getTotalPrice(),
            address: _addressController.text,
            phone: _phoneController.text,
            paymentMethod: "Cash on Deleivery",
          );

          Navigator.pop(context, true);
        },
      );
    } else if (_selectedPaymentMethod == "SslCommerz") {
      ConfirmDialog.showAlertDialogue(
        context,
        title: 'Confirm Order',
        content: "Place order with Cash on Delivery?",
        confirmString: "Yes, Confirm",
        onPressed: () async {
          Navigator.pop(context);
          final paymentResult = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => SslCommerzPayment(
                    products:
                        widget.cartItems.entries.map((entry) {
                          final product = entry.key;
                          final quantity = entry.value;
                          return {
                            'name': product.name,
                            'price': product.price,
                            'quantity': quantity,
                          };
                        }).toList(),
                    amount: getTotalPrice(),
                    address: _addressController.text,
                    phone: _phoneController.text,
                  ),
            ),
          );
          if (paymentResult == true) {
            widget.cartItems.clear();
            ToastMeesage.showToastMessage(
              context,
              "Order placed successfully.",
            );
            Navigator.pop(context, true);
          } else {
            ToastMeesage.showToastMessage(context, "Payment was cancelled.");
          }
        },
      );
    } else {
      ToastMeesage.showToastMessage(
        context,
        "Please select a valid payment method.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shipping Address",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(hintText: "Enter your address"),
            ),
            const SizedBox(height: 10),

            Text(
              "Phone Number",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: "Enter your phone number"),
            ),

            const SizedBox(height: 10),
            Text(
              "Payment Method",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            DropdownButton<String>(
              value: _selectedPaymentMethod,

              items:
                  ["Cash on Delivery", "Stripe", "SslCommerz"]
                      .map(
                        (method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),

            const SizedBox(height: 20),
            Text(
              "Total: \$${getTotalPrice().toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                _confirmOrder();
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(child: Text("Confirm Order")),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
