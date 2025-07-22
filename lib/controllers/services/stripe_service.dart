// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:e_commerce_project/services/utils/api_url.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// class StripeService {
//   StripeService._();

//   static final StripeService instance = StripeService._();

//   Future<bool> makePayment(double amount) async {
//     try {
//       final paymentIntentClientSecret = await _createPaymentIntent(
//         amount,
//         "usd",
//       );
//       // log(result.toString());
//       print(paymentIntentClientSecret);

//       if (paymentIntentClientSecret == null) return false;
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntentClientSecret,
//           merchantDisplayName: "RTL Islam",
//         ),
//       );
//       await _proceedPayment();
//       return true;
//     } catch (e) {
//       log(e.toString());
//       return false;
//     }
//   }

//   Future<String?> _createPaymentIntent(double amount, String currency) async {
//     try {
//       final Dio dio = Dio();
//       Map<String, dynamic> data = {
//         "amount": _calculateAmount(amount),
//         "currency": currency,
//         'payment_method_types[]': 'card',
//       };

//       final response = await dio.post(
//         ApiUrl.createPaymentIntentUrl,
//         data: data,

//         options: Options(
//           contentType: Headers.formUrlEncodedContentType,
//           headers: {
//             "Authorization": "Bearer ${ApiUrl.stripeSecretKey}",
//             "Content-Type": "application/x-www-form-urlencoded",
//           },
//         ),
//       );
//       print(response);

//       return response.data["client_secret"];
//     } catch (e) {
//       log(e.toString());
//     }
//     return null;
//   }

//   Future<void> _proceedPayment() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//     } catch (e) {
//       print(e);
//     }
//   }

//   String _calculateAmount(double amount) {
//     return (amount * 100).toInt().toString();
//   }
// }
