import 'package:e_commerce_project/controllers/banner/banner_provider.dart';
import 'package:e_commerce_project/controllers/order/orders_provider.dart';
import 'package:e_commerce_project/controllers/product/product_provider.dart';
import 'package:e_commerce_project/e_commerce_app.dart';
import 'package:e_commerce_project/services/utils/api_url.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: ApiUrl.supbaseUrl,
    anonKey: ApiUrl.supabaseKey,
  );
  // Stripe.publishableKey = ApiUrl.stripePublishableKey;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),

        ChangeNotifierProvider<BannerProvider>(create: (_) => BannerProvider()),

        ChangeNotifierProvider<OrdersProvider>(create: (_) => OrdersProvider()),
      ],
      child: const ECommerceApp(),
    ),
  );
}
