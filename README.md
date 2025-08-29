# ShopEase E-Commerce Project

ShopEase is a professional, production-ready Flutter e-commerce application built for cross-platform use (Mobile and Web). It integrates robust authentication, scalable state management, and multiple payment options including **SSLCommerz** and **Cash on Delivery (COD)**. The codebase follows modular best practices and is ready for extension and deployment.

---

## Table of Contents

- [Features](#features)
- [Architecture & Technologies](#architecture--technologies)
- [Project Structure](#project-structure)
- [State Management](#state-management)
- [Payment Methods](#payment-methods)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Plugins & Integrations](#plugins--integrations)
- [Resources](#resources)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Modern Shopping Experience:** Browse products, add to cart, wishlist, and checkout.
- **Authentication:** Secure login & registration using **Firebase Authentication**.
- **User Profile:** Profile storage using **Supabase Storage** including profile image upload.
- **Product Management:** Home screen with product listing, search bar, and filters.
- **Wishlist & Cart:** Add/remove items, persistent storage per user using Firestore.
- **Order Management:** Place orders and view order history.
- **Promotions:** Dynamic banners fetched from API.
- **Payment Methods:**
  - **SSLCommerz**: Online payment for Bangladesh users.
  - **Cash on Delivery (COD)**.
- **Cross-Platform:** Runs on Mobile and Web (Flutter).
- **Scalable State Management:** Provider for clean and reactive UI updates.
- **Clean Architecture:** Modular design with separation of services, providers, and models.

---

## Architecture & Technologies

- **Flutter:** Cross-platform UI and navigation.
- **Provider:** State management for products, banners, orders, wishlist, and cart.
- **Firebase:** Authentication, Firestore for real-time data.
- **Supabase:** Storage for user profile images.
- **SSLCommerz:** Payment integration for Bangladesh.
- **Dart:** Business logic, models, and services.

---

## Project Structure
```
lib/
controllers/
services/ # Firebase, Supabase, Wishlist, Orders, API
model/ # ProductModel, OrderModel, BannerModel, UserProfileModel, Reviews
repository/ # API repositories for products and banners
providers/ # ProductProvider, OrdersProvider, BannerProvider
screens/ # UI Screens: Home, ProductDetails, Cart, Checkout, Orders
payment/ # SSLCommerz & COD checkout screens
widgets/ # Reusable UI components
main.dart # App entry point and MultiProvider setup
assets/ # Images, fonts, banners
```

---

## State Management

ShopEase uses [Provider](https://pub.dev/packages/provider) for scalable state management:

- **ProductProvider:** Handles fetching products, search, filtering, and updates.
- **OrdersProvider:** Fetches user orders and manages order state.
- **BannerProvider:** Manages dynamic banners.
- **WishlistService:** Handles wishlist CRUD operations in Firestore.
- **UserProfileService:** Handles profile fetch, update, and image uploads via Supabase.

---

## Payment Methods

### SSLCommerz

- Integrated for online payments in Bangladesh.
- Supports bKash, Visa, MasterCard, etc.
- Secure payment flow with validation and error handling.
- Orders are saved automatically on successful transaction.
- Configuration stored in `lib/services/utils/api_url.dart`.

### Cash on Delivery (COD)

- Allows users to place orders without online payment.
- Orders saved in Firestore immediately.

---

## Getting Started

### 1. Configure API Credentials

Create `lib/services/utils/api_url.dart` and add:

- Firebase configuration
- Supabase URL & Key
- SSLCommerz Store ID & Password

### 2. Install Dependencies

```bash
flutter pub get
3. Set Up Firebase
Add firebase_options.dart for your platform.
Enable Authentication and Firestore in your Firebase project.
4. Run the App
flutter run


