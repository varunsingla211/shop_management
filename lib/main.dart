import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_management/providers/cart.dart';
import 'package:shop_management/providers/orders.dart';
import 'package:shop_management/providers/products_provider.dart';
import 'package:shop_management/screens/cart_screen.dart';
import 'package:shop_management/screens/edit_product_screen.dart';
import 'package:shop_management/screens/orders_screen.dart';
import 'package:shop_management/screens/product_detail_screen.dart';
import 'package:shop_management/screens/product_overview_screen.dart';
import 'package:shop_management/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersSCreen.routeName: (ctx) => OrdersSCreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
