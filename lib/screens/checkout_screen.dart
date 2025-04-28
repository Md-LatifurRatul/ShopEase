import 'package:e_commerce_project/model/products_item.dart';
import 'package:e_commerce_project/widgets/confirm_dialog.dart';
import 'package:e_commerce_project/widgets/toast_meesage.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.cartItems});

  final Map<ProductsItem, int> cartItems;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = "Cash on Delivery";

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  double getTotalPrice() {
    double total = 0.0;

    widget.cartItems.forEach((item, quantity) {
      total += (item.price! * quantity);
    });

    return total;
  }

  void _confirmOrder() {
    if (_addressController.text.isEmpty || _phoneController.text.isEmpty) {
      ToastMeesage.showToastMessage(
        context,
        "Please enter address and phone number",
      );
      return;
    } else {
      ConfirmDialog.showAlertDialogue(
        context,
        title: 'Proceed To Payment',
        content: "Do you want confirm Order?",
        confirmString: "Yes, Confirm",
        onPressed: () {
          ToastMeesage.showToastMessage(context, "Order placed succesfully");
          Navigator.pop(context, true);
          // Todo: Payment Gateway Integration
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => PaymentGatway()),
          // );
        },
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
                  ["Cash on Delivery", "Credit Card", "Bkash", "Nagad"]
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
