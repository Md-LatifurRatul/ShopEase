import 'package:e_commerce_project/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce',
      debugShowCheckedModeBanner: false,
      // home: HomeScreen(),
      home: const SplashScreen(),
    );
  }
}
