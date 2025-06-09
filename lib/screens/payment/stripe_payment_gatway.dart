import 'package:e_commerce_project/controllers/services/stripe_service.dart';
import 'package:flutter/material.dart';

class StripePaymentGatway extends StatelessWidget {
  const StripePaymentGatway({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stripe Payment")),

      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () async {
                await StripeService.instance.makePayment();
              },
              color: Colors.green,
              child: const Text("Purchase"),
            ),
          ],
        ),
      ),
    );
  }
}
