# ShopEase E-Commerce Project

ShopEase is a professional, production-ready Flutter e-commerce application built for cross-platform use (Mobile and Web). It integrates robust authentication, scalable state management, and multiple payment gateways including SSLCommerz and Stripe. The codebase follows modular best practices and is ready for extension and deployment.

---

## Table of Contents

- [Features](#features)
- [Architecture & Technologies](#architecture--technologies)
- [Project Structure](#project-structure)
- [State Management](#state-management)
- [Payment Gateways](#payment-gateways)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Plugins & Integrations](#plugins--integrations)
- [Resources](#resources)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Modern Shopping Experience:** Browse products, add to cart, checkout, and track orders.
- **Authentication:** Secure login & registration using Firebase and Supabase.
- **Order Management:** Real-time order placement and history.
- **Promotions:** Dynamic banner system for marketing and updates.
- **Multiple Payment Gateways:**
  - **SSLCommerz:** Bangladesh’s leading gateway (Visa, MasterCard, bKash, and more).
  - **Stripe:** Global card payments.
  - **Cash on Delivery** option.
- **Cross-Platform:** Runs on Mobile and Web (Flutter support).
- **Scalable State Management:** Uses Provider for clean, reactive state updates.
- **Clean Architecture:** Separation of concerns using controllers, services, and models.
- **Extensible:** Easily add new features thanks to modular design.

---

## Architecture & Technologies

- **Flutter**: UI, navigation, and cross-platform support.
- **Provider**: State management for products, orders, banners, and authentication.
- **Firebase**: Authentication, Firestore for real-time data.
- **Supabase**: Backend services.
- **Stripe**: Payment gateway integration.
- **SSLCommerz**: Payment gateway integration for Bangladesh.
- **Dart**: All business logic and model definitions.

---

## Project Structure

```
lib/
  controllers/         # Business logic and services (products, orders, banners)
  model/               # Data models (ProductModel, OrderModel, etc.)
  screens/             # UI screens (Home, Cart, Payment, Checkout)
    payment/           # Payment gateway screens (Stripe, SSLCommerz)
  services/
    utils/             # Utility classes (api_url.dart for credentials)
  widgets/             # Reusable UI components
  main.dart            # App entry point, providers setup
  e_commerce_app.dart  # Main application widget
assets/                # Images, fonts, etc.
```

---

## State Management

ShopEase uses [Provider](https://pub.dev/packages/provider) for scalable state management:

- **ProductProvider:** Handles product list, details, and updates.
- **OrderProvider:** Manages order placement, retrieval, and updates.
- **BannerProvider:** Controls banners and marketing content.
- **Usage:** Providers are initialized via `MultiProvider` in `main.dart` for easy access throughout the app.

---

## Payment Gateways

### SSLCommerz

- Integrated via [`flutter_sslcommerz`](https://pub.dev/packages/flutter_sslcommerz).
- Supports Visa, MasterCard, bKash, and more.
- Secure payment flow with validation and error handling.
- Orders are saved automatically on successful transaction.
- Configuration: Store credentials in `lib/services/utils/api_url.dart`.

### Stripe

- Card-based payments.
- Integrated using Stripe API and Flutter packages.
- Secure and easy to use.
- Configuration: Stripe keys in `lib/services/utils/api_url.dart`.

### Cash on Delivery

- Simple order placement without online payment.

**Checkout Flow:**  
Users can select their preferred payment method at checkout.  
All logic handled in `lib/screens/payment/checkout_screen.dart`.

---

## Getting Started

### 1. Configure API Credentials

- Create `lib/services/utils/api_url.dart` and add your credentials:
  - Supabase URL & Key
  - Firebase options
  - Stripe Keys
  - SSLCommerz Store ID & Pass

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Set Up Firebase

- Add your `firebase_options.dart` for the current platform.
- Configure your Firebase project and enable Authentication and Firestore.

### 4. Run the App

```bash
flutter run
```

---

## Plugins & Integrations

- **Authentication:** `firebase_auth`, `supabase_flutter`
- **Database:** `cloud_firestore`
- **Payments:** `stripe`, `flutter_sslcommerz`
- **State Management:** `provider`
- **UI & Utilities:** `url_launcher`, file selectors, custom widgets

---

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Codelabs](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Provider Package](https://pub.dev/packages/provider)
- [SSLCommerz for Flutter](https://pub.dev/packages/flutter_sslcommerz)
- [Stripe for Flutter](https://pub.dev/packages/flutter_stripe)

---

## Contributing

Contributions are welcome!  
- Fork the repository
- Create your feature branch (`git checkout -b feature/my-feature`)
- Commit your changes
- Open a pull request

For any issues, please open a [GitHub Issue](https://github.com/Md-LatifurRatul/ShopEase/issues).

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---
