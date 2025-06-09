import 'package:e_commerce_project/e_commerce_app.dart';
import 'package:e_commerce_project/firebase_options.dart';
import 'package:e_commerce_project/services/utils/api_url.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: ApiUrl.supbaseUrl,
    anonKey: ApiUrl.supabaseKey,
  );
  Stripe.publishableKey = ApiUrl.stripePublishableKey;

  runApp(const ECommerceApp());
}
