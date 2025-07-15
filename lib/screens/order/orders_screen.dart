import 'package:e_commerce_project/controllers/order/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<OrdersProvider>().fetchOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.tealAccent,
      ),
      body: Consumer<OrdersProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }
          if (provider.orders.isEmpty) {
            return Center(child: Text('No orders found'));
          }

          return ListView.builder(
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              final order = provider.orders[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order placed on: ${order.timestamp != null ? order.timestamp!.toLocal().toString() : 'Unknown'}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Payment Method: ${order.paymentMethod}'),
                      SizedBox(height: 8),
                      Text(
                        'Total Amount: \$${order.amount.toStringAsFixed(2)}',
                      ),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: order.products.length,
                        itemBuilder: (context, prodIndex) {
                          final product = order.products[prodIndex];
                          final productName = product['name'] ?? 'No Name';
                          final productQuantity = product['quantity'] ?? 1;

                          return ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                            ),
                            title: Text(productName),
                            subtitle: Text('Quantity: $productQuantity'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
