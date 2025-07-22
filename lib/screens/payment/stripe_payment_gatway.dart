import 'package:flutter/material.dart';

class StripePaymentGateway extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final double amount;
  final String address;
  final String phone;

  const StripePaymentGateway({
    super.key,
    required this.products,
    required this.amount,
    required this.address,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stripe Payment")),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              // final success = await StripeService.instance.makePayment(amount);
              // if (success) {
              //   await OrderService.saveOrder(
              //     products: products,
              //     amount: amount,
              //     address: address,
              //     phone: phone,
              //     paymentMethod: "Stripe",
              //   );

              //   Navigator.pop(context, true);
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(builder: (context) => HomeScreen()),
              //   (route) => false,
              // );
              // } else {
              //   Navigator.pop(context, false);
              //   // ToastMeesage.showToastMessage(context, "Payment failed!");
              // }
            },
            child: Text("Pay \$${amount.toStringAsFixed(2)} via Stripe"),
          ),
        ),
      ),
    );
  }
}
