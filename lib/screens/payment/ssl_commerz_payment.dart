import 'dart:convert';
import 'dart:developer';

import 'package:e_commerce_project/controllers/services/order_service.dart';
import 'package:e_commerce_project/services/utils/api_url.dart';
import 'package:e_commerce_project/widgets/toast_meesage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';

class SslCommerzPayment extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final double amount;
  final String address;
  final String phone;

  const SslCommerzPayment({
    super.key,
    required this.products,
    required this.amount,
    required this.address,
    required this.phone,
  });

  Future<void> sslCommerz(BuildContext context) async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        multi_card_name: "visa,master,bkash",
        currency: SSLCurrencyType.BDT,
        product_category: "E-commerce Product",
        sdkType: SSLCSdkType.TESTBOX,
        store_id: ApiUrl.sslStoreId,
        store_passwd: ApiUrl.sslStorePass,
        total_amount: amount,
        tran_id: "TRLXT980701",
      ),
    );
    final response = await sslcommerz.payNow();
    if (response.status == 'VALID') {
      log(jsonEncode(response));
      log("Payment Completed SSL:  ${response.tranId}");
      log(response.tranDate ?? '');
      await OrderService.saveOrder(
        products: products,
        amount: amount,
        address: address,
        phone: phone,
        paymentMethod: "SSlCommerz",
      );
      Navigator.pop(context, true);
    }
    if (response.status == 'Closed') {
      log("Payment ssl Closed");
      ToastMeesage.showToastMessage(context, "Payment Closed.");
    }
    if (response.status == "FAILED") {
      ToastMeesage.showToastMessage(context, "Payment Failed.");
      log("Payment ssl failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SSlCommerz")),
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
              sslCommerz(context);
            },
            child: Text("Pay \$${amount.toStringAsFixed(2)} via SSL"),
          ),
        ),
      ),
    );
  }
}
