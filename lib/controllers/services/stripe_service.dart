import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_commerce_project/services/utils/api_url.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment() async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(10, "usd");
      // log(result.toString());
      print(paymentIntentClientSecret);

      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "RTL Islam",
        ),
      );
      await _proceedPayment();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      var response = await dio.post(
        ApiUrl.createPaymentIntentUrl,
        data: data,

        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer ${ApiUrl.stripeSecretKey}",
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );
      print(response);

      if (response.data != null) {
        print(response.data);
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<void> _proceedPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

  String _calculateAmount(int amount) {
    final calcAmount = amount * 100;
    return calcAmount.toString();
  }
}
