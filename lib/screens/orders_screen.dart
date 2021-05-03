import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_management/providers/orders.dart' show Orders;
import 'package:shop_management/widgets/app_drawer.dart';
import 'package:shop_management/widgets/order_item.dart';

class OrdersSCreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  _OrdersSCreenState createState() => _OrdersSCreenState();
}

class _OrdersSCreenState extends State<OrdersSCreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (c, i) => OrderItem(orderData.orders[i]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
